import 'package:freezed_annotation/freezed_annotation.dart';
import 'order.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    @Default(0) double todaySales,
    @Default(0) int todayOrderCount,
    @Default(0) int pendingOrdersCount,
    @Default(0) int totalProductsCount,
    @Default(0) int totalCategoriesCount,
    @Default([]) List<Order> recentOrders,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) => 
      _$DashboardDataFromJson(json);
} 