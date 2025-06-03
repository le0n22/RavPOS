import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLogEntry {
  final DateTime timestamp;
  final String printerName;
  final String? templateName;
  final String? orderNumber;
  final bool success;
  final String? errorMessage;
  final String? contentPreview;

  PrintLogEntry({
    required this.timestamp,
    required this.printerName,
    this.templateName,
    this.orderNumber,
    required this.success,
    this.errorMessage,
    this.contentPreview,
  });
}

class PrintLogNotifier extends StateNotifier<List<PrintLogEntry>> {
  PrintLogNotifier() : super([]);

  void addLog(PrintLogEntry entry) {
    state = [entry, ...state]; // En yeni başa
    if (state.length > 200) {
      state = state.sublist(0, 200); // Maksimum 200 log tut
    }
  }

  void clearLogs() {
    state = [];
  }
}

final printLogProvider = StateNotifierProvider<PrintLogNotifier, List<PrintLogEntry>>(
  (ref) => PrintLogNotifier(),
); 