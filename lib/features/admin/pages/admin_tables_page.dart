import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/tables/providers/table_provider.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';

class AdminTablesPage extends ConsumerStatefulWidget {
  const AdminTablesPage({super.key});

  @override
  ConsumerState<AdminTablesPage> createState() => _AdminTablesPageState();
}

class _AdminTablesPageState extends ConsumerState<AdminTablesPage> {
  final _uuid = const Uuid();
  String? _selectedCategory;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(tableProvider.notifier).loadTables());
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tableProvider);

    return Scaffold(
      body: Column(
        children: [
          // Action Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Category Filter
                Expanded(
                  child: tablesAsync.when(
                    data: (tables) {
                      final categories = tables
                          .map((t) => t.category)
                          .where((c) => c.isNotEmpty)
                          .toSet()
                          .toList();

                      return DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Filtresi',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Tümü'),
                          ),
                          ...categories.map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              )),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
                const SizedBox(width: 16),
                // Add New Table Button
                ElevatedButton.icon(
                  onPressed: () => _showAddTableDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Masa'),
                ),
                const SizedBox(width: 8),
                // Refresh Button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref.read(tableProvider.notifier).loadTables(),
                  tooltip: 'Yenile',
                ),
              ],
            ),
          ),
          // Tables List
          Expanded(
            child: tablesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Hata: $error'),
              ),
              data: (tables) {
                if (tables.isEmpty) {
                  return const Center(
                    child: Text('Henüz tanımlanmış masa bulunmamaktadır.'),
                  );
                }

                final filteredTables = _selectedCategory != null
                    ? tables.where((t) => t.category == _selectedCategory).toList()
                    : tables;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTables.length,
                  itemBuilder: (context, index) {
                    final table = filteredTables[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: table.status.color.withValues(alpha: 51),
                          child: Text(
                            table.name.substring(0, 1),
                            style: TextStyle(color: table.status.color),
                          ),
                        ),
                        title: Text(table.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kapasite: ${table.capacity} Kişi'),
                            if (table.category.isNotEmpty)
                              Text('Kategori: ${table.category}'),
                            Text('Durum: ${table.status.displayName}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<TableStatus>(
                              icon: const Icon(Icons.settings),
                              tooltip: 'Durum Yönet',
                              onSelected: (status) async {
                                final updatedTable = table.copyWith(
                                  status: status,
                                  currentOrderId: status == TableStatus.available ? null : table.currentOrderId,
                                  currentOrderTotal: status == TableStatus.available ? 0.0 : table.currentOrderTotal,
                                );
                                await ref.read(tableProvider.notifier).updateTable(updatedTable);
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem<TableStatus>(
                                  value: TableStatus.available,
                                  child: Text(TableStatus.available.displayName),
                                ),
                                PopupMenuItem<TableStatus>(
                                  value: TableStatus.outOfService,
                                  child: Text(TableStatus.outOfService.displayName),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.tune),
                              tooltip: 'Masa Özelleştir',
                              onPressed: () => _showEditTableDialog(context, table),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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

              final newTable = RestaurantTable(
                id: _uuid.v4(),
                name: nameController.text,
                capacity: capacity,
                category: categoryController.text.trim(),
                status: TableStatus.available,
                createdAt: DateTime.now(),
              );

              ref.read(tableProvider.notifier).addTable(newTable);
              Navigator.of(context).pop();
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditTableDialog(BuildContext context, RestaurantTable table) {
    final nameController = TextEditingController(text: table.name);
    final capacityController = TextEditingController(text: table.capacity.toString());
    final categoryController = TextEditingController(text: table.category);
    TableStatus selectedStatus = table.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${table.name} Düzenle'),
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
            const SizedBox(height: 16),
            DropdownButtonFormField<TableStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Durum',
                border: OutlineInputBorder(),
              ),
              items: TableStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status.displayName),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
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

              final updatedTable = table.copyWith(
                name: nameController.text,
                capacity: capacity,
                category: categoryController.text.trim(),
                status: selectedStatus,
                currentOrderId: selectedStatus == TableStatus.available ? null : table.currentOrderId,
                currentOrderTotal: selectedStatus == TableStatus.available ? 0.0 : table.currentOrderTotal,
              );
              ref.read(tableProvider.notifier).updateTable(updatedTable);
              Navigator.of(context).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${table.name} Silinecek'),
        content: const Text(
          'Bu masayı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tableProvider.notifier).deleteTable(table.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
} 