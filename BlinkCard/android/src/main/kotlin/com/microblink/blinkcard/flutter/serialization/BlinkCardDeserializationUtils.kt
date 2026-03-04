package com.microblink.blinkcard.flutter.serialization

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import com.microblink.blinkcard.core.BlinkCardSdkSettings
import com.microblink.blinkcard.core.session.BlinkCardSessionSettings
import com.microblink.blinkcard.core.session.InputImageSource
import com.microblink.blinkcard.core.settings.AnonymizationMode
import com.microblink.blinkcard.core.settings.AnonymizationSettings
import com.microblink.blinkcard.core.settings.CardNumberAnonymizationSettings
import com.microblink.blinkcard.core.settings.CroppedImageSettings
import com.microblink.blinkcard.core.settings.DetectionLevel
import com.microblink.blinkcard.core.settings.ExtractionSettings
import com.microblink.blinkcard.core.settings.LivenessSettings
import com.microblink.blinkcard.core.settings.ScanningSettings
import com.microblink.blinkcard.core.settings.StrictnessLevel
import com.microblink.blinkcard.core.utils.defaultResourceDownloadUrl
import com.microblink.blinkcard.core.utils.defaultResourcesLocalFolder
import com.microblink.blinkcard.flutter.BlinkCardFlutterError
import com.microblink.blinkcard.ux.camera.CameraLensFacing
import com.microblink.blinkcard.ux.camera.CameraSettings
import com.microblink.blinkcard.ux.settings.BlinkCardUxSettings
import kotlin.time.Duration

object BlinkCardDeserializationUtils {
    fun deserializeBlinkCardSdkSettings(blinkCardSdkSettingsJson: Map<String, Any>?): BlinkCardSdkSettings {
        if (blinkCardSdkSettingsJson.isNullOrEmpty()) throw BlinkCardFlutterError.InvalidSettingsProvided("SDK settings")
        val licenseKey = blinkCardSdkSettingsJson["licenseKey"] as? String ?: throw BlinkCardFlutterError.InvalidLicenseKeyProvided()

        return BlinkCardSdkSettings(
            licenseKey = licenseKey,
            licensee = blinkCardSdkSettingsJson["licensee"] as? String,
            downloadResources = blinkCardSdkSettingsJson["downloadResources"] as? Boolean ?: true,
            resourceDownloadUrl = blinkCardSdkSettingsJson["resourceDownloadUrl"] as? String ?: defaultResourceDownloadUrl,
            resourceLocalFolder = blinkCardSdkSettingsJson["resourceLocalFolder"] as? String ?: defaultResourcesLocalFolder,
            microblinkProxyUrl = blinkCardSdkSettingsJson["microblinkProxyUrl"] as? String
            )
    }

    fun deserializeBlinkCardSessionSettings(blinkCardSessionSettingsJson: Map<String, Any>?, isDirectApi: Boolean = false): BlinkCardSessionSettings {
        if (blinkCardSessionSettingsJson.isNullOrEmpty()) return BlinkCardSessionSettings()

        return BlinkCardSessionSettings(
            inputImageSource = if (isDirectApi) InputImageSource.Photo else InputImageSource.Video,
            scanningSettings =  deserializeScanningSettings(blinkCardSessionSettingsJson["scanningSettings"] as? Map<*, *>),

        )
        }
    fun deserializeScanningSettings(scanningSettingsJson: Map<*, *>?): ScanningSettings {
        if (scanningSettingsJson.isNullOrEmpty()) return ScanningSettings()
        return ScanningSettings(
            skipImagesWithBlur = scanningSettingsJson["skipImagesWithBlur"] as? Boolean ?: true,
            tiltDetectionLevel = deserializeDetectionLevel(scanningSettingsJson["skipImagesWithBlur"] as? String ?: "mid"),
            inputImageMargin = scanningSettingsJson["skipImagesWithBlur"] as? Float ?: 0.02f,
            livenessSettings = deserializeLivenessSettings(scanningSettingsJson["livenessSettings"] as? Map<*, *>),
            extractionSettings = deserializeExtractionSettings(scanningSettingsJson["extractionSettings"] as? Map<*, *>),
            croppedImageSettings = deserializeCroppedImageSettings(scanningSettingsJson["croppedImageSettings"] as? Map<*, *>),
            anonymizationSettings = deserializeAnonymizationSettings(scanningSettingsJson["anonymizationSettings"] as? Map<*, *>),
        )
    }

    fun deserializeLivenessSettings(livenessSettingsJson: Map<*, *>?): LivenessSettings {
        if (livenessSettingsJson.isNullOrEmpty()) return LivenessSettings()
        return LivenessSettings(
            enableCardHeldInHandCheck = livenessSettingsJson["enableCardHeldInHandCheck"] as? Boolean ?: true,
            handCardOverlapThreshold = livenessSettingsJson["handCardOverlapThreshold"] as? Float ?: 0.05f,
            handToCardSizeRatio = livenessSettingsJson["handToCardSizeRatio"] as? Float ?: 0.15f,
            photocopyCheckStrictnessLevel = deserializeStrictnessLevel(livenessSettingsJson["photocopyCheckStrictnessLevel"] as? String ?: "level5"),
            screenCheckStrictnessLevel = deserializeStrictnessLevel(livenessSettingsJson["screenCheckStrictnessLevel"] as? String ?: "level5")
        )
    }

    fun deserializeExtractionSettings(extractionSettingsJson: Map<*, *>?): ExtractionSettings {
        if (extractionSettingsJson.isNullOrEmpty()) return ExtractionSettings()
        return ExtractionSettings(
            extractIban = extractionSettingsJson["extractIban"] as? Boolean ?: true,
            extractExpiryDate = extractionSettingsJson["extractExpiryDate"] as? Boolean ?: true,
            extractCardholderName = extractionSettingsJson["extractCardholderName"] as? Boolean
                ?: true,
            extractCvv = extractionSettingsJson["extractCvv"] as? Boolean ?: true,
            extractInvalidCardNumber = extractionSettingsJson["extractInvalidCardNumber"] as? Boolean
                ?: false
        )
    }

    fun deserializeCroppedImageSettings(croppedImageSettingsJson: Map<*, *>?): CroppedImageSettings {
        if (croppedImageSettingsJson.isNullOrEmpty()) return CroppedImageSettings()
        return CroppedImageSettings(
            dotsPerInch = croppedImageSettingsJson["dotsPerInch"] as? UShort ?: 250u,
            extensionFactor = croppedImageSettingsJson["extensionFactor"] as? Float ?: 0.0f,
            returnCardImage = croppedImageSettingsJson["returnCardImage"] as? Boolean ?: false,
            )
    }

    fun deserializeAnonymizationSettings(anonymizationSettingsJson: Map<*, *>?): AnonymizationSettings {
        if (anonymizationSettingsJson.isNullOrEmpty()) return AnonymizationSettings()
        return AnonymizationSettings(
            cardholderNameAnonymizationMode = deserializeAnonymizationMode(anonymizationSettingsJson["cardholderNameAnonymizationMode"] as? String ?: "none"),
            cardNumberPrefixAnonymizationMode = deserializeAnonymizationMode(anonymizationSettingsJson["cardNumberPrefixAnonymizationMode"] as? String ?: "none"),
            cvvAnonymizationMode = deserializeAnonymizationMode(anonymizationSettingsJson["cvvAnonymizationMode"] as? String ?: "none"),
            ibanAnonymizationMode = deserializeAnonymizationMode(anonymizationSettingsJson["ibanAnonymizationMode"] as? String ?: "none"),
            cardNumberAnonymizationSettings = deserializeCardNumberAnonymizationSettings(anonymizationSettingsJson["cardNumberAnonymizationSettings"] as? Map<*, *>)
            )
    }

    fun deserializeCardNumberAnonymizationSettings(cardNumberAnonymizationSettingsJson: Map<*, *>?): CardNumberAnonymizationSettings {
        if (cardNumberAnonymizationSettingsJson.isNullOrEmpty()) return CardNumberAnonymizationSettings()
        return CardNumberAnonymizationSettings(
            anonymizationMode = deserializeAnonymizationMode(cardNumberAnonymizationSettingsJson["anonymizationMode"] as? String ?: "none"),
            prefixDigitsVisible = (cardNumberAnonymizationSettingsJson["prefixDigitsVisible"] as? Int ?: 0).toUByte(),
            suffixDigitsVisible = (cardNumberAnonymizationSettingsJson["suffixDigitsVisible"] as? Int ?: 0).toUByte(),
            )
    }

    fun deserializeScanningUxSettings(stepTimeoutDuration: Duration, allowHapticFeedback: Boolean): BlinkCardUxSettings {
        return BlinkCardUxSettings(
            stepTimeoutDuration = stepTimeoutDuration,
            allowHapticFeedback = allowHapticFeedback
        )
    }

    fun deserializeDetectionLevel(level: String): DetectionLevel = DetectionLevel.valueOf(level.replaceFirstChar { it.uppercase() })
    fun deserializeStrictnessLevel(level: String): StrictnessLevel = StrictnessLevel.valueOf(level.replaceFirstChar { it.uppercase() })
    fun deserializeAnonymizationMode(mode: String): AnonymizationMode = AnonymizationMode.valueOf(mode.replaceFirstChar { it.uppercase() })

    fun deserializeCameraSettings(lens: String): CameraSettings  {
        val cameraLens = if (lens == "front") CameraLensFacing.LensFacingFront else CameraLensFacing.LensFacingBack
        return CameraSettings(lensFacing = cameraLens)
    }

    fun base64ToBitmap(base64Str: String?): Bitmap? {
        return try {
            val decodedBytes = Base64.decode(base64Str, Base64.DEFAULT)
            BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
        } catch (_: IllegalArgumentException) {
            null
        }
    }
}