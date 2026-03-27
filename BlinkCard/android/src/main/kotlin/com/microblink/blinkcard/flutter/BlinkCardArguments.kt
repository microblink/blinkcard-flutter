package com.microblink.blinkcard.flutter

import com.microblink.blinkcard.flutter.BlinkCardPlatformMethods

enum class BlinkCardPlatformMethods(val method: String) {
    PERFORM_SCAN("performScan"),
    PERFORM_DIRECT_API_SCAN("performDirectApiScan"),
    LOAD_SDK("loadSdk"),
    UNLOAD_SDK("unloadSdk");

    companion object {
        fun fromMethod(method: String): BlinkCardPlatformMethods? {
            return values().firstOrNull {it.method == method }
        }
    }
}

object BlinkCardArguments {
    const val packageName: String = "blinkcard_flutter"
    const val blinkCardRequestCode: Int = 1453
    const val sdkSettings: String = "blinkCardSdkSettings"
    const val sessionSettings: String = "blinkCardSessionSettings"
    const val scanningUxSettings: String = "scanningUxSettings"
    const val blinkcardError = "blinkCardAndroid"
    const val firstSideImage = "firstSideImage"
    const val secondSideImage = "secondSideImage"
}

sealed class BlinkCardFlutterError(message: String): Exception(message) {

    class InvalidLicenseKeyProvided:
        BlinkCardFlutterError("Invalid license key provided")

    data class InvalidSettingsProvided(val detail: String) :
        BlinkCardFlutterError("Invalid settings provided: $detail")

    data class ImageIsEmpty(val detail: String):
        BlinkCardFlutterError(detail)

    class Cancelled :
        BlinkCardFlutterError("Scanning has been cancelled")

    data class InitializationError(val detail: String) :
        BlinkCardFlutterError("Initialization error: $detail")

    data class GenericError(val detail: String) :
        BlinkCardFlutterError("Error: $detail")
}