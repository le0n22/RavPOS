import 'package:freezed_annotation/freezed_annotation.dart';
import 'table_status.dart';

part 'table.freezed.dart';
part 'table.g.dart';

@freezed
class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required String id,
    required String name,
    @Default(4) int capacity, // Masa kapasitesi (kaç kişilik)
    @Default(TableStatus.available) TableStatus status,
    @Default(0.0) double xPosition, // Görsel yerleşim için
    @Default(0.0) double yPosition, // Görsel yerleşim için
    String? currentOrderId, // Masada aktif olan siparişin ID'si
    @Default(0.0) double currentOrderTotal, // Aktif siparişin toplam tutarı
    DateTime? lastOccupiedTime, // En son ne zaman meşgul olduğu
    required DateTime? createdAt,
    DateTime? updatedAt,
    @Default('') String category, // Masa kategorisi (örn: Bahçe, İç Mekan, VIP)
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) => _$RestaurantTableFromJson(json);
} 