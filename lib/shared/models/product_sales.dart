import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_sales.freezed.dart';
part 'product_sales.g.dart';

@freezed
class ProductSales with _$ProductSales {
  const factory ProductSales({
    required String productId,
    required String productName,
    required int totalQuantitySold,
    required double totalRevenue,
  }) = _ProductSales;

  factory ProductSales.fromJson(Map<String, dynamic> json) => _$ProductSalesFromJson(json);
} 