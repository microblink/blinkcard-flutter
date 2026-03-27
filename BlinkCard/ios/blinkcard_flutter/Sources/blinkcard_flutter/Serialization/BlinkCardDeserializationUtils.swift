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
        
        if let downloadResources = sdkSettingsDict["downloadResources"] as? Bool {
            blinkCardSdkSettings.downloadResources = downloadResources
        }
        
        if let resourceDownloadUrl = sdkSettingsDict["resourceDownloadUrl"] as? String {
            blinkCardSdkSettings.resourceDownloadUrl = resourceDownloadUrl
        }
        
        if let resourceLocalFolder = sdkSettingsDict["resourceLocalFolder"] as? String {
            blinkCardSdkSettings.resourceLocalFolder = resourceLocalFolder
        }
        
        if let bundleIdentifier = sdkSettingsDict["bundleIdentifier"] as? String,
            let bundle: Bundle = Bundle.init(identifier: bundleIdentifier) {
            blinkCardSdkSettings.bundleURL = bundle.bundleURL
        }
        
        if let microblinkProxyUrl = sdkSettingsDict["microblinkProxyUrl"] as? String {
            blinkCardSdkSettings.microblinkProxyURL = microblinkProxyUrl
        }
        
        return blinkCardSdkSettings
    }
    
    static func deserializeSessionSettings(_ sessionSettingsDict: [String: Any]) -> BlinkCardSessionSettings {
        var sessionSettings = BlinkCardSessionSettings()
        
        if let stepTimeoutDuration = sessionSettingsDict["stepTimeTimeoutInterval"] as? Int {
            sessionSettings.stepTimeoutDuration = TimeInterval(stepTimeoutDuration / 1000)
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
        
        if let tiltDetectionLevel = scanningSettingsDict["tiltDetectionLevel"] as? String {
            
            scanningSettings.tiltDetectionLevel = deserializeDetectionLevel(tiltDetectionLevel)
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
        
        if let anonymizationSettings = scanningSettingsDict["anonymizationSettings"] as? [String: Any] {
            scanningSettings.anonymizationSettings = deserializeAnonymizationSettings(anonymizationSettings)
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
    
    static func deserializeAnonymizationSettings(_ anonymizationSettingsDict: [String: Any]) -> AnonymizationSettings {
        var anonymizationSettings = AnonymizationSettings()
        
        if let cardNumberAnonymizationSettings = anonymizationSettingsDict["cardNumberAnonymizationSettings"] as? [String: Any] {
            
            anonymizationSettings.cardNumberAnonymizationSettings = deserializeCardNumberAnonymizationSettings(cardNumberAnonymizationSettings)
        }
    
        if let cardNumberPrefixAnonymizationMode = anonymizationSettingsDict["cardNumberPrefixAnonymizationMode"] as? String,
           let mode = AnonymizationMode(rawValue: cardNumberPrefixAnonymizationMode) {
            anonymizationSettings.cardNumberPrefixAnonymizationMode = mode
        }
        
        if let cvvAnonymizationMode = anonymizationSettingsDict["cvvAnonymizationMode"] as? String,
           let mode = AnonymizationMode(rawValue: cvvAnonymizationMode) {
            anonymizationSettings.cvvAnonymizationMode = mode
        }
        
        if let ibanAnonymizationMode = anonymizationSettingsDict["ibanAnonymizationMode"] as? String,
           let mode = AnonymizationMode(rawValue: ibanAnonymizationMode) {
            anonymizationSettings.ibanAnonymizationMode = mode
        }
        
        if let cardholderNameAnonymizationMode = anonymizationSettingsDict["cardholderNameAnonymizationMode"] as? String,
           let mode = AnonymizationMode(rawValue: cardholderNameAnonymizationMode) {
            anonymizationSettings.cardholderNameAnonymizationMode = mode
        }
        
        return anonymizationSettings
    }
    
    static func deserializeCardNumberAnonymizationSettings(_ cardNumberAnonymizationSettingsDict: [String: Any]) -> CardNumberAnonymizationSettings {
        var cardNumberAnonymizationSettings = CardNumberAnonymizationSettings()
        
        if let anonymizationMode = cardNumberAnonymizationSettingsDict["anonymizationMode"] as? String,
        let mode = AnonymizationMode(rawValue: anonymizationMode) {
            cardNumberAnonymizationSettings.mode = mode
        }
        
        if let prefixDigitsVisible = cardNumberAnonymizationSettingsDict["prefixDigitsVisible"] as? Int {
            cardNumberAnonymizationSettings.prefixDigitsVisible = UInt8(prefixDigitsVisible)
        }
        
        if let suffixDigitsVisible = cardNumberAnonymizationSettingsDict["suffixDigitsVisible"] as? Int {
            cardNumberAnonymizationSettings.suffixDigitsVisible = UInt8(suffixDigitsVisible)
        }

        return cardNumberAnonymizationSettings
    }
    
    static func deserializeScanningUxSettings(_ scanningUxSettingsDict: [String: Any]) -> ScanningUXSettings {
        
        if let showIntroductionAlert = scanningUxSettingsDict["showIntroductionAlert"] as? Bool,
           let showHelpButton = scanningUxSettingsDict["showHelpButton"] as? Bool,
           let cameraPosition = scanningUxSettingsDict["preferredCameraPosition"] as? String,
        let allowHapticFeedback = scanningUxSettingsDict["allowHapticFeedback"] as? Bool {
            return ScanningUXSettings(
                showIntroductionAlert: showIntroductionAlert,
                showHelpButton: showHelpButton,
                preferredCameraPosition: deserializeCameraPosition(cameraPosition),
                allowHapticFeedback: allowHapticFeedback)
        }
        
        return ScanningUXSettings()
        
    }
    
    static func deserializeDetectionLevel(_ levelString: String) -> DetectionLevel {
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
