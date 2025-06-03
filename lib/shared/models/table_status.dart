import 'package:flutter/material.dart';

enum TableStatus {
  available,       // Boş, yeni sipariş için hazır
  occupied,        // Dolu, aktif sipariş var
  paymentPending,  // Ödeme bekleniyor
  outOfService,    // Servis dışı
}

extension TableStatusExtension on TableStatus {
  String get displayName {
    switch (this) {
      case TableStatus.available: return 'Müsait';
      case TableStatus.occupied: return 'Dolu';
      case TableStatus.paymentPending: return 'Ödeme Bekleniyor';
      case TableStatus.outOfService: return 'Servis Dışı';
    }
  }

  Color get color {
    switch (this) {
      case TableStatus.available: return Colors.green.shade400;
      case TableStatus.occupied: return Colors.orange.shade400;
      case TableStatus.paymentPending: return Colors.yellow.shade700;
      case TableStatus.outOfService: return Colors.grey.shade400;
    }
  }

  IconData get icon {
    switch (this) {
      case TableStatus.available: return Icons.check_circle_outline;
      case TableStatus.occupied: return Icons.table_chart;
      case TableStatus.paymentPending: return Icons.payment;
      case TableStatus.outOfService: return Icons.do_not_disturb_on_outlined;
    }
  }
  
  static TableStatus fromString(String value) {
    return TableStatus.values.firstWhere(
      (status) => status.toString().split('.').last == value,
      orElse: () => TableStatus.available,
    );
  }
} 