import 'package:dio/dio.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/category.dart';

class CategoryRepository {
  final ApiService apiService;

  CategoryRepository(this.apiService);

  Future<List<Category>> getCategories() async {
    final response = await apiService.get('/categories');
    final List<dynamic> data = response.data;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final response = await apiService.get('/categories/$id');
    return Category.fromJson(response.data);
  }

  Future<String> insertCategory(Category category) async {
    final response = await apiService.post('/categories', data: category.toJson());
    return response.data['id'] as String;
  }

  Future<int> updateCategory(Category category) async {
    final response = await apiService.put('/categories/${category.id}', data: category.toJson());
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<int> deleteCategory(String id) async {
    final response = await apiService.delete('/categories/$id');
    return response.statusCode == 200 ? 1 : 0;
  }
} 