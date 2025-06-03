import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/tables/providers/table_provider.dart';
import 'package:ravpos/features/tables/presentation/widgets/table_card.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:ravpos/core/router/app_router.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  final _uuid = const Uuid();
  List<RestaurantTable>? _localTables;
  String? _selectedCategory;
  
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
          // Category filter button
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Kategoriye Göre Filtrele',
            onSelected: (category) {
              setState(() {
                _selectedCategory = category == 'all' ? null : category;
              });
            },
            itemBuilder: (context) {
              final categories = tablesAsync.when(
                data: (tables) {
                  final uniqueCategories = tables
                      .map((t) => t.category)
                      .where((c) => c.isNotEmpty)
                      .toSet()
                      .toList();
                  return ['all', ...uniqueCategories];
                },
                loading: () => <String>[],
                error: (_, __) => <String>[],
              );
              
              return [
                const PopupMenuItem(
                  value: 'all',
                  child: Text('Tümü'),
                ),
                ...categories.where((c) => c != 'all').map((category) => 
                  PopupMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                ),
              ];
            },
          ),
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
          
          // Filter tables by category if selected
          final filteredTables = _selectedCategory != null
              ? tables.where((t) => t.category == _selectedCategory).toList()
              : tables;
          
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive design: Adjust columns based on width
                final width = constraints.maxWidth;
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width < 600 ? 2 : width < 1200 ? 4 : 6,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredTables.length,
                  itemBuilder: (context, index) {
                    final table = filteredTables[index];
                    return TableCard(
                      key: ValueKey(table.id),
                      table: table,
                      onTap: () {
                        // Navigate to the table order page
                        context.goToTableOrder(table.id);
                      },
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
        child: const Icon(Icons.add),
        tooltip: 'Yeni Masa Ekle',
      ),
    );
  }

  void _showAddTableDialog(BuildContext context) {
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '4');
    final categoryController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Masa Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Masa Adı',
                hintText: 'Örn: Masa 1',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Kapasite',
                hintText: 'Örn: 4',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                hintText: 'Örn: Bahçe, İç Mekan, VIP',
              ),
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
                category: categoryController.text.trim(),
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