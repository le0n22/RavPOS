// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantTableImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  capacity: (json['capacity'] as num?)?.toInt() ?? 4,
  status:
      $enumDecodeNullable(_$TableStatusEnumMap, json['status']) ??
      TableStatus.available,
  xPosition: (json['xPosition'] as num?)?.toDouble() ?? 0.0,
  yPosition: (json['yPosition'] as num?)?.toDouble() ?? 0.0,
  currentOrderId: json['currentOrderId'] as String?,
  currentOrderTotal: (json['currentOrderTotal'] as num?)?.toDouble() ?? 0.0,
  lastOccupiedTime: json['lastOccupiedTime'] == null
      ? null
      : DateTime.parse(json['lastOccupiedTime'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  category: json['category'] as String? ?? '',
);

Map<String, dynamic> _$$RestaurantTableImplToJson(
  _$RestaurantTableImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'capacity': instance.capacity,
  'status': _$TableStatusEnumMap[instance.status]!,
  'xPosition': instance.xPosition,
  'yPosition': instance.yPosition,
  'currentOrderId': instance.currentOrderId,
  'currentOrderTotal': instance.currentOrderTotal,
  'lastOccupiedTime': instance.lastOccupiedTime?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'category': instance.category,
};

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
  TableStatus.paymentPending: 'paymentPending',
  TableStatus.outOfService: 'outOfService',
};
