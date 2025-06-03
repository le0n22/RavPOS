import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/printer_settings_provider.dart';

class PrinterSettingsPage extends ConsumerWidget {
  const PrinterSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printers = ref.watch(printerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yazıcı Yönetimi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...printers.asMap().entries.map((entry) {
            final i = entry.key;
            final printer = entry.value;
            return Card(
              child: ListTile(
                title: Text(printer.name),
                subtitle: Text('${printer.ip}:${printer.port} - ${printer.type == PrinterType.receipt ? 'Fiş' : 'Mutfak'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final updated = await showDialog<PrinterSettings>(
                          context: context,
                          builder: (_) => _PrinterEditDialog(printer: printer),
                        );
                        if (updated != null) {
                          final newList = [...printers];
                          newList[i] = updated;
                          ref.read(printerSettingsProvider.notifier).state = newList;
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final newList = [...printers]..removeAt(i);
                        ref.read(printerSettingsProvider.notifier).state = newList;
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Yeni Yazıcı Ekle'),
            onPressed: () async {
              final newPrinter = await showDialog<PrinterSettings>(
                context: context,
                builder: (_) => const _PrinterEditDialog(),
              );
              if (newPrinter != null) {
                ref.read(printerSettingsProvider.notifier).state = [...printers, newPrinter];
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PrinterEditDialog extends StatefulWidget {
  final PrinterSettings? printer;
  const _PrinterEditDialog({this.printer});

  @override
  State<_PrinterEditDialog> createState() => _PrinterEditDialogState();
}

class _PrinterEditDialogState extends State<_PrinterEditDialog> {
  late TextEditingController nameController;
  late TextEditingController ipController;
  late TextEditingController portController;
  PrinterType type = PrinterType.receipt;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.printer?.name ?? '');
    ipController = TextEditingController(text: widget.printer?.ip ?? '');
    portController = TextEditingController(text: widget.printer?.port.toString() ?? '9100');
    type = widget.printer?.type ?? PrinterType.receipt;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.printer == null ? 'Yeni Yazıcı' : 'Yazıcıyı Düzenle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Yazıcı Adı'),
          ),
          TextField(
            controller: ipController,
            decoration: const InputDecoration(labelText: 'IP Adresi'),
          ),
          TextField(
            controller: portController,
            decoration: const InputDecoration(labelText: 'Port'),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<PrinterType>(
            value: type,
            items: const [
              DropdownMenuItem(value: PrinterType.receipt, child: Text('Fiş Yazıcı')),
              DropdownMenuItem(value: PrinterType.kitchen, child: Text('Mutfak Yazıcı')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => type = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty || ipController.text.isEmpty) return;
            Navigator.pop(
              context,
              PrinterSettings(
                name: nameController.text,
                ip: ipController.text,
                port: int.tryParse(portController.text) ?? 9100,
                type: type,
              ),
            );
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
} 