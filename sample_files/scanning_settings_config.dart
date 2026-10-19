import 'package:blinkcard_flutter/blinkcard_flutter.dart';

/// UI-driven sample configuration for the BlinkCard sample app.
class ScanningSettingsConfig {
  bool skipImagesWithBlur = true;
  SensitivityLevel tiltSensitivityLevel = SensitivityLevel.mid;
  double inputImageMargin = 0.02;

  bool extractIban = true;
  bool extractExpiryDate = true;
  bool extractCardholderName = true;
  bool extractCvv = true;
  bool extractInvalidCardNumber = false;

  bool returnCardImage = true;
  int croppedImageDotsPerInch = 250;
  double croppedImageExtensionFactor = 0.0;

  bool redactionSettingsEnabled = true;

  RedactionMode cardholderNameRedactionMode = RedactionMode.none;
  RedactionMode cvvRedactionMode = RedactionMode.fullResult;
  RedactionMode ibanRedactionMode = RedactionMode.none;
  RedactionMode cardNumberRedactionMode = RedactionMode.fullResult;
  int cardNumberPrefixDigitsVisible = 4;
  int cardNumberSuffixDigitsVisible = 4;

  static RedactionSettings defaultRedactionSettings() {
    return RedactionSettings(
      cardholderNameRedactionMode: RedactionMode.none,
      cvvRedactionMode: RedactionMode.fullResult,
      ibanRedactionMode: RedactionMode.none,
      cardNumberRedactionSettings: CardNumberRedactionSettings(
        mode: RedactionMode.fullResult,
        prefixDigitsVisible: 4,
        suffixDigitsVisible: 4,
      ),
    );
  }

  /// Resets all settings under the Scanning settings panel (image quality, extraction, etc.).
  void resetScanningSettingsToDefaults() {
    skipImagesWithBlur = true;
    tiltSensitivityLevel = SensitivityLevel.mid;
    inputImageMargin = 0.02;

    extractIban = true;
    extractExpiryDate = true;
    extractCardholderName = true;
    extractCvv = true;
    extractInvalidCardNumber = false;

    returnCardImage = true;
    croppedImageDotsPerInch = 250;
    croppedImageExtensionFactor = 0.0;
  }

  ExtractionSettings buildExtractionSettings() {
    return ExtractionSettings(
      extractIban: extractIban,
      extractExpiryDate: extractExpiryDate,
      extractCardholderName: extractCardholderName,
      extractCvv: extractCvv,
      extractInvalidCardNumber: extractInvalidCardNumber,
    );
  }

  CroppedImageSettings buildCroppedImageSettings() {
    return CroppedImageSettings(
      returnCardImage: returnCardImage,
      dotsPerInch: croppedImageDotsPerInch,
      extensionFactor: croppedImageExtensionFactor,
    );
  }

  void resetRedactionToDefaults() {
    redactionSettingsEnabled = true;
    final defaults = defaultRedactionSettings();
    cardholderNameRedactionMode = defaults.cardholderNameRedactionMode;
    cvvRedactionMode = defaults.cvvRedactionMode;
    ibanRedactionMode = defaults.ibanRedactionMode;
    cardNumberRedactionMode =
        defaults.cardNumberRedactionSettings.mode;
    cardNumberPrefixDigitsVisible =
        defaults.cardNumberRedactionSettings.prefixDigitsVisible;
    cardNumberSuffixDigitsVisible =
        defaults.cardNumberRedactionSettings.suffixDigitsVisible;
  }

  RedactionSettings? toRedactionSettings() {
    if (!redactionSettingsEnabled) {
      return null;
    }
    return RedactionSettings(
      cardholderNameRedactionMode: cardholderNameRedactionMode,
      cvvRedactionMode: cvvRedactionMode,
      ibanRedactionMode: ibanRedactionMode,
      cardNumberRedactionSettings: CardNumberRedactionSettings(
        mode: cardNumberRedactionMode,
        prefixDigitsVisible: cardNumberPrefixDigitsVisible,
        suffixDigitsVisible: cardNumberSuffixDigitsVisible,
      ),
    );
  }

  ScanningSettings buildScanningSettings() {
    final scanningSettings = ScanningSettings();
    scanningSettings.skipImagesWithBlur = skipImagesWithBlur;
    scanningSettings.tiltSensitivityLevel = tiltSensitivityLevel;
    scanningSettings.inputImageMargin = inputImageMargin;

    final livenessSettings = LivenessSettings();
    livenessSettings.enableCardHeldInHandCheck = true;
    livenessSettings.photocopyCheckStrictnessLevel = StrictnessLevel.level5;

    scanningSettings.extractionSettings = buildExtractionSettings();
    scanningSettings.livenessSettings = livenessSettings;
    scanningSettings.redactionSettings = toRedactionSettings();
    scanningSettings.croppedImageSettings = buildCroppedImageSettings();

    return scanningSettings;
  }

  BlinkCardSessionSettings buildSessionSettings() {
    return BlinkCardSessionSettings(
      scanningSettings: buildScanningSettings(),
    );
  }
}
