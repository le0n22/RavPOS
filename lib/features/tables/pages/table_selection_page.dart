import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/features/tables/providers/table_provider.dart';
import 'package:ravpos/features/tables/widgets/table_card.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';

class TableSelectionPage extends ConsumerStatefulWidget {
  const TableSelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends ConsumerState<TableSelectionPage> {
  final _uuid = const Uuid();
  
  @override
  void initState() {
    super.initState();
    // Ensure tables are loaded when page is first opened
    Future.microtask(() => ref.read(tableProvider.notifier).loadTables());
  }

  @override
  Widget build(BuildContext context) {
    // Watch the tables state
    final tablesAsync = ref.watch(tableProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masalar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(tableProvider.notifier).loadTables(),
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: tablesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Hata: ${error.toString()}'),
        ),
        data: (tables) {
          if (tables.isEmpty) {
            return const Center(child: Text('Henüz tanımlanmış masa bulunmamaktadır.'));
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive design: Adjust columns based on width
                final width = constraints.maxWidth;
                final crossAxisCount = width < 600 ? 2 : width < 1200 ? 3 : 4;
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final table = tables[index];
                    return TableCard(
                      table: table,
                      key: ValueKey(table.id),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTableDialog(context),
        tooltip: 'Yeni Masa Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTableDialog(BuildContext context) {
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '4');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Masa Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Masa Adı'),
              autofocus: true,
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: 'Kapasite'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate inputs
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Masa adı boş olamaz')),
                );
                return;
              }
              
              final capacity = int.tryParse(capacityController.text);
              if (capacity == null || capacity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Geçerli bir kapasite girin')),
                );
                return;
              }
              
              // Create new table
              final newTable = RestaurantTable(
                id: _uuid.v4(),
                name: nameController.text,
                capacity: capacity,
                status: TableStatus.available,
                createdAt: DateTime.now(),
              );
              
              // Add to database via provider
              ref.read(tableProvider.notifier).addTable(newTable);
              Navigator.of(context).pop();
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
} 