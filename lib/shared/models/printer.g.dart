// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterImpl _$$PrinterImplFromJson(Map<String, dynamic> json) =>
    _$PrinterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PrinterTypeEnumMap, json['type']),
      ipAddress: json['ipAddress'] as String,
      port: (json['port'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      location: json['location'] as String?,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$$PrinterImplToJson(_$PrinterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PrinterTypeEnumMap[instance.type]!,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'isActive': instance.isActive,
      'location': instance.location,
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };

const _$PrinterTypeEnumMap = {
  PrinterType.receipt: 'receipt',
  PrinterType.kitchen: 'kitchen',
  PrinterType.label: 'label',
};
