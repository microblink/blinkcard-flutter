import 'package:blinkcard_flutter/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blinkcard_settings.g.dart';

/// Settings for initialization of the BlinkCard SDK.
@JsonSerializable()
final class BlinkCardSdkSettings {
  /// License key string for the native SDK.
  String licenseKey;

  /// Optional licensee String if the provided license key is not tied to the single application ID.
  String? licensee;

  /// Whether resources required for on-device image processing should be downloaded and cached on first initialization of the SDK.
  /// If set to false, you need to package all the required resources in your application's assets.
  ///
  /// Default: `true`
  bool downloadResources;

  /// If resources are to be downloaded,
  /// the following is the URL where the resources are hosted.
  ///
  /// Default (when omitted): `https://models.cdn.microblink.com/resources`
  String? resourceDownloadUrl;

  /// Local folder name where resources will be downloaded and cached.
  ///
  /// If resources are being downloaded, this defines the name of the folder within your application's cache folder where resources will be cached.
  /// If resources downloading is disabled, this defines the path in your application's assets where the resources could be found.
  String? resourceLocalFolder;

  /// **iOS-specific** - If resources downloading is disabled for iOS, this defines the bundle identifier of your iOS app where the resources reside.
  String? bundleIdentifier;

  /// Resource download timeout in milliseconds.
  ///
  /// When omitted, the native SDK default applies (30 seconds).
  int? resourceRequestTimeout;

  /// Set a custom HTTPS URL to be used as a proxy for Ping and license checks.
  /// The proxy URL will be applied only if the license has the appropriate rights.
  ///
  /// The URL must use the HTTPS protocol. Example: https://your-proxy.com/
  String? microblinkProxyUrl;

  BlinkCardSdkSettings({
    required this.licenseKey,
    this.licensee,
    this.downloadResources = true,
    this.resourceDownloadUrl,
    this.resourceLocalFolder,
    this.bundleIdentifier,
    this.resourceRequestTimeout,
    this.microblinkProxyUrl,
  });

  factory BlinkCardSdkSettings.fromJson(Map<String, dynamic> json) =>
      _$BlinkCardSdkSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$BlinkCardSdkSettingsToJson(this);
}

/// Represents the configuration settings for a scanning session.
///
/// This class holds the settings related to the input image source and specific scanning configurations
/// that define how the scanning session should behave.
@JsonSerializable()
final class BlinkCardSessionSettings {
  /// The specific scanning settings for the scanning session.
  /// Defines various parameters that control the scanning process.
  ScanningSettings scanningSettings;

  /// Duration in milliseconds before a scanning step times out and is cancelled.
  ///
  /// If less than zero, scanning will not time out.
  /// Default: `60000` (60 seconds).
  int stepTimeTimeoutInterval;

  /// Duration in milliseconds with no scanning progress before an inactivity timeout.
  ///
  /// Set to `0` to disable the inactivity timeout.
  /// Default: `10000` (10 seconds).
  int inactivityTimeoutInterval;

  BlinkCardSessionSettings({
    ScanningSettings? scanningSettings,
    this.stepTimeTimeoutInterval = 60000,
    this.inactivityTimeoutInterval = 10000,
  }) : scanningSettings = scanningSettings ?? ScanningSettings();

  factory BlinkCardSessionSettings.fromJson(Map<String, dynamic> json) =>
      _$BlinkCardSessionSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$BlinkCardSessionSettingsToJson(this);
}

/// Represents the configurable settings for scanning a card.
///
/// This class defines various parameters and policies related to the scanning process,
/// including image quality handling, data extraction, redaction, and liveness detection,
/// along with options for frame processing and image extraction.
@JsonSerializable()
final class ScanningSettings {
  /// Indicates whether to reject frames if blur is detected on the card image.
  ///
  /// When `true` (default), frames with detected blur are skipped to ensure only high-quality images are processed.
  /// When `false`, blurred frames are still processed, and the blur status is reported in the ProcessResult.
  ///
  /// Default: `true`.
  bool skipImagesWithBlur;

  /// The level of allowed detected tilt of the card in the image.
  ///
  /// Defines the severity of allowed detected tilt of the card in the image, as defined in [SensitivityLevel].
  /// Values range from `off` (detection turned off) to higher levels of allowed tilt.
  ///
  /// Defaults to [SensitivityLevel.mid].
  SensitivityLevel tiltSensitivityLevel;

  /// Defines the minimum required margin (in percentage) between the edge of the input image and the card. Default value is 0.02 (also recommended value).
  ///
  /// The setting is applicable only when using images from Video source.
  ///
  /// Default: `0.02`.
  double inputImageMargin;

  /// Represents the configurable settings for liveness detection.
  ///
  /// This defines various parameters and policies related to the liveness detection process,
  /// including checks for hand presence and screen analysis.
  LivenessSettings livenessSettings;

  /// Controls which fields and images should be extracted from the card.
  ///
  /// Disabling extraction of unused fields can improve recognition performance or reduce memory usage.
  ExtractionSettings extractionSettings;

  /// Configures the image cropping settings during scanning process.
  ///
  /// Allows customization of cropped image handling, such as dotsPerInch, extensionFactor,
  /// and whether images should be returned for the entire card.
  CroppedImageSettings croppedImageSettings;

  /// Redaction settings for sensitive card data.
  ///
  /// When omitted, the native SDK default redaction policy applies (PAN and CVV
  /// redacted with four prefix and four suffix digits visible on the card number; IBAN and
  /// cardholder name not redacted).
  @JsonKey(includeIfNull: false)
  RedactionSettings? redactionSettings;

  ScanningSettings({
    this.skipImagesWithBlur = true,
    this.tiltSensitivityLevel = SensitivityLevel.mid,
    this.inputImageMargin = 0.02,
    LivenessSettings? livenessSettings,
    this.redactionSettings,
    CroppedImageSettings? croppedImageSettings,
    ExtractionSettings? extractionSettings,
  }) : livenessSettings = livenessSettings ?? LivenessSettings(),
       croppedImageSettings = croppedImageSettings ?? CroppedImageSettings(),
       extractionSettings = extractionSettings ?? ExtractionSettings();

  factory ScanningSettings.fromJson(Map<String, dynamic> json) =>
      _$ScanningSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ScanningSettingsToJson(this);
}

/// Configuration settings for liveness detection during card scanning.
///
/// This class defines various parameters that control the behavior of liveness detection, including
/// thresholds for hand detection, screen and photocopy analysis,
/// and options to skip processing certain frames based on liveness criteria.
@JsonSerializable()
final class LivenessSettings {
  /// Enables or disables the check for card held in hand.
  ///
  /// When true, the liveness detection will include a check to verify that the card is being held in hand.
  ///
  /// Default: `true`
  bool enableCardHeldInHandCheck;

  /// Minimum overlap threshold between detected hand and card regions.
  ///
  /// This parameter is used to adjust heuristics that eliminate cases when the hand is present in the input but it is not holding the card.
  ///
  /// `handCardOverlapThreshold` is the minimal ratio of hand pixels inside the frame surrounding the card and area of that frame.
  /// Only pixels inside that frame are used to ignore false-positive hand segmentations inside the card.
  ///
  /// Value must be in range \[0.0, 1.0\].
  ///
  /// Default: `0.05`.
  double handCardOverlapThreshold;

  /// Minimum hand-to-card size ratio for valid hand detection.
  ///
  /// This controls how large a hand must appear in the frame relative to the card to be considered valid.
  /// Lower values detect smaller/more distant hands.
  /// Hand scale is calculated as a ratio between area of hand mask and card mask.
  ///
  /// Value must be in range \[0.0, 1.0\].
  ///
  /// Default: `0.15`
  double handToCardSizeRatio;

  /// Sensitivity level for detecting frames where the presented card is a photocopy.
  ///
  /// Higher levels provide better security by being more strict in detecting photocopied cards, but may increase false positives.
  ///
  /// Default: [StrictnessLevel.level5].
  StrictnessLevel photocopyCheckStrictnessLevel;

  /// Sensitivity level for detecting frames where the card is displayed on a screen.
  ///
  /// Higher levels provide better security by being more strict in detecting screen-displayed cards, but may increase false positives.
  ///
  /// Defaults: [StrictnessLevel.level5].
  StrictnessLevel screenCheckStrictnessLevel;

  LivenessSettings({
    this.enableCardHeldInHandCheck = true,
    this.handCardOverlapThreshold = 0.05,
    this.handToCardSizeRatio = 0.15,
    this.photocopyCheckStrictnessLevel = StrictnessLevel.level5,
    this.screenCheckStrictnessLevel = StrictnessLevel.level5,
  }) : assert(
         handCardOverlapThreshold >= 0.0 && handCardOverlapThreshold <= 1.0,
         "handCardOverlapThreshold must range between [0.0, 1.0]",
       ),
       assert(
         handToCardSizeRatio >= 0.0 && handToCardSizeRatio <= 1.0,
         "handToCardSizeRatio must range between [0.0, 1.0]",
       );
  factory LivenessSettings.fromJson(Map<String, dynamic> json) =>
      _$LivenessSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LivenessSettingsToJson(this);
}

/// Controls which fields and images should be extracted from the payment card.
///
/// Disabling extraction of unused fields can improve recognition performance or reduce memory usage.
@JsonSerializable()
final class ExtractionSettings {
  /// Whether to extract the IBAN (International Bank Account Number).
  /// Default: `true`
  bool extractIban;

  /// Whether to extract the card expiry date.
  /// Default: `true`
  bool extractExpiryDate;

  /// Whether to extract the cardholder name.
  ///
  /// Default: `true`.
  bool extractCardholderName;

  /// Whether to extract the CVV (Card Verification Value) security code.
  ///
  /// Usually found on the back of the card.
  /// Required for secure transactions.
  ///
  /// Default: `true`
  bool extractCvv;

  /// Indicates whether card numbers that fail checksum validation should be accepted.
  ///
  /// Card numbers are validated using the Luhn algorithm.
  ///
  /// A value of false (default) means only card numbers that pass the checksum validation will be accepted.
  /// A value of true means card numbers that fail checksum validation will still be accepted.
  ///
  /// This may be useful for testing purposes or when processing damaged/worn cards.
  /// The cardNumberValid field in the result will still indicate whether the checksum passed.
  ///
  /// Default: `false`
  bool extractInvalidCardNumber;

  /// Controls which fields and images should be extracted from the payment card.
  ///
  /// Disabling extraction of unused fields can improve recognition performance or reduce memory usage.
  ExtractionSettings({
    this.extractIban = true,
    this.extractExpiryDate = true,
    this.extractCardholderName = true,
    this.extractCvv = true,
    this.extractInvalidCardNumber = false,
  });

  factory ExtractionSettings.fromJson(Map<String, dynamic> json) =>
      _$ExtractionSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ExtractionSettingsToJson(this);
}

/// Represents the image cropping settings.
///
/// This class controls how card images are cropped, including the resolution,
/// extension of the cropping area, and whether the cropped image should be returned in the results.
@JsonSerializable()
final class CroppedImageSettings {
  /// The DPI value for the cropped image.
  ///
  /// Default: `250`
  int dotsPerInch;

  /// The extension factor for the cropped card image.
  /// Value must be in range \[0.0, 1.0\].
  ///
  /// Defaults: `0.0`.
  double extensionFactor;

  /// Indicates whether the cropped card image should be returned.
  ///
  /// Provides the complete card image for record keeping or further processing.
  /// Disable to reduce memory usage if image is not needed.
  ///
  /// Default: `false`.
  bool returnCardImage;

  /// Represents the image cropping settings.
  ///
  /// This class controls how card images are cropped, including the resolution,
  /// extension of the cropping area, and whether the cropped image should be returned in the results.
  CroppedImageSettings({
    this.dotsPerInch = 250,
    this.extensionFactor = 0.0,
    this.returnCardImage = false,
  });

  factory CroppedImageSettings.fromJson(Map<String, dynamic> json) =>
      _$CroppedImageSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$CroppedImageSettingsToJson(this);
}

/// Holds the settings which control the redaction of returned data.
///
/// Assign to [ScanningSettings.redactionSettings] to override native SDK defaults.
/// Property defaults below apply only when constructing this object explicitly.
@JsonSerializable()
final class RedactionSettings {
  /// Defines the mode of cardholder name redaction.
  RedactionMode cardholderNameRedactionMode;

  /// Defines the mode of CVV redaction.
  RedactionMode cvvRedactionMode;

  /// Defines the mode of IBAN redaction.
  RedactionMode ibanRedactionMode;

  /// Defines the parameters of card number redaction.
  CardNumberRedactionSettings cardNumberRedactionSettings;

  /// Holds the settings which control the redaction of returned data.
  RedactionSettings({
    this.cardholderNameRedactionMode = RedactionMode.none,
    this.cvvRedactionMode = RedactionMode.fullResult,
    this.ibanRedactionMode = RedactionMode.none,
    CardNumberRedactionSettings? cardNumberRedactionSettings,
  }) : cardNumberRedactionSettings =
           cardNumberRedactionSettings ?? CardNumberRedactionSettings();

  factory RedactionSettings.fromJson(Map<String, dynamic> json) =>
      _$RedactionSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$RedactionSettingsToJson(this);
}

/// Allows customization of various aspects of the UI/UX
/// used during the scanning process.
@JsonSerializable()
final class ScanningUxSettings {
  /// Determines if alert will be shown when scanning start.
  ///
  /// Default: `true`
  bool showIntroductionAlert;

  /// Determines if help button for raising an onboarding sheet will be shown.
  ///
  /// Default: `true`
  bool showHelpButton;

  ///The preferred camera position to use when capturing document.
  ///
  /// This value represents the user’s choice of front or back camera.
  /// The system determines the actual physical camera device.
  ///
  /// Default: [CameraPosition.back]
  CameraPosition preferredCameraPosition;

  /// When enabled, haptic responses are generated during scanning activities,
  ///
  /// such as detection updates or user interactions (e.g., toggling the flashlight).
  /// When disabled, no haptic feedback is produced.
  ///
  /// Default: `true`
  bool allowHapticFeedback;

  /// When enabled, scan sounds are played during scanning activities.
  /// When disabled, no scan sounds are played.
  ///
  /// Default: `true`
  bool allowScanSound;

  /// Allows customization of various aspects of the UI/UX
  /// used during the scanning process.
  ScanningUxSettings({
    this.showIntroductionAlert = true,
    this.showHelpButton = true,
    this.preferredCameraPosition = CameraPosition.back,
    this.allowHapticFeedback = true,
    this.allowScanSound = true,
  });

  factory ScanningUxSettings.fromJson(Map<String, dynamic> json) =>
      _$ScanningUxSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ScanningUxSettingsToJson(this);
}
