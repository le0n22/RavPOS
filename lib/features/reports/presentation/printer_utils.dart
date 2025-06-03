import 'package:esc_pos_printer/esc_pos_printer.dart' as pos_printer;
import 'package:esc_pos_utils/esc_pos_utils.dart' as esc_utils show Generator, CapabilityProfile, PaperSize, PosStyles, PosAlign;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as pos_bt;
import 'package:ravpos/shared/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/reports/providers/printer_settings_provider.dart';
import 'package:ravpos/features/reports/providers/receipt_template_provider.dart';
import 'package:flutter/material.dart';
import 'package:ravpos/features/reports/providers/print_log_provider.dart';

Future<void> printOrderReport(List<Order> orders, WidgetRef ref, PrinterType type) async {
  final printers = ref.read(printerSettingsProvider);
  final filtered = printers.where((p) => p.type == type);
  if (filtered.isEmpty) {
    print('${type == PrinterType.receipt ? 'Fiş' : 'Mutfak'} yazıcı tanımlı değil!');
    return;
  }
  final printer = filtered.first;
  final profile = await esc_utils.CapabilityProfile.load();
  final networkPrinter = pos_printer.NetworkPrinter(esc_utils.PaperSize.mm80, profile);
  final res = await networkPrinter.connect(printer.ip, port: printer.port);
  if (res == pos_printer.PosPrintResult.success) {
    networkPrinter.text('Detaylı Sipariş Raporu', styles: esc_utils.PosStyles(align: esc_utils.PosAlign.center, bold: true));
    networkPrinter.hr();
    for (final order in orders) {
      networkPrinter.text('Masa: ${order.tableNumber ?? '-'}  Tutar: ₺${order.totalAmount.toStringAsFixed(2)}');
      networkPrinter.text('Tarih: ${(order.updatedAt ?? order.createdAt)?.toString() ?? '-'}');
      networkPrinter.text('Ödeme: ${order.paymentMethod?.toString().split('.').last ?? '-'}');
      networkPrinter.hr(ch: '-');
    }
    networkPrinter.feed(2);
    networkPrinter.cut();
    networkPrinter.disconnect();
  } else {
    print('Yazıcıya bağlanılamadı: $res');
  }
}

Future<void> printOrderReportBluetooth(List<Order> orders) async {
  final printerManager = pos_bt.PrinterBluetoothManager();
  final profile = await esc_utils.CapabilityProfile.load();
  List<pos_bt.PrinterBluetooth> foundPrinters = [];
  final scanSubscription = printerManager.scanResults.listen((devices) {
    foundPrinters = devices;
  });
  printerManager.startScan(const Duration(seconds: 4));
  await Future.delayed(const Duration(seconds: 4));
  await scanSubscription.cancel();
  printerManager.stopScan();
  if (foundPrinters.isEmpty) {
    print('Bluetooth yazıcı bulunamadı.');
    return;
  }
  final selectedPrinter = foundPrinters.first;
  printerManager.selectPrinter(selectedPrinter);
  final result = await printerManager.printTicket(
    await buildBluetoothTicket(orders, profile),
  );
  print('Yazdırma sonucu: $result');
}

Future<List<int>> buildBluetoothTicket(List<Order> orders, esc_utils.CapabilityProfile profile) async {
  final generator = esc_utils.Generator(esc_utils.PaperSize.mm80, profile);
  List<int> bytes = [];
  bytes += generator.text('Detaylı Sipariş Raporu', styles: esc_utils.PosStyles(align: esc_utils.PosAlign.center, bold: true));
  bytes += generator.hr();
  for (final order in orders) {
    bytes += generator.text('Masa: ${order.tableNumber ?? '-'}  Tutar: ₺${order.totalAmount.toStringAsFixed(2)}');
    bytes += generator.text('Tarih: ${(order.updatedAt ?? order.createdAt)?.toString() ?? '-'}');
    bytes += generator.text('Ödeme: ${order.paymentMethod?.toString().split('.').last ?? '-'}');
    bytes += generator.hr(ch: '-');
  }
  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

String fillTemplate(String template, Order order) {
  final date = (order.updatedAt ?? order.createdAt) ?? DateTime.now();
  final dateStr = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  final itemsStr = order.items.map((item) =>
    '${item.quantity} x ${item.productName}  ₺${(item.quantity * item.unitPrice).toStringAsFixed(2)}'
  ).join('\n');
  final productsStr = order.items.map((item) =>
    '${item.productName} (${item.quantity}): ₺${item.totalPrice.toStringAsFixed(2)}'
  ).join(', ');
  final itemsTable = order.items.map((item) =>
    '${item.productName.padRight(16)} ${item.quantity.toString().padLeft(2)} x ${item.unitPrice.toStringAsFixed(2).padLeft(6)} = ${item.totalPrice.toStringAsFixed(2).padLeft(7)}'
  ).join('\n');
  final discount = order.discountAmount != null ? order.discountAmount!.toStringAsFixed(2) : '0.00';
  final tax = order.metadata != null && order.metadata!['tax'] != null ? order.metadata!['tax'].toString() : '';
  final waiter = order.metadata != null && order.metadata!['waiter'] != null ? order.metadata!['waiter'].toString() : '';
  final branch = order.metadata != null && order.metadata!['branch'] != null ? order.metadata!['branch'].toString() : '';
  final customerNote = order.customerNote ?? '';
  final paymentType = (order.paymentMethod?.toString().split('.').last ?? '-');
  final total = order.totalAmount.toStringAsFixed(2);
  final finalAmount = order.totalAmount.toStringAsFixed(2);

  // Döngü: {#ITEMS} ... {/ITEMS}
  final itemsLoopReg = RegExp(r'{#ITEMS}([\s\S]*?){/ITEMS}');
  String result = template.replaceAllMapped(itemsLoopReg, (match) {
    final inner = match.group(1)!;
    return order.items.map((item) {
      return inner
        .replaceAll('{PRODUCT_NAME}', item.productName)
        .replaceAll('{QUANTITY}', item.quantity.toString())
        .replaceAll('{UNIT_PRICE}', item.unitPrice.toStringAsFixed(2))
        .replaceAll('{TOTAL_PRICE}', item.totalPrice.toStringAsFixed(2))
        .replaceAll('{SPECIAL}', item.specialInstructions ?? '');
    }).join('\n');
  });

  // Temel alanlar
  result = result
    .replaceAll('{ORDER_NO}', order.orderNumber)
    .replaceAll('{TABLE_NO}', order.tableNumber ?? '-')
    .replaceAll('{DATE}', dateStr)
    .replaceAll('{TIME}', timeStr)
    .replaceAll('{ITEMS}', itemsStr)
    .replaceAll('{PRODUCTS}', productsStr)
    .replaceAll('{ITEMS_TABLE}', itemsTable)
    .replaceAll('{TOTAL}', '₺$total')
    .replaceAll('{FINAL_TOTAL}', '₺$finalAmount')
    .replaceAll('{DISCOUNT}', discount)
    .replaceAll('{TAX}', tax)
    .replaceAll('{WAITER}', waiter)
    .replaceAll('{BRANCH}', branch)
    .replaceAll('{CUSTOMER_NOTE}', customerNote)
    .replaceAll('{PAYMENT_TYPE}', paymentType);
  return result;
}

Future<void> printOrderWithTemplate({
  required Order order,
  required WidgetRef ref,
  required String printerName,
  BuildContext? context,
}) async {
  // 1. Mapping ve şablon bul
  final mappings = ref.read(printerTemplateMappingsProvider);
  final templates = ref.read(receiptTemplatesProvider);
  final printers = ref.read(printerSettingsProvider);
  final printLogNotifier = ref.read(printLogProvider.notifier);
  PrinterTemplateMapping? mapping;
  try {
    mapping = mappings.firstWhere((m) => m.printerName == printerName);
  } catch (_) {
    mapping = null;
  }
  if (mapping == null) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yazıcı için şablon eşleştirmesi bulunamadı: $printerName')),
      );
    }
    printLogNotifier.addLog(PrintLogEntry(
      timestamp: DateTime.now(),
      printerName: printerName,
      templateName: null,
      orderNumber: order.orderNumber,
      success: false,
      errorMessage: 'Şablon eşleştirmesi bulunamadı',
      contentPreview: null,
    ));
    return;
  }
  ReceiptTemplate? template;
  try {
    template = templates.firstWhere((t) => t.id == mapping!.templateId);
  } catch (_) {
    template = null;
  }
  if (template == null) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şablon bulunamadı: ${mapping.templateId}')),
      );
    }
    printLogNotifier.addLog(PrintLogEntry(
      timestamp: DateTime.now(),
      printerName: printerName,
      templateName: null,
      orderNumber: order.orderNumber,
      success: false,
      errorMessage: 'Şablon bulunamadı',
      contentPreview: null,
    ));
    return;
  }
  PrinterSettings? printer;
  try {
    printer = printers.firstWhere((p) => p.name == printerName);
  } catch (_) {
    printer = null;
  }
  if (printer == null) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yazıcı bulunamadı: $printerName')),
      );
    }
    printLogNotifier.addLog(PrintLogEntry(
      timestamp: DateTime.now(),
      printerName: printerName,
      templateName: template.name,
      orderNumber: order.orderNumber,
      success: false,
      errorMessage: 'Yazıcı bulunamadı',
      contentPreview: null,
    ));
    return;
  }

  // 2. Şablonu doldur
  String content = fillTemplate(template.contentTemplate, order);

  // 3. Yazıcıya gönder
  try {
    final profile = await esc_utils.CapabilityProfile.load();
    final networkPrinter = pos_printer.NetworkPrinter(esc_utils.PaperSize.mm80, profile);
    final res = await networkPrinter.connect(printer.ip, port: printer.port);
    if (res == pos_printer.PosPrintResult.success) {
      networkPrinter.text(template.header, styles: esc_utils.PosStyles(align: esc_utils.PosAlign.center, bold: true));
      networkPrinter.hr();
      for (final line in content.split('\n')) {
        networkPrinter.text(line, styles: esc_utils.PosStyles(align: esc_utils.PosAlign.left));
      }
      networkPrinter.hr();
      networkPrinter.text(template.footer, styles: esc_utils.PosStyles(align: esc_utils.PosAlign.center));
      networkPrinter.feed(2);
      networkPrinter.cut();
      networkPrinter.disconnect();
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fiş başarıyla yazdırıldı ($printerName)')),
        );
      }
      printLogNotifier.addLog(PrintLogEntry(
        timestamp: DateTime.now(),
        printerName: printerName,
        templateName: template.name,
        orderNumber: order.orderNumber,
        success: true,
        errorMessage: null,
        contentPreview: content.length > 200 ? content.substring(0, 200) : content,
      ));
    } else {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yazıcıya bağlanılamadı: $printerName')),);
      }
      printLogNotifier.addLog(PrintLogEntry(
        timestamp: DateTime.now(),
        printerName: printerName,
        templateName: template.name,
        orderNumber: order.orderNumber,
        success: false,
        errorMessage: 'Yazıcıya bağlanılamadı',
        contentPreview: content.length > 200 ? content.substring(0, 200) : content,
      ));
    }
  } catch (e) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yazdırma hatası: $e')),
      );
    }
    printLogNotifier.addLog(PrintLogEntry(
      timestamp: DateTime.now(),
      printerName: printerName,
      templateName: template.name,
      orderNumber: order.orderNumber,
      success: false,
      errorMessage: 'Yazdırma hatası: $e',
      contentPreview: content.length > 200 ? content.substring(0, 200) : content,
    ));
  }
} 