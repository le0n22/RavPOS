import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ravpos/shared/models/models.dart'; // ProductSales, OrderStatus
import 'package:ravpos/shared/models/table_report.dart';

part 'report_data.freezed.dart';
part 'report_data.g.dart';

@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    @Default(0.0) double totalSales, // Toplam satış hacmi
    @Default(0) int totalOrders, // Toplam sipariş sayısı
    @Default(0.0) double averageOrderValue, // Ortalama sipariş tutarı
    @Default(0.0) double totalDiscountGiven, // Uygulanan toplam indirim
    @Default({}) Map<String, double> salesByPaymentMethod, // Örn: {'Nakit': 1000.0, 'Kart': 500.0}
    @Default([]) List<ProductSales> topSellingProducts, // En çok satan ürünler
    @Default({}) Map<DateTime, double> dailySalesData, // Günlük satış verileri {DateTime(yıl, ay, gün): toplamSatış}
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default([]) List<Order> orders, // Raporlanan siparişler
    @Default({}) Map<int, int> hourlyOrderCounts, // Saatlik sipariş yoğunluğu
    @Default({}) Map<String, TableReport> tableReports, // Masa bazlı raporlar
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);
} 