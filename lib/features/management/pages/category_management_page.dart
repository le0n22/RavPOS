import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/management/widgets/category_form.dart';
import 'package:ravpos/features/products/providers/category_provider.dart';
import 'package:ravpos/shared/models/models.dart';

class CategoryManagementPage extends ConsumerStatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends ConsumerState<CategoryManagementPage> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Yönetimi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.read(categoryProvider.notifier).forceRefresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kategoriler yenilendi')),
                );
              }
            },
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Hata: ${error.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(categoryProvider.notifier).forceRefresh(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz kategori bulunmamaktadır.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yeni kategori eklemek için \'+\' butonuna tıklayın.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryListItem(context, category);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, null),
        child: const Icon(Icons.add),
        tooltip: 'Yeni Kategori Ekle',
      ),
    );
  }

  Widget _buildCategoryListItem(BuildContext context, Category category) {
    // Get icon data from string
    IconData iconData = Icons.category;
    try {
      if (category.icon != null && category.icon!.isNotEmpty) {
        // Try to find the icon in common material icons
        final iconMap = {
          'restaurant_menu': Icons.restaurant_menu,
          'local_pizza': Icons.local_pizza,
          'coffee': Icons.local_cafe,
          'fastfood': Icons.fastfood,
          'cake': Icons.cake,
          'local_drink': Icons.local_drink,
          'lunch_dining': Icons.lunch_dining,
          'dinner_dining': Icons.dinner_dining,
          'breakfast_dining': Icons.breakfast_dining,
          'icecream': Icons.icecream,
          'liquor': Icons.liquor,
          'wine_bar': Icons.wine_bar,
          'emoji_food_beverage': Icons.emoji_food_beverage,
        };
        
        iconData = iconMap[category.icon] ?? Icons.category;
      }
    } catch (e) {
      print('Error parsing icon: $e');
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: category.isActive 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 51)
            : Colors.grey.withValues(alpha: 51),
          child: Icon(
            iconData,
            color: category.isActive 
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: category.isActive ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Görüntüleme Sırası: ${category.displayOrder}'),
            if (category.icon != null && category.icon!.isNotEmpty)
              Text('İkon: ${category.icon}'),
            if (!category.isActive)
              const Text(
                'Aktif Değil',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showCategoryDialog(context, category),
              tooltip: 'Düzenle',
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.red,
              onPressed: () => _showDeleteConfirmation(context, category),
              tooltip: 'Sil',
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCategoryDialog(BuildContext context, Category? category) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category == null ? 'Yeni Kategori Ekle' : 'Kategoriyi Düzenle',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: CategoryForm(
                  category: category,
                  onSave: (newCategory) async {
                    bool success;
                    if (category == null) {
                      success = await ref.read(categoryProvider.notifier).addCategory(newCategory);
                    } else {
                      success = await ref.read(categoryProvider.notifier).updateCategory(newCategory);
                    }
                    
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success 
                            ? category == null 
                              ? '${newCategory.name} başarıyla eklendi'
                              : '${newCategory.name} başarıyla güncellendi'
                            : category == null 
                              ? 'Kategori eklenirken hata oluştu'
                              : 'Kategori güncellenirken hata oluştu'
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kategoriyi Sil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bu kategoriyi silmek istediğinize emin misiniz?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Görüntüleme Sırası: ${category.displayOrder}'),
                  if (!category.isActive)
                    const Text(
                      'Aktif Değil',
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu işlem geri alınamaz. Bu kategoriye ait ürünler etkilenebilir.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(categoryProvider.notifier).deleteCategory(category.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 
                      '${category.name} başarıyla silindi' : 
                      'Kategori silinirken hata oluştu'
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
} 