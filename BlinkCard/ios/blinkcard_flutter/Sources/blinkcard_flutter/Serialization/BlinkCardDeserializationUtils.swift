//
//  BlinkCardDeserializationUtils.swift
//  blinkcard_flutter
//
//  Created by Milan Parađina on 27.02.2026..
//

import Foundation
import UIKit
import BlinkCard
import BlinkCardUX

struct BlinkCardDeserializationUtils {

    private static let defaultResourceDownloadUrl = "https://models.cdn.microblink.com/resources"
    private static let defaultResourcesLocalFolder = "MLModels"
    
    static func deserializeSdkSettings(_ sdkSettingsDict: [String: Any]) throws -> BlinkCardSdkSettings {
        guard let licenseKey = sdkSettingsDict["licenseKey"] as? String, !licenseKey.isEmpty else {
            throw BlinkCardFlutterError.invalidLicenseKeyProvided
        }
        
        var blinkCardSdkSettings = BlinkCardSdkSettings(licenseKey: licenseKey)
        
        if let licensee = sdkSettingsDict["licensee"] as? String {
            blinkCardSdkSettings.licensee = licensee
        }
        
        if let helloLog = sdkSettingsDict["helloLogEnabled"] as? Bool {
            blinkCardSdkSettings.helloLogEnabled = helloLog
        }

        if let microblinkProxyUrl = sdkSettingsDict["microblinkProxyUrl"] as? String {
            blinkCardSdkSettings.microblinkProxyURL = microblinkProxyUrl
        }

        blinkCardSdkSettings.resourcesConfiguration = deserializeResourcesConfiguration(sdkSettingsDict)

        return blinkCardSdkSettings
    }

    static func deserializeResourcesConfiguration(_ sdkSettingsDict: [String: Any]) -> ResourcesConfig {
        let download = sdkSettingsDict["downloadResources"] as? Bool ?? true

        let serviceUrl = sdkSettingsDict["resourceDownloadUrl"] as? String
            ?? defaultResourceDownloadUrl

        let localFolder = sdkSettingsDict["resourceLocalFolder"] as? String
            ?? defaultResourcesLocalFolder

        var bundleUrl: URL?
        if let bundleIdentifier = sdkSettingsDict["bundleIdentifier"] as? String,
           let bundle = Bundle(identifier: bundleIdentifier) {
            bundleUrl = bundle.bundleURL
        }

        var requestTimeout = RequestTimeout.default
        if let resourceRequestTimeoutMs = sdkSettingsDict["resourceRequestTimeout"] as? NSNumber {
            let timeoutSeconds = resourceRequestTimeoutMs.doubleValue / 1000.0
            requestTimeout = RequestTimeout(
                connectionTimeout: timeoutSeconds,
                readTimeout: timeoutSeconds,
                writeTimeout: timeoutSeconds
            )
        }

        return ResourcesConfig(
            download: download,
            serviceUrl: serviceUrl,
            localFolder: localFolder,
            requestTimeout: requestTimeout,
            bundleUrl: bundleUrl
        )
    }
    
    private static func timeIntervalFromMillis(_ timeoutMillis: Int) -> TimeInterval {
        TimeInterval(timeoutMillis) / 1000.0
    }

    static func deserializeSessionSettings(_ sessionSettingsDict: [String: Any]) -> BlinkCardSessionSettings {
        var sessionSettings = BlinkCardSessionSettings()
        
        if let stepTimeoutMillis = sessionSettingsDict["stepTimeTimeoutInterval"] as? Int {
            sessionSettings.stepTimeoutDuration = timeIntervalFromMillis(stepTimeoutMillis)
        }

        if let inactivityTimeoutMillis = sessionSettingsDict["inactivityTimeoutInterval"] as? Int {
            sessionSettings.inactivityTimeoutDuration = timeIntervalFromMillis(inactivityTimeoutMillis)
        }
        
        if let scanningSettings = sessionSettingsDict["scanningSettings"] as? [String: Any] {
            sessionSettings.scanningSettings = deserializeScanningSettings(scanningSettingsDict: scanningSettings)
        }
        
        return sessionSettings
    }
    
    static func deserializeScanningSettings(scanningSettingsDict: [String: Any]) -> ScanningSettings {
        
        var scanningSettings = ScanningSettings()
        
        if let skipImagesWithBlur = scanningSettingsDict["skipImagesWithBlur"] as? Bool {
            scanningSettings.skipImagesWithBlur = skipImagesWithBlur
        }
        
        if let tiltSensitivityLevel = scanningSettingsDict["tiltSensitivityLevel"] as? String {
            scanningSettings.tiltSensitivityLevel = deserializeSensitivityLevel(tiltSensitivityLevel)
        }
        
        if let inputImageMargin = scanningSettingsDict["inputImageMargin"] as? Double {
            scanningSettings.inputImageMargin = Float(inputImageMargin)
        }
        
        if let livenessSettings = scanningSettingsDict["livenessSettings"] as? [String: Any] {
            scanningSettings.livenessSettings = deserializeLivenessSettings(livenessSettingsDict: livenessSettings)
        }
        
        if let extractionSettings = scanningSettingsDict["extractionSettings"] as? [String: Any] {
            scanningSettings.extractionSettings = deserializeExtractionSettings(extractionSettings)
        }
        
        if let croppedImageSettings = scanningSettingsDict["croppedImageSettings"] as? [String: Any] {
            scanningSettings.croppedImageSettings = deserializeCroppedImageSettings(croppedImageSettings)
        }
        
        if let redactionSettings = scanningSettingsDict["redactionSettings"] as? [String: Any] {
            scanningSettings.redactionSettings = deserializeRedactionSettings(redactionSettings)
        }
        
        return scanningSettings
    }
    
    static func deserializeLivenessSettings(livenessSettingsDict: [String: Any]) -> LivenessSettings {
                
        if let handToCardSizeRatio = livenessSettingsDict["handToCardSizeRatio"] as? Double,
           let handCardOverlapThreshold = livenessSettingsDict["handCardOverlapThreshold"] as? Double,
           let enableCardHeldInHandCheck = livenessSettingsDict["enableCardHeldInHandCheck"] as? Bool,
           let screenCheckStrictnessLevel = livenessSettingsDict["screenCheckStrictnessLevel"] as? String,
           let photocopyCheckStrictnessLevel = livenessSettingsDict["photocopyCheckStrictnessLevel"] as? String {
            return LivenessSettings(
                handToCardSizeRatio: Float(handToCardSizeRatio),
                handCardOverlapThreshold: Float(handCardOverlapThreshold),
                enableCardHeldInHandCheck: enableCardHeldInHandCheck,
                screenCheckStrictnessLevel: deserializeStrictnessLevel(screenCheckStrictnessLevel),
                photocopyCheckStrictnessLevel: deserializeStrictnessLevel(photocopyCheckStrictnessLevel))
        }
        
        return LivenessSettings()
    }
    
    static func deserializeCroppedImageSettings(_ croppedImageSettingsDict: [String: Any]) -> CroppedImageSettings {
        var croppedImageSettings = CroppedImageSettings()
        
        if let dotsPerInch = croppedImageSettingsDict["dotsPerInch"] as? Int {
            croppedImageSettings.dotsPerInch = UInt16(dotsPerInch)
        }
        
        if let extensionFactor = croppedImageSettingsDict["extensionFactor"] as? Double {
            croppedImageSettings.extensionFactor = Float(extensionFactor)
        }
        
        if let returnCardImage = croppedImageSettingsDict["returnCardImage"] as? Bool {
            croppedImageSettings.returnCardImage = returnCardImage
        }
        
        return croppedImageSettings
    }
    
    static func deserializeExtractionSettings(_ extractionSettingsDict: [String: Any]) -> ExtractionSettings {
        
        if let extractIban = extractionSettingsDict["extractIban"] as? Bool,
           let extractExpiryDate = extractionSettingsDict["extractExpiryDate"] as? Bool,
           let extractCardholderName = extractionSettingsDict["extractCardholderName"] as? Bool,
           let extractCvv = extractionSettingsDict["extractCvv"] as? Bool,
           let extractInvalidCardNumber = extractionSettingsDict["extractInvalidCardNumber"] as? Bool {
            return ExtractionSettings(
                extractIban: extractIban,
                extractExpiryDate: extractExpiryDate,
                extractCardholderName: extractCardholderName,
                extractCvv: extractCvv,
                extractInvalidCardNumber: extractInvalidCardNumber)
        }

        return ExtractionSettings()
    }
    
    static func deserializeRedactionSettings(_ redactionSettingsDict: [String: Any]) -> RedactionSettings {
        var redactionSettings = RedactionSettings()
        
        if let cardNumberRedactionSettings = redactionSettingsDict["cardNumberRedactionSettings"] as? [String: Any] {
            redactionSettings.cardNumberRedactionSettings = deserializeCardNumberRedactionSettings(cardNumberRedactionSettings)
        }
        
        if let cvvRedactionMode = redactionSettingsDict["cvvRedactionMode"] as? String,
           let mode = RedactionMode(rawValue: cvvRedactionMode) {
            redactionSettings.cvvRedactionMode = mode
        }
        
        if let ibanRedactionMode = redactionSettingsDict["ibanRedactionMode"] as? String,
           let mode = RedactionMode(rawValue: ibanRedactionMode) {
            redactionSettings.ibanRedactionMode = mode
        }
        
        if let cardholderNameRedactionMode = redactionSettingsDict["cardholderNameRedactionMode"] as? String,
           let mode = RedactionMode(rawValue: cardholderNameRedactionMode) {
            redactionSettings.cardholderNameRedactionMode = mode
        }
        
        return redactionSettings
    }
    
    static func deserializeCardNumberRedactionSettings(_ cardNumberRedactionSettingsDict: [String: Any]) -> CardNumberRedactionSettings {
        var cardNumberRedactionSettings = CardNumberRedactionSettings()
        
        if let modeString = cardNumberRedactionSettingsDict["mode"] as? String,
           let mode = RedactionMode(rawValue: modeString) {
            cardNumberRedactionSettings.mode = mode
        }
        
        if let prefixDigitsVisible = cardNumberRedactionSettingsDict["prefixDigitsVisible"] as? Int {
            cardNumberRedactionSettings.prefixDigitsVisible = UInt8(prefixDigitsVisible)
        }
        
        if let suffixDigitsVisible = cardNumberRedactionSettingsDict["suffixDigitsVisible"] as? Int {
            cardNumberRedactionSettings.suffixDigitsVisible = UInt8(suffixDigitsVisible)
        }

        return cardNumberRedactionSettings
    }
    
    static func deserializeScanningUxSettings(_ scanningUxSettingsDict: [String: Any]) -> ScanningUXSettings {
        if let showIntroductionAlert = scanningUxSettingsDict["showIntroductionAlert"] as? Bool,
           let showHelpButton = scanningUxSettingsDict["showHelpButton"] as? Bool,
           let cameraPosition = scanningUxSettingsDict["preferredCameraPosition"] as? String,
           let allowHapticFeedback = scanningUxSettingsDict["allowHapticFeedback"] as? Bool,
           let allowScanSound = scanningUxSettingsDict["allowScanSound"] as? Bool {
            return ScanningUXSettings(
                showIntroductionAlert: showIntroductionAlert,
                showHelpButton: showHelpButton,
                preferredCameraPosition: deserializeCameraPosition(cameraPosition),
                allowHapticFeedback: allowHapticFeedback,
                allowScanSound: allowScanSound)
        }

        return ScanningUXSettings()
    }
    
    static func deserializeSensitivityLevel(_ levelString: String) -> SensitivityLevel {
        switch levelString {
        case "off": return .off
        case "low": return .low
        case "mid": return .mid
        case "high": return .high
        default: return .mid
        }
    }
    
    static func deserializeStrictnessLevel(_ levelString: String) -> StrictnessLevel {
        switch levelString {
        case "disabled": return .disabled
        case "level1": return .level1
        case "level2": return .level2
        case "level3": return .level3
        case "level4": return .level4
        case "level5": return .level5
        case "level6": return .level6
        case "level7": return .level7
        case "level8": return .level8
        case "level9": return .level9
        case "level10": return .level10
        default: return .level5
        }
    }
    
    static func deserializeCameraPosition(_ positingString: String) -> Camera.CameraPosition {
        switch positingString {
        case "front": return .front
        case "back": return .back
        default: return .back
        }
    }
    
    static func deserializeBase64Image(_ base64Image: String?) -> UIImage? {
        if let base64Image,
           let imageData = Data(base64Encoded: base64Image, options: .ignoreUnknownCharacters) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
