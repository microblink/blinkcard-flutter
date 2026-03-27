//
//  BlinkCardArguments.swift
//  blinkcard_flutter
//
//  Created by Milan Parađina on 26.02.2026..
//

import Foundation

enum BlinkCardPlatformMethods: String {
    case performScan
    case performDirectApiScan
    case loadSdk
    case unloadSdk
}

struct BlinkCardArguments {
    static let packageName = "blinkcard_flutter"
    static let blinkCardError = "blinkCardIos"
    static let sdkSettings = "blinkCardSdkSettings"
    static let sessionSettings = "blinkCardSessionSettings"
    static let scanningUxSettings = "scanningUxSettings"
}

enum BlinkCardFlutterError: Error, LocalizedError {
    case invalidArgumentsProvided
    case invalidLicenseKeyProvided
    case invalidSettingsProvided(message: String)
    case imageIsEmpty(message: String)
    case cancelled
    case initializationError(message: String)
    case error(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidArgumentsProvided: return "Invalid method arguments provided!"
        case .invalidLicenseKeyProvided: return "Invalid license key provided"
        case .invalidSettingsProvided(let message): return "Invalid settings provided: \(message)"
        case .imageIsEmpty(let message): return message
        case .cancelled: return "Scanning has been cancelled"
        case .initializationError(let message): return "Initialization error: \(message)"
        case .error(let message): return "Error: \(message)"
        default: "Unknown error"
        }
    }
}
