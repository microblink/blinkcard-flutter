// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blinkcard_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlinkCardSdkSettings _$BlinkCardSdkSettingsFromJson(
  Map<String, dynamic> json,
) => BlinkCardSdkSettings(
  licenseKey: json['licenseKey'] as String,
  licensee: json['licensee'] as String?,
  downloadResources: json['downloadResources'] as bool? ?? true,
  resourceDownloadUrl: json['resourceDownloadUrl'] as String?,
  resourceLocalFolder: json['resourceLocalFolder'] as String?,
  bundleIdentifier: json['bundleIdentifier'] as String?,
  microblinkProxyUrl: json['microblinkProxyUrl'] as String?,
);

Map<String, dynamic> _$BlinkCardSdkSettingsToJson(
  BlinkCardSdkSettings instance,
) => <String, dynamic>{
  'licenseKey': instance.licenseKey,
  'licensee': instance.licensee,
  'downloadResources': instance.downloadResources,
  'resourceDownloadUrl': instance.resourceDownloadUrl,
  'resourceLocalFolder': instance.resourceLocalFolder,
  'bundleIdentifier': instance.bundleIdentifier,
  'microblinkProxyUrl': instance.microblinkProxyUrl,
};

BlinkCardSessionSettings _$BlinkCardSessionSettingsFromJson(
  Map<String, dynamic> json,
) => BlinkCardSessionSettings(
  scanningSettings:
      json['scanningSettings'] == null
          ? null
          : ScanningSettings.fromJson(
            json['scanningSettings'] as Map<String, dynamic>,
          ),
  stepTimeTimeoutInterval:
      (json['stepTimeTimeoutInterval'] as num?)?.toInt() ?? 15000,
);

Map<String, dynamic> _$BlinkCardSessionSettingsToJson(
  BlinkCardSessionSettings instance,
) => <String, dynamic>{
  'scanningSettings': instance.scanningSettings,
  'stepTimeTimeoutInterval': instance.stepTimeTimeoutInterval,
};

ScanningSettings _$ScanningSettingsFromJson(Map<String, dynamic> json) =>
    ScanningSettings(
      skipImagesWithBlur: json['skipImagesWithBlur'] as bool? ?? true,
      tiltDetectionLevel:
          $enumDecodeNullable(
            _$DetectionLevelEnumMap,
            json['tiltDetectionLevel'],
          ) ??
          DetectionLevel.mid,
      inputImageMargin: (json['inputImageMargin'] as num?)?.toDouble() ?? 0.02,
      livenessSettings:
          json['livenessSettings'] == null
              ? null
              : LivenessSettings.fromJson(
                json['livenessSettings'] as Map<String, dynamic>,
              ),
      anonymizationSettings:
          json['anonymizationSettings'] == null
              ? null
              : AnonymizationSettings.fromJson(
                json['anonymizationSettings'] as Map<String, dynamic>,
              ),
      croppedImageSettings:
          json['croppedImageSettings'] == null
              ? null
              : CroppedImageSettings.fromJson(
                json['croppedImageSettings'] as Map<String, dynamic>,
              ),
      extractionSettings:
          json['extractionSettings'] == null
              ? null
              : ExtractionSettings.fromJson(
                json['extractionSettings'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$ScanningSettingsToJson(
  ScanningSettings instance,
) => <String, dynamic>{
  'skipImagesWithBlur': instance.skipImagesWithBlur,
  'tiltDetectionLevel': _$DetectionLevelEnumMap[instance.tiltDetectionLevel]!,
  'inputImageMargin': instance.inputImageMargin,
  'livenessSettings': instance.livenessSettings,
  'extractionSettings': instance.extractionSettings,
  'croppedImageSettings': instance.croppedImageSettings,
  'anonymizationSettings': instance.anonymizationSettings,
};

const _$DetectionLevelEnumMap = {
  DetectionLevel.off: 'off',
  DetectionLevel.low: 'low',
  DetectionLevel.mid: 'mid',
  DetectionLevel.high: 'high',
};

LivenessSettings _$LivenessSettingsFromJson(Map<String, dynamic> json) =>
    LivenessSettings(
      enableCardHeldInHandCheck:
          json['enableCardHeldInHandCheck'] as bool? ?? true,
      handCardOverlapThreshold:
          (json['handCardOverlapThreshold'] as num?)?.toDouble() ?? 0.05,
      handToCardSizeRatio:
          (json['handToCardSizeRatio'] as num?)?.toDouble() ?? 0.15,
      photocopyCheckStrictnessLevel:
          $enumDecodeNullable(
            _$StrictnessLevelEnumMap,
            json['photocopyCheckStrictnessLevel'],
          ) ??
          StrictnessLevel.level5,
      screenCheckStrictnessLevel:
          $enumDecodeNullable(
            _$StrictnessLevelEnumMap,
            json['screenCheckStrictnessLevel'],
          ) ??
          StrictnessLevel.level5,
    );

Map<String, dynamic> _$LivenessSettingsToJson(LivenessSettings instance) =>
    <String, dynamic>{
      'enableCardHeldInHandCheck': instance.enableCardHeldInHandCheck,
      'handCardOverlapThreshold': instance.handCardOverlapThreshold,
      'handToCardSizeRatio': instance.handToCardSizeRatio,
      'photocopyCheckStrictnessLevel':
          _$StrictnessLevelEnumMap[instance.photocopyCheckStrictnessLevel]!,
      'screenCheckStrictnessLevel':
          _$StrictnessLevelEnumMap[instance.screenCheckStrictnessLevel]!,
    };

const _$StrictnessLevelEnumMap = {
  StrictnessLevel.disabled: 'disabled',
  StrictnessLevel.level1: 'level1',
  StrictnessLevel.level2: 'level2',
  StrictnessLevel.level3: 'level3',
  StrictnessLevel.level4: 'level4',
  StrictnessLevel.level5: 'level5',
  StrictnessLevel.level6: 'level6',
  StrictnessLevel.level7: 'level7',
  StrictnessLevel.level8: 'level8',
  StrictnessLevel.level9: 'level9',
  StrictnessLevel.level10: 'level10',
};

ExtractionSettings _$ExtractionSettingsFromJson(Map<String, dynamic> json) =>
    ExtractionSettings(
      extractIban: json['extractIban'] as bool? ?? true,
      extractExpiryDate: json['extractExpiryDate'] as bool? ?? true,
      extractCardholderName: json['extractCardholderName'] as bool? ?? true,
      extractCvv: json['extractCvv'] as bool? ?? true,
      extractInvalidCardNumber:
          json['extractInvalidCardNumber'] as bool? ?? false,
    );

Map<String, dynamic> _$ExtractionSettingsToJson(ExtractionSettings instance) =>
    <String, dynamic>{
      'extractIban': instance.extractIban,
      'extractExpiryDate': instance.extractExpiryDate,
      'extractCardholderName': instance.extractCardholderName,
      'extractCvv': instance.extractCvv,
      'extractInvalidCardNumber': instance.extractInvalidCardNumber,
    };

CroppedImageSettings _$CroppedImageSettingsFromJson(
  Map<String, dynamic> json,
) => CroppedImageSettings(
  dotsPerInch: (json['dotsPerInch'] as num?)?.toInt() ?? 250,
  extensionFactor: (json['extensionFactor'] as num?)?.toDouble() ?? 0.0,
  returnCardImage: json['returnCardImage'] as bool? ?? false,
);

Map<String, dynamic> _$CroppedImageSettingsToJson(
  CroppedImageSettings instance,
) => <String, dynamic>{
  'dotsPerInch': instance.dotsPerInch,
  'extensionFactor': instance.extensionFactor,
  'returnCardImage': instance.returnCardImage,
};

AnonymizationSettings _$AnonymizationSettingsFromJson(
  Map<String, dynamic> json,
) => AnonymizationSettings(
  cardholderNameAnonymizationMode:
      $enumDecodeNullable(
        _$AnonymizationModeEnumMap,
        json['cardholderNameAnonymizationMode'],
      ) ??
      AnonymizationMode.none,
  cardNumberPrefixAnonymizationMode:
      $enumDecodeNullable(
        _$AnonymizationModeEnumMap,
        json['cardNumberPrefixAnonymizationMode'],
      ) ??
      AnonymizationMode.none,
  cvvAnonymizationMode:
      $enumDecodeNullable(
        _$AnonymizationModeEnumMap,
        json['cvvAnonymizationMode'],
      ) ??
      AnonymizationMode.none,
  ibanAnonymizationMode:
      $enumDecodeNullable(
        _$AnonymizationModeEnumMap,
        json['ibanAnonymizationMode'],
      ) ??
      AnonymizationMode.none,
  cardNumberAnonymizationSettings:
      json['cardNumberAnonymizationSettings'] == null
          ? null
          : CardNumberAnonymizationSettings.fromJson(
            json['cardNumberAnonymizationSettings'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$AnonymizationSettingsToJson(
  AnonymizationSettings instance,
) => <String, dynamic>{
  'cardholderNameAnonymizationMode':
      _$AnonymizationModeEnumMap[instance.cardholderNameAnonymizationMode]!,
  'cardNumberPrefixAnonymizationMode':
      _$AnonymizationModeEnumMap[instance.cardNumberPrefixAnonymizationMode]!,
  'cvvAnonymizationMode':
      _$AnonymizationModeEnumMap[instance.cvvAnonymizationMode]!,
  'ibanAnonymizationMode':
      _$AnonymizationModeEnumMap[instance.ibanAnonymizationMode]!,
  'cardNumberAnonymizationSettings': instance.cardNumberAnonymizationSettings,
};

const _$AnonymizationModeEnumMap = {
  AnonymizationMode.none: 'none',
  AnonymizationMode.imageOnly: 'imageOnly',
  AnonymizationMode.resultFieldsOnly: 'resultFieldsOnly',
  AnonymizationMode.fullResult: 'fullResult',
};

ScanningUxSettings _$ScanningUxSettingsFromJson(Map<String, dynamic> json) =>
    ScanningUxSettings(
      showIntroductionAlert: json['showIntroductionAlert'] as bool? ?? true,
      showHelpButton: json['showHelpButton'] as bool? ?? true,
      preferredCameraPosition:
          $enumDecodeNullable(
            _$CameraPositionEnumMap,
            json['preferredCameraPosition'],
          ) ??
          CameraPosition.back,
      allowHapticFeedback: json['allowHapticFeedback'] as bool? ?? true,
    );

Map<String, dynamic> _$ScanningUxSettingsToJson(ScanningUxSettings instance) =>
    <String, dynamic>{
      'showIntroductionAlert': instance.showIntroductionAlert,
      'showHelpButton': instance.showHelpButton,
      'preferredCameraPosition':
          _$CameraPositionEnumMap[instance.preferredCameraPosition]!,
      'allowHapticFeedback': instance.allowHapticFeedback,
    };

const _$CameraPositionEnumMap = {
  CameraPosition.front: 'front',
  CameraPosition.back: 'back',
};
