// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantTableImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  capacity: (json['capacity'] as num).toInt(),
  status: json['status'] as String,
  xPosition: (json['xPosition'] as num).toDouble(),
  yPosition: (json['yPosition'] as num).toDouble(),
  currentOrderId: json['current_order_id'] as String?,
  currentOrderTotal: (json['current_order_total'] as num?)?.toDouble(),
  lastOccupiedTime: json['lastOccupiedTime'] == null
      ? null
      : DateTime.parse(json['lastOccupiedTime'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  category: json['category'] as String?,
);

Map<String, dynamic> _$$RestaurantTableImplToJson(
  _$RestaurantTableImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'capacity': instance.capacity,
  'status': instance.status,
  'xPosition': instance.xPosition,
  'yPosition': instance.yPosition,
  'current_order_id': instance.currentOrderId,
  'current_order_total': instance.currentOrderTotal,
  'lastOccupiedTime': instance.lastOccupiedTime?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'category': instance.category,
};
