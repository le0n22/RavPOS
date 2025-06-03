import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_table.freezed.dart';
part 'restaurant_table.g.dart';

@freezed
class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required int id,
    required String name,
    required int capacity,
    required String status,
    required double xPosition,
    required double yPosition,
    @JsonKey(name: 'current_order_id') String? currentOrderId,
    @JsonKey(name: 'current_order_total') double? currentOrderTotal,
    DateTime? lastOccupiedTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(json);
}