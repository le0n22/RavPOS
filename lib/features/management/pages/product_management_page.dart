import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/management/widgets/product_form.dart';
import 'package:ravpos/features/products/providers/product_provider.dart';
import 'package:ravpos/features/products/providers/category_provider.dart';
import 'package:ravpos/shared/models/models.dart';

class ProductManagementPage extends ConsumerStatefulWidget {
  const ProductManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends ConsumerState<ProductManagementPage> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);
    final categoriesAsync = ref.watch(categoryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Yönetimi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.read(productProvider.notifier).forceRefresh();
              await ref.read(categoryProvider.notifier).forceRefresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ürünler yenilendi')),
                );
              }
            },
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: productsAsync.when(
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
                onPressed: () => ref.read(productProvider.notifier).forceRefresh(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz ürün bulunmamaktadır.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yeni ürün eklemek için \'+\' butonuna tıklayın.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductListItem(context, product, categoriesAsync);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context, null),
        child: const Icon(Icons.add),
        tooltip: 'Yeni Ürün Ekle',
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product, AsyncValue<List<Category>> categoriesAsync) {
    // Find category name
    String categoryName = 'Kategori Yok';
    categoriesAsync.whenData((categories) {
      final category = categories.firstWhere(
        (c) => c.id == product.categoryId,
        orElse: () => const Category(id: '', name: 'Kategori Yok'),
      );
      categoryName = category.name;
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: product.isAvailable ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Fiyat: ₺${product.price.toStringAsFixed(2)}'),
            Text('Kategori: $categoryName'),
            Text('Hazırlık: ${product.preparationTime} dk'),
            if (!product.isAvailable)
              const Text(
                'Mevcut Değil',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: product.isAvailable 
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
          child: const Icon(
            Icons.restaurant_menu,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showProductDialog(context, product),
              tooltip: 'Düzenle',
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.red,
              onPressed: () => _showDeleteConfirmation(context, product),
              tooltip: 'Sil',
            ),
          ],
        ),
      ),
    );
  }
  
  void _showProductDialog(BuildContext context, Product? product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product == null ? 'Yeni Ürün Ekle' : 'Ürünü Düzenle',
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
                child: ProductForm(
                  product: product,
                  onSave: (newProduct) async {
                    bool success;
                    if (product == null) {
                      success = await ref.read(productProvider.notifier).addProduct(newProduct);
                    } else {
                      success = await ref.read(productProvider.notifier).updateProduct(newProduct);
                    }
                    
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success 
                            ? product == null 
                              ? '${newProduct.name} başarıyla eklendi'
                              : '${newProduct.name} başarıyla güncellendi'
                            : product == null 
                              ? 'Ürün eklenirken hata oluştu'
                              : 'Ürün güncellenirken hata oluştu'
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
  
  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ürünü Sil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bu ürünü silmek istediğinize emin misiniz?'),
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
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Fiyat: ₺${product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu işlem geri alınamaz.',
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
              final success = await ref.read(productProvider.notifier).deleteProduct(product.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 
                      '${product.name} başarıyla silindi' : 
                      'Ürün silinirken hata oluştu'
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