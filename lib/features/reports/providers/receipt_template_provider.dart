import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum ReceiptTemplateType { receipt, kitchen, bill }

class ReceiptTemplate {
  final String id;
  final String name;
  final ReceiptTemplateType type;
  final String header;
  final String footer;
  final String contentTemplate; // For future dynamic fields
  final double fontSize;
  // Add more fields as needed (logo, line spacing, etc.)

  ReceiptTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.header,
    required this.footer,
    required this.contentTemplate,
    required this.fontSize,
  });

  ReceiptTemplate copyWith({
    String? id,
    String? name,
    ReceiptTemplateType? type,
    String? header,
    String? footer,
    String? contentTemplate,
    double? fontSize,
  }) {
    return ReceiptTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      contentTemplate: contentTemplate ?? this.contentTemplate,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

final receiptTemplatesProvider = StateNotifierProvider<ReceiptTemplatesNotifier, List<ReceiptTemplate>>((ref) {
  return ReceiptTemplatesNotifier();
});

class ReceiptTemplatesNotifier extends StateNotifier<List<ReceiptTemplate>> {
  ReceiptTemplatesNotifier() : super(_initialTemplates());

  static List<ReceiptTemplate> _initialTemplates() => [
    ReceiptTemplate(
      id: const Uuid().v4(),
      name: 'Müşteri Fişi',
      type: ReceiptTemplateType.receipt,
      header: 'İşletme Adı',
      footer: 'Teşekkürler',
      contentTemplate: '',
      fontSize: 12,
    ),
    ReceiptTemplate(
      id: const Uuid().v4(),
      name: 'Mutfak Fişi',
      type: ReceiptTemplateType.kitchen,
      header: 'Mutfak',
      footer: '',
      contentTemplate: '',
      fontSize: 12,
    ),
    ReceiptTemplate(
      id: const Uuid().v4(),
      name: 'Hesap Fişi',
      type: ReceiptTemplateType.bill,
      header: 'Hesap',
      footer: 'İyi Günler',
      contentTemplate: '',
      fontSize: 12,
    ),
  ];

  void addTemplate(ReceiptTemplate template) {
    state = [...state, template];
  }

  void updateTemplate(ReceiptTemplate template) {
    state = [
      for (final t in state)
        if (t.id == template.id) template else t
    ];
  }

  void deleteTemplate(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

// Printer-Template Mapping Model
class PrinterTemplateMapping {
  final String printerName; // or printerId if available
  final String templateId;
  PrinterTemplateMapping({required this.printerName, required this.templateId});

  PrinterTemplateMapping copyWith({String? printerName, String? templateId}) {
    return PrinterTemplateMapping(
      printerName: printerName ?? this.printerName,
      templateId: templateId ?? this.templateId,
    );
  }
}

final printerTemplateMappingsProvider = StateNotifierProvider<PrinterTemplateMappingsNotifier, List<PrinterTemplateMapping>>((ref) {
  return PrinterTemplateMappingsNotifier();
});

class PrinterTemplateMappingsNotifier extends StateNotifier<List<PrinterTemplateMapping>> {
  PrinterTemplateMappingsNotifier() : super([]);

  void addMapping(PrinterTemplateMapping mapping) {
    state = [...state, mapping];
  }

  void updateMapping(PrinterTemplateMapping mapping) {
    state = [
      for (final m in state)
        if (m.printerName == mapping.printerName) mapping else m
    ];
  }

  void removeMapping(String printerName) {
    state = state.where((m) => m.printerName != printerName).toList();
  }

  PrinterTemplateMapping? getMappingForPrinter(String printerName) {
    try {
      return state.firstWhere((m) => m.printerName == printerName);
    } catch (_) {
      return null;
    }
  }
} 