// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      id: json['id'] as String,
      key: json['key'] as String,
      value: json['value'],
      type: $enumDecode(_$SettingTypeEnumMap, json['type']),
      description: json['description'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'type': _$SettingTypeEnumMap[instance.type]!,
      'description': instance.description,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SettingTypeEnumMap = {
  SettingType.string: 'string',
  SettingType.int: 'int',
  SettingType.double: 'double',
  SettingType.bool: 'bool',
  SettingType.json: 'json',
};
