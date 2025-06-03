import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PrinterType { receipt, kitchen }

class PrinterSettings {
  final String name;
  final String ip;
  final int port;
  final PrinterType type;
  PrinterSettings({
    required this.name,
    required this.ip,
    required this.port,
    required this.type,
  });
}

final printerSettingsProvider = StateProvider<List<PrinterSettings>>((ref) {
  return [
    PrinterSettings(name: 'Fiş Yazıcı', ip: '192.168.1.100', port: 9100, type: PrinterType.receipt),
    PrinterSettings(name: 'Mutfak Yazıcı', ip: '192.168.1.101', port: 9100, type: PrinterType.kitchen),
  ];
}); 