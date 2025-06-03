import 'package:ravpos/shared/models/discount.dart';
import 'package:ravpos/core/network/api_service.dart';

class DiscountRepository {
  final ApiService apiService;
  DiscountRepository(this.apiService);

  Future<List<Discount>> getAllDiscounts() async {
    final response = await apiService.get('/discounts');
    final List<dynamic> data = response.data;
    return data.map((json) => Discount.fromJson(json)).toList();
  }

  Future<List<Discount>> getActiveDiscounts() async {
    final response = await apiService.get('/discounts/active');
    final List<dynamic> data = response.data;
    return data.map((json) => Discount.fromJson(json)).toList();
  }

  Future<Discount> createDiscount(Discount discount) async {
    final response = await apiService.post('/discounts', data: discount.toJson());
    return Discount.fromJson(response.data);
  }

  Future<Discount> updateDiscount(Discount discount) async {
    final response = await apiService.put('/discounts/${discount.id}', data: discount.toJson());
    return Discount.fromJson(response.data);
  }

  Future<void> deleteDiscount(String id) async {
    await apiService.delete('/discounts/$id');
  }

  Future<void> applyDiscountToOrder(String orderId, String discountId) async {
    await apiService.post('/orders/$orderId/apply-discount', data: {'discountId': discountId});
  }
} 