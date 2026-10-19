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
  resourceRequestTimeout: (json['resourceRequestTimeout'] as num?)?.toInt(),
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
  'resourceRequestTimeout': instance.resourceRequestTimeout,
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
      (json['stepTimeTimeoutInterval'] as num?)?.toInt() ?? 60000,
  inactivityTimeoutInterval:
      (json['inactivityTimeoutInterval'] as num?)?.toInt() ?? 10000,
);

Map<String, dynamic> _$BlinkCardSessionSettingsToJson(
  BlinkCardSessionSettings instance,
) => <String, dynamic>{
  'scanningSettings': instance.scanningSettings,
  'stepTimeTimeoutInterval': instance.stepTimeTimeoutInterval,
  'inactivityTimeoutInterval': instance.inactivityTimeoutInterval,
};

ScanningSettings _$ScanningSettingsFromJson(Map<String, dynamic> json) =>
    ScanningSettings(
      skipImagesWithBlur: json['skipImagesWithBlur'] as bool? ?? true,
      tiltSensitivityLevel:
          $enumDecodeNullable(
            _$SensitivityLevelEnumMap,
            json['tiltSensitivityLevel'],
          ) ??
          SensitivityLevel.mid,
      inputImageMargin: (json['inputImageMargin'] as num?)?.toDouble() ?? 0.02,
      livenessSettings:
          json['livenessSettings'] == null
              ? null
              : LivenessSettings.fromJson(
                json['livenessSettings'] as Map<String, dynamic>,
              ),
      redactionSettings:
          json['redactionSettings'] == null
              ? null
              : RedactionSettings.fromJson(
                json['redactionSettings'] as Map<String, dynamic>,
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

Map<String, dynamic> _$ScanningSettingsToJson(ScanningSettings instance) =>
    <String, dynamic>{
      'skipImagesWithBlur': instance.skipImagesWithBlur,
      'tiltSensitivityLevel':
          _$SensitivityLevelEnumMap[instance.tiltSensitivityLevel]!,
      'inputImageMargin': instance.inputImageMargin,
      'livenessSettings': instance.livenessSettings,
      'extractionSettings': instance.extractionSettings,
      'croppedImageSettings': instance.croppedImageSettings,
      if (instance.redactionSettings != null)
        'redactionSettings': instance.redactionSettings,
    };

const _$SensitivityLevelEnumMap = {
  SensitivityLevel.off: 'off',
  SensitivityLevel.low: 'low',
  SensitivityLevel.mid: 'mid',
  SensitivityLevel.high: 'high',
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

RedactionSettings _$RedactionSettingsFromJson(
  Map<String, dynamic> json,
) => RedactionSettings(
  cardholderNameRedactionMode:
      $enumDecodeNullable(
        _$RedactionModeEnumMap,
        json['cardholderNameRedactionMode'],
      ) ??
      RedactionMode.none,
  cvvRedactionMode:
      $enumDecodeNullable(_$RedactionModeEnumMap, json['cvvRedactionMode']) ??
      RedactionMode.fullResult,
  ibanRedactionMode:
      $enumDecodeNullable(_$RedactionModeEnumMap, json['ibanRedactionMode']) ??
      RedactionMode.none,
  cardNumberRedactionSettings:
      json['cardNumberRedactionSettings'] == null
          ? null
          : CardNumberRedactionSettings.fromJson(
            json['cardNumberRedactionSettings'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$RedactionSettingsToJson(RedactionSettings instance) =>
    <String, dynamic>{
      'cardholderNameRedactionMode':
          _$RedactionModeEnumMap[instance.cardholderNameRedactionMode]!,
      'cvvRedactionMode': _$RedactionModeEnumMap[instance.cvvRedactionMode]!,
      'ibanRedactionMode': _$RedactionModeEnumMap[instance.ibanRedactionMode]!,
      'cardNumberRedactionSettings': instance.cardNumberRedactionSettings,
    };

const _$RedactionModeEnumMap = {
  RedactionMode.none: 'none',
  RedactionMode.imageOnly: 'imageOnly',
  RedactionMode.resultFieldsOnly: 'resultFieldsOnly',
  RedactionMode.fullResult: 'fullResult',
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
      allowScanSound: json['allowScanSound'] as bool? ?? true,
    );

Map<String, dynamic> _$ScanningUxSettingsToJson(ScanningUxSettings instance) =>
    <String, dynamic>{
      'showIntroductionAlert': instance.showIntroductionAlert,
      'showHelpButton': instance.showHelpButton,
      'preferredCameraPosition':
          _$CameraPositionEnumMap[instance.preferredCameraPosition]!,
      'allowHapticFeedback': instance.allowHapticFeedback,
      'allowScanSound': instance.allowScanSound,
    };

const _$CameraPositionEnumMap = {
  CameraPosition.front: 'front',
  CameraPosition.back: 'back',
};
