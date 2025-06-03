import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer.freezed.dart';
part 'printer.g.dart';

enum PrinterType { receipt, kitchen, label }

@freezed
class Printer with _$Printer {
  const factory Printer({
    required String id,
    required String name,
    required PrinterType type,
    required String ipAddress,
    required int port,
    @Default(true) bool isActive,
    String? location,
    DateTime? lastUsed,
  }) = _Printer;

  factory Printer.fromJson(Map<String, dynamic> json) => _$PrinterFromJson(json);
} 