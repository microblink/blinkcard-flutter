// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardNumberRedactionSettings _$CardNumberRedactionSettingsFromJson(
  Map<String, dynamic> json,
) => CardNumberRedactionSettings(
  mode:
      $enumDecodeNullable(_$RedactionModeEnumMap, json['mode']) ??
      RedactionMode.fullResult,
  prefixDigitsVisible: (json['prefixDigitsVisible'] as num?)?.toInt() ?? 4,
  suffixDigitsVisible: (json['suffixDigitsVisible'] as num?)?.toInt() ?? 4,
);

Map<String, dynamic> _$CardNumberRedactionSettingsToJson(
  CardNumberRedactionSettings instance,
) => <String, dynamic>{
  'mode': _$RedactionModeEnumMap[instance.mode]!,
  'prefixDigitsVisible': instance.prefixDigitsVisible,
  'suffixDigitsVisible': instance.suffixDigitsVisible,
};

const _$RedactionModeEnumMap = {
  RedactionMode.none: 'none',
  RedactionMode.imageOnly: 'imageOnly',
  RedactionMode.resultFieldsOnly: 'resultFieldsOnly',
  RedactionMode.fullResult: 'fullResult',
};
