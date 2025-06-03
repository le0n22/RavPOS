import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/printer_provider.dart';
import '../../../../shared/models/printer.dart';

class PrinterManagementPage extends ConsumerWidget {
  const PrinterManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printersAsync = ref.watch(printerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Printer Management')),
      body: printersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (printers) => ListView.builder(
          itemCount: printers.length,
          itemBuilder: (context, index) {
            final printer = printers[index];
            return ListTile(
              title: Text(printer.name),
              subtitle: Text('${printer.type.name} • ${printer.ipAddress}:${printer.port}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print),
                    tooltip: 'Test Print',
                    onPressed: () async {
                      await ref.read(printerProvider.notifier).printTestPage(printer.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Test page sent to [1m${printer.name}[0m')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () async {
                      await ref.read(printerProvider.notifier).deletePrinter(printer.id);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add printer dialog
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Printer',
      ),
    );
  }
} 