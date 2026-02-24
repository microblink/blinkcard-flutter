// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardNumberAnonymizationSettings _$CardNumberAnonymizationSettingsFromJson(
  Map<String, dynamic> json,
) => CardNumberAnonymizationSettings(
  anonymizationMode:
      $enumDecodeNullable(
        _$AnonymizationModeEnumMap,
        json['anonymizationMode'],
      ) ??
      AnonymizationMode.none,
  prefixDigitsVisible: (json['prefixDigitsVisible'] as num?)?.toInt() ?? 0,
  suffixDigitsVisible: (json['suffixDigitsVisible'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CardNumberAnonymizationSettingsToJson(
  CardNumberAnonymizationSettings instance,
) => <String, dynamic>{
  'anonymizationMode': _$AnonymizationModeEnumMap[instance.anonymizationMode]!,
  'prefixDigitsVisible': instance.prefixDigitsVisible,
  'suffixDigitsVisible': instance.suffixDigitsVisible,
};

const _$AnonymizationModeEnumMap = {
  AnonymizationMode.none: 'none',
  AnonymizationMode.imageOnly: 'imageOnly',
  AnonymizationMode.resultFieldsOnly: 'resultFieldsOnly',
  AnonymizationMode.fullResult: 'fullResult',
};
