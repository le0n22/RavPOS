import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../../shared/models/models.dart';

enum PrinterType {
  bluetooth,
  network,
  none,
}

class PrinterSettings {
  final PrinterType type;
  final String? address;
  final int? port;

  PrinterSettings({
    required this.type,
    this.address,
    this.port,
  });

  factory PrinterSettings.fromJson(Map<String, dynamic> json) {
    return PrinterSettings(
      type: PrinterType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PrinterType.none,
      ),
      address: json['address'],
      port: json['port'] != null ? int.parse(json['port'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'address': address,
      'port': port,
    };
  }
}

class PrinterService {
  NetworkPrinter? _networkPrinter;
  // BluetoothPrinter? _bluetoothPrinter; // Implement if needed in the future
  bool _isConnected = false;
  PrinterSettings? _settings;
  
  // Remove SharedPreferences logic, use only in-memory settings
  Future<void> loadSettings() async {
    // Optionally, fetch settings from backend here
    // For now, do nothing
  }
  
  Future<void> saveSettings(PrinterSettings settings) async {
    _settings = settings;
  }

  // Check if printer is connected
  bool get isConnected => _isConnected;
  
  // Get current settings
  PrinterSettings? get settings => _settings;

  // Connect to network printer
  Future<bool> connectNetworkPrinter(String ipAddress, int port) async {
    try {
      // First disconnect if already connected
      await disconnectPrinter();
      
      // Get profile for printer
      final profile = await CapabilityProfile.load();
      
      // Create printer connection with correct parameters
      final printer = NetworkPrinter(PaperSize.mm80, profile);
      
      // Try to connect
      final PosPrintResult result = await printer.connect(ipAddress, port: port);
      
      if (result == PosPrintResult.success) {
        _networkPrinter = printer;
        _isConnected = true;
        
        // Save settings
        _settings = PrinterSettings(
          type: PrinterType.network,
          address: ipAddress,
          port: port,
        );
        await saveSettings(_settings!);
        
        return true;
      } else {
        debugPrint('Failed to connect to printer: ${result.msg}');
        _isConnected = false;
        return false;
      }
    } catch (e) {
      debugPrint('Error connecting to network printer: $e');
      _isConnected = false;
      return false;
    }
  }

  // Connect to Bluetooth printer
  Future<bool> connectBluetoothPrinter(String address) async {
    // This would require additional packages and platform-specific code
    // For now, just return false or implement using a Bluetooth package
    debugPrint('Bluetooth printing not implemented yet');
    return false;
  }

  // Print document from bytes
  Future<bool> _printDocument(List<int> bytes) async {
    try {
      if (!_isConnected) {
        debugPrint('Printer not connected');
        return false;
      }
      
      if (_networkPrinter != null) {
        // Using the bytes directly with the printer
        _networkPrinter!.rawBytes(bytes);
        return true; // Assuming success if no exception is thrown
      }
      
      // Add Bluetooth implementation here if needed
      
      return false;
    } catch (e) {
      debugPrint('Error printing document: $e');
      return false;
    }
  }

  // Print customer receipt
  Future<bool> printReceipt(Order order) async {
    try {
      if (!_isConnected) {
        debugPrint('Printer not connected');
        return false;
      }
      
      // Get profile for printer
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      
      List<int> bytes = [];
      
      // Header
      bytes += generator.text('LEZZETLI RESTORAN',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      
      bytes += generator.text('MÜŞTERİ FİŞİ',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      
      bytes += generator.text(
          'Tarih: ${_formatDate(order.createdAt)}',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.text(
          'Sipariş No: ${order.orderNumber}',
          styles: const PosStyles(align: PosAlign.center));
      
      if (order.tableNumber != null) {
        bytes += generator.text(
            'MASA: ${order.tableNumber}',
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              bold: true,
            ));
      }
      
      bytes += generator.hr();
      
      // Order items
      bytes += generator.row([
        PosColumn(
          text: 'Ürün',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Adet',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Fiyat',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
      
      bytes += generator.hr();
      
      for (final item in order.items) {
        bytes += generator.row([
          PosColumn(
            text: item.productName,
            width: 6,
          ),
          PosColumn(
            text: '${item.quantity}x',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: '₺${item.totalPrice.toStringAsFixed(2)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      
      bytes += generator.hr();
      
      // Totals
      bytes += generator.row([
        PosColumn(
          text: 'Ara Toplam:',
          width: 8,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: '₺${order.totalAmount.toStringAsFixed(2)}',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      
      if (order.discountAmount != null && order.discountAmount! > 0) {
        bytes += generator.row([
          PosColumn(
            text: 'İndirim:',
            width: 8,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: '-₺${order.discountAmount!.toStringAsFixed(2)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      
      bytes += generator.hr();
      
      bytes += generator.row([
        PosColumn(
          text: 'TOPLAM:',
          width: 8,
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size2,
          ),
        ),
        PosColumn(
          text: '₺${(order.totalAmount - (order.discountAmount ?? 0)).toStringAsFixed(2)}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            bold: true,
          ),
        ),
      ]);
      
      // Payment method
      if (order.paymentMethod != null) {
        bytes += generator.text(
            'Ödeme Yöntemi: ${order.paymentMethod!.displayName}',
            styles: const PosStyles(align: PosAlign.center));
      }
      
      bytes += generator.hr();
      
      // Footer
      bytes += generator.text('Teşekkür Ederiz!',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      
      bytes += generator.text('Lezzetli Restoran',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.text('Tel: 123-456-7890',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.feed(2);
      bytes += generator.cut();
      
      return await _printDocument(bytes);
    } catch (e) {
      debugPrint('Error printing receipt: $e');
      return false;
    }
  }

  // Print kitchen ticket
  Future<bool> printKitchenTicket(Order order) async {
    try {
      if (!_isConnected) {
        debugPrint('Printer not connected');
        return false;
      }
      
      // Get profile for printer
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      
      List<int> bytes = [];
      
      // Header
      bytes += generator.text('LEZZETLI RESTORAN',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.text('MUTFAK SİPARİŞİ',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ));
      
      bytes += generator.text(
          'Sipariş No: ${order.orderNumber}',
          styles: const PosStyles(align: PosAlign.center));
      
      // Table number (very large and prominent)
      if (order.tableNumber != null) {
        bytes += generator.text(
            'MASA: ${order.tableNumber}',
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              bold: true,
            ));
      }
      
      bytes += generator.hr();
      
      // Order items (only name and quantity)
      for (final item in order.items) {
        bytes += generator.text(
            '${item.quantity}x ${item.productName}',
            styles: const PosStyles(
              bold: true,
              height: PosTextSize.size2,
            ));
            
        // Add special instructions if any (not implemented in the model yet)
        // if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty) {
        //   bytes += generator.text(
        //       '  ${item.specialInstructions}',
        //       styles: const PosStyles(
        //         fontType: PosFontType.fontB,
        //       ));
        // }
        
        bytes += generator.feed(1);
      }
      
      bytes += generator.hr();
      
      // Footer
      bytes += generator.text('LÜTFEN HAZIRLAYIN',
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
      
      bytes += generator.text(
          'Tarih: ${_formatDate(order.createdAt)}',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.feed(3);
      bytes += generator.cut();
      
      return await _printDocument(bytes);
    } catch (e) {
      debugPrint('Error printing kitchen ticket: $e');
      return false;
    }
  }

  // Print test page
  Future<bool> printTestPage() async {
    try {
      if (!_isConnected) {
        debugPrint('Printer not connected');
        return false;
      }
      
      // Get profile for printer
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      
      List<int> bytes = [];
      
      bytes += generator.text('YAZICI TEST SAYFASI',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
          ));
      
      bytes += generator.hr();
      
      bytes += generator.text('Bu bir test sayfasıdır.',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.text('Yazıcı bağlantısı başarılı!',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      
      bytes += generator.hr();
      
      bytes += generator.text('Tarih: ${_formatDate(DateTime.now())}',
          styles: const PosStyles(align: PosAlign.center));
      
      bytes += generator.feed(3);
      bytes += generator.cut();
      
      return await _printDocument(bytes);
    } catch (e) {
      debugPrint('Error printing test page: $e');
      return false;
    }
  }

  // Disconnect printer
  Future<void> disconnectPrinter() async {
    try {
      if (_networkPrinter != null) {
        _networkPrinter!.disconnect();
        _networkPrinter = null;
      }
      
      // Add Bluetooth disconnect here if needed
      
      _isConnected = false;
    } catch (e) {
      debugPrint('Error disconnecting printer: $e');
    }
  }

  // Helper method to format date
  String _formatDate(DateTime? date) {
    final d = date ?? DateTime(0);
    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }
}

// Provider for printer service
final printerServiceProvider = Provider<PrinterService>((ref) {
  return PrinterService();
}); 