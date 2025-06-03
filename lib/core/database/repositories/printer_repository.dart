import 'package:ravpos/shared/models/printer.dart';
import 'package:ravpos/core/network/api_service.dart';

class PrinterRepository {
  final ApiService apiService;
  PrinterRepository(this.apiService);

  Future<List<Printer>> getAllPrinters() async {
    final response = await apiService.get('/printers');
    final List<dynamic> data = response.data;
    return data.map((json) => Printer.fromJson(json)).toList();
  }

  Future<Printer> getPrinter(String id) async {
    final response = await apiService.get('/printers/$id');
    return Printer.fromJson(response.data);
  }

  Future<Printer> createPrinter(Printer printer) async {
    final response = await apiService.post('/printers', data: printer.toJson());
    return Printer.fromJson(response.data);
  }

  Future<Printer> updatePrinter(Printer printer) async {
    final response = await apiService.put('/printers/${printer.id}', data: printer.toJson());
    return Printer.fromJson(response.data);
  }

  Future<void> deletePrinter(String id) async {
    await apiService.delete('/printers/$id');
  }

  Future<void> printTestPage(String id) async {
    await apiService.post('/printers/$id/test');
  }
} 