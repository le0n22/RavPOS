import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/repositories/printer_repository.dart';
import '../../../shared/models/printer.dart';
import '../../../core/network/api_service.dart';

class PrinterNotifier extends AsyncNotifier<List<Printer>> {
  late final PrinterRepository _repository;

  @override
  Future<List<Printer>> build() async {
    _repository = PrinterRepository(ref.read(apiServiceProvider));
    return fetchAllPrinters();
  }

  Future<List<Printer>> fetchAllPrinters() async {
    state = const AsyncLoading();
    try {
      final printers = await _repository.getAllPrinters();
      state = AsyncData(printers);
      return printers;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<Printer?> createPrinter(Printer printer) async {
    try {
      final created = await _repository.createPrinter(printer);
      await fetchAllPrinters();
      return created;
    } catch (e) {
      return null;
    }
  }

  Future<Printer?> updatePrinter(Printer printer) async {
    try {
      final updated = await _repository.updatePrinter(printer);
      await fetchAllPrinters();
      return updated;
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePrinter(String id) async {
    try {
      await _repository.deletePrinter(id);
      await fetchAllPrinters();
    } catch (e) {}
  }

  Future<void> printTestPage(String id) async {
    await _repository.printTestPage(id);
  }
}

final printerProvider = AsyncNotifierProvider<PrinterNotifier, List<Printer>>(
  () => PrinterNotifier(),
); 