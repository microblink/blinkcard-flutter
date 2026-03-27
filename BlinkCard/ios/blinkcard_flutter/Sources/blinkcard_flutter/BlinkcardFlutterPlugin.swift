import Flutter
import UIKit
import BlinkCard
import BlinkCardUX
import Combine
import SwiftUI

public class BlinkCardFlutterPlugin: NSObject , FlutterPlugin {
    
    private var blinkCardSdk: BlinkCardSdk?
    private var cancellables = Set<AnyCancellable>()
    private var rootVc: UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: BlinkCardArguments.packageName, binaryMessenger: registrar.messenger())
        let instance = BlinkCardFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handleMethodPlatformChannelCall(call, result)
    }
    
    private func handleMethodPlatformChannelCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch BlinkCardPlatformMethods(rawValue: call.method) {
        case .performScan: Task { await performScan(call, result) }
        case .performDirectApiScan: Task { await performDirectApiScan(call, result) }
        case .loadSdk: Task { await loadSdk(call, result) }
        case .unloadSdk: Task { await unloadSdk(call, result) }
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func ensureLoadedSdk(blinkCardSdkSettings: [String: Any]) async throws -> BlinkCardSdk? {
        if let blinkCardSdk { return blinkCardSdk}
        let sdkSettings = try BlinkCardDeserializationUtils.deserializeSdkSettings(blinkCardSdkSettings)
        blinkCardSdk = try await BlinkCardSdk.createBlinkCardSdk(withSettings: sdkSettings)
        return blinkCardSdk
    }
    
    private func performScan(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) async {
        
        do {
            guard let arguments = call.arguments as? [String: Any] else {
                throw BlinkCardFlutterError.invalidArgumentsProvided
            }
            
            guard let sdkSettingsRaw = arguments[BlinkCardArguments.sdkSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.invalidSettingsProvided(message: "SDK settings")
            }
            
            guard let blinkCardSdk = try await ensureLoadedSdk(blinkCardSdkSettings: sdkSettingsRaw) else {
                throw BlinkCardFlutterError.error(message: "The BlinkCard SDK is not initialized. Call the loadSdk() method to pre-load the SDK first, or try running the performScan() method with a valid internet connection.")
            }
            
            guard let sessionSettingsRaw = arguments[BlinkCardArguments.sessionSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.invalidSettingsProvided(message: "BlinkCard session settings")
            }
            
            let sessionSettings = BlinkCardDeserializationUtils.deserializeSessionSettings(sessionSettingsRaw)
            guard let uxSettingsRaw = arguments[BlinkCardArguments.scanningUxSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.invalidSettingsProvided(message: "Scanning UX settings")
            }
            
            let uxSettings = BlinkCardDeserializationUtils.deserializeScanningUxSettings(uxSettingsRaw)
            
            let analyzer = try await BlinkCardAnalyzer(sdk: blinkCardSdk, blinkCardSessionSettings: sessionSettings, eventStream: BlinkCardEventStream())
            
            let scanningUxModel = await BlinkCardUXModel(analyzer: analyzer, uxSettings: uxSettings)
            await addBlinkCardFlutterPinglet(with: analyzer.sessionNumber)
            
            await scanningUxModel.$result
                .sink { [weak self] blinkCardResultState in
                    if let blinkCardResultState {
                        if let scanningResult = blinkCardResultState.scanningResult {
                            DispatchQueue.main.async {
                                result(BlinkCardSerializationUtils.serializeBlinkCardScanningResult(scanningResult))
                                self?.rootVc?.dismiss(animated: true)
                            }
                        } else {
                            result(FlutterError(code: BlinkCardArguments.blinkCardError, message: BlinkCardFlutterError.cancelled.localizedDescription , details: nil))
                            self?.rootVc?.dismiss(animated: true)
                        }
                    }
                }
                .store(in: &cancellables)
            
            presentScanningUi(model: scanningUxModel)
            
        } catch {
            handleSdkError(error, result)
        }
    }
    
    private func performDirectApiScan(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) async {
        do {
            guard let arguments = call.arguments as? [String: Any],
                  let sdkSettigns = arguments[BlinkCardArguments.sdkSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.invalidSettingsProvided(message: "BlinkCard SDK settings")
            }
            
            guard let blinkCardSdk = try await ensureLoadedSdk(blinkCardSdkSettings: sdkSettigns) else {
                throw BlinkCardFlutterError.error(message: "The BlinkCard SDK is not initialized. Call the loadSdk() method to pre-load the SDK first, or try running the performDirectApiScan() method with a valid internet connection.")
            }
            
            guard let sessionSettingsRaw = arguments[BlinkCardArguments.sessionSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.invalidSettingsProvided(message: "BlinkCard Session settings")
            }
            var sessionSettings = BlinkCardDeserializationUtils.deserializeSessionSettings(sessionSettingsRaw)
            sessionSettings.inputImageSource = .photo
            
            let session = try await blinkCardSdk.createScanningSession(sessionSettings: sessionSettings)
            await addBlinkCardFlutterPinglet(with: session.getSessionNumber())
            
            guard let firstSideImage = BlinkCardDeserializationUtils.deserializeBase64Image(arguments["firstSideImage"] as? String) else {
                throw BlinkCardFlutterError.imageIsEmpty(message: "Invalid first side image provided!")
            }
            
            try await session.process(inputImage: InputImage(uiImage: firstSideImage))
            
            if let secondSideImage = BlinkCardDeserializationUtils.deserializeBase64Image(arguments["secondSideImage"] as? String) {
                try await session.process(inputImage: InputImage(uiImage: secondSideImage))
            }
            
            let blinkCardResult = await session.getResult()
            DispatchQueue.main.async {
                result(BlinkCardSerializationUtils.serializeBlinkCardScanningResult(blinkCardResult))
            }
        } catch {
            handleSdkError(error, result)
        }
    }
    
    private func loadSdk(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) async {
        do {
            guard let arguments = call.arguments as? [String: Any],
                  let blinkCardSdkSettings = arguments[BlinkCardArguments.sdkSettings] as? [String: Any] else {
                throw BlinkCardFlutterError.error(message: "BlinkCard SDK settings")
            }
            
            let _ = try await ensureLoadedSdk(blinkCardSdkSettings: blinkCardSdkSettings)
            result(true)
        } catch {
            handleSdkError(error, result)
        }
    }
    
    private func unloadSdk(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) async {
        guard let arguments = call.arguments as? [String: Any],
              let deleteResources = arguments["deleteCachedResources"] as? Bool else {
            result(FlutterError(code: BlinkCardArguments.blinkCardError, message: BlinkCardFlutterError.invalidArgumentsProvided.localizedDescription , details: nil))
            return
        }
        
        if deleteResources {
            await BlinkCardSdk.terminateBlinkCardSdkAndDeleteCachedResources()
        } else {
            await BlinkCardSdk.terminateBlinkCardSdk()
        }
        
        blinkCardSdk = nil
        result(true)
    }
    
    private func addBlinkCardFlutterPinglet(with sessionNumber: Int) async {
        await PingManager.shared
            .addPinglet(pinglet: WrapperProductInfoPinglet(wrapperProduct: .crossplatformflutter), sessionNumber: sessionNumber)
    }
    
    private func handleSdkError(_ error: Error, _ result: @escaping FlutterResult) {
        switch error {
        case let flutterError as BlinkCardFlutterError:
             result(FlutterError(
                code: BlinkCardArguments.blinkCardError,
                message: flutterError.errorDescription ?? flutterError.localizedDescription,
                details: nil))
            
        case let licenseError as InvalidLicenseKeyError:
            result(FlutterError(
                code: BlinkCardArguments.blinkCardError,
                message: licenseError.message,
                details: nil))
            
        default:
            result(FlutterError(
                code: BlinkCardArguments.blinkCardError,
                message: error.localizedDescription,
                details: nil))
        }
    }
}

extension BlinkCardFlutterPlugin {
    private func presentScanningUi(model: BlinkCardUXModel) {
        DispatchQueue.main.async {
            guard let rootVc = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController else {
                return
            }
            
            self.rootVc = rootVc
            
            let hostingVc = UIHostingController(rootView: BlinkCardUXView(viewModel: model))
            hostingVc.modalPresentationStyle = .fullScreen
            self.rootVc?.present(hostingVc, animated: true)
        }
    }
}
