import 'package:dio/dio.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/table.dart';
import 'package:ravpos/shared/models/table_status.dart';

class TableRepository {
  final ApiService apiService;

  TableRepository(this.apiService);

  Future<List<RestaurantTable>> getTables() async {
    final response = await apiService.get('/tables');
    final List<dynamic> data = response.data;
    return data.map((json) => RestaurantTable.fromJson(json)).toList();
  }

  Future<RestaurantTable?> getTableById(String id) async {
    final response = await apiService.get('/tables/$id');
    return RestaurantTable.fromJson(response.data);
  }

  Future<String> addTable(RestaurantTable table) async {
    final response = await apiService.post('/tables', data: table.toJson());
    return response.data['id'] as String;
  }

  Future<void> updateTable(RestaurantTable table) async {
    try {
      print('[DEBUG] updateTable: Güncelleniyor -> id: ${table.id}, name: ${table.name}, status: ${table.status}, current_order_id: ${table.currentOrderId}, current_order_total: ${table.currentOrderTotal}');
      print('[DEBUG] updateTable: API body: ${table.toJson()}');
      final response = await apiService.put('/tables/${table.id}', data: table.toJson());
      print('[DEBUG] updateTable: API response: ${response.data}');
      if (response.statusCode == 200) {
        print('[DEBUG] updateTable: Güncelleme tamamlandı.');
      } else {
        print('[DEBUG] updateTable: API güncelleme başarısız. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating table: $e');
      rethrow;
    }
  }

  Future<int> deleteTable(String id) async {
    final response = await apiService.delete('/tables/$id');
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<RestaurantTable?> getTableByName(String name) async {
    final response = await apiService.get('/tables', queryParameters: {'name': name});
    final List<dynamic> data = response.data;
    if (data.isNotEmpty) {
      return RestaurantTable.fromJson(data.first);
    }
    return null;
  }

  Future<void> updateTableStatus(
    String tableId,
    TableStatus status, {
    String? currentOrderId,
  }) async {
    try {
      // Fetch existing table
      final existing = await getTableById(tableId);
      if (existing == null) return;
      // Create updated table instance
      final updated = existing.copyWith(
        status: status,
        currentOrderId: currentOrderId,
      );
      // Perform update
      await updateTable(updated);
    } catch (e) {
      print('Error updating table status in repository: $e');
      rethrow;
    }
  }
} 