import 'package:dio/dio.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/product.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<Product>> getAllProducts() async {
    final response = await apiService.get('/products');
    final List<dynamic> data = response.data;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final response = await apiService.get('/products/$id');
    return Product.fromJson(response.data);
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await apiService.get('/products', queryParameters: {'categoryId': categoryId});
    final List<dynamic> data = response.data;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await apiService.get('/products/search', queryParameters: {'q': query});
    final List<dynamic> data = response.data;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<bool> insertProduct(Product product) async {
    final response = await apiService.post('/products', data: product.toJsonBackend());
    return response.statusCode == 201;
  }

  Future<bool> updateProduct(Product product) async {
    final response = await apiService.put('/products/${product.id}', data: product.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final response = await apiService.delete('/products/$id');
    return response.statusCode == 200;
  }

  Future<int> getStockLevel(String productId) async {
    final response = await apiService.get('/products/$productId/stock');
    return response.data['stock'] as int;
  }

  Future<void> updateStockLevel(String productId, int newStock) async {
    await apiService.put('/products/$productId/stock', data: {'stock': newStock});
  }

  Future<void> adjustStock(String productId, int delta) async {
    await apiService.post('/products/$productId/stock/adjust', data: {'delta': delta});
  }
} 