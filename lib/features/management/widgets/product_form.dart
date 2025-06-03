import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/products/providers/category_provider.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';

class ProductForm extends ConsumerStatefulWidget {
  final Product? product;
  final Function(Product product) onSave;

  const ProductForm({
    Key? key,
    this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  
  String? _selectedCategoryId;
  bool _isAvailable = true;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description ?? '';
      _imageUrlController.text = widget.product!.imageUrl ?? '';
      _prepTimeController.text = widget.product!.preparationTime.toString();
      _selectedCategoryId = widget.product!.categoryId;
      _isAvailable = widget.product!.isAvailable;
      // Set default values for new fields since they don't exist in current Product model
      _stockQuantityController.text = '0';
      _reorderLevelController.text = '0';
    } else {
      _prepTimeController.text = '0';
      _stockQuantityController.text = '0';
      _reorderLevelController.text = '0';
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    _stockQuantityController.dispose();
    _reorderLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              widget.product == null ? 'Yeni Ürün Ekle' : 'Ürünü Düzenle',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Product Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ürün Adı *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fastfood),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen bir ürün adı girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Price
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Fiyat *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: '₺',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen bir fiyat girin';
                }
                final price = double.tryParse(value.trim());
                if (price == null || price <= 0) {
                  return 'Geçerli bir fiyat girin (0\'dan büyük)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Category dropdown
            categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange.shade50,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Henüz kategori bulunmuyor. Önce kategori eklemeniz gerekmektedir.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir kategori seçin';
                    }
                    return null;
                  },
                );
              },
              loading: () => Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Kategoriler yükleniyor...'),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.shade50,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kategoriler yüklenirken hata oluştu: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Image URL
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Resim URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                                     final uri = Uri.tryParse(value.trim());                   if (uri == null || !uri.hasAbsolutePath) {
                    return 'Geçerli bir URL girin';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Preparation Time
            TextFormField(
              controller: _prepTimeController,
              decoration: const InputDecoration(
                labelText: 'Hazırlık Süresi (dakika) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen hazırlık süresini girin';
                }
                final time = int.tryParse(value.trim());
                if (time == null || time < 0) {
                  return 'Geçerli bir süre girin (0 veya pozitif)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Stock Quantity
            TextFormField(
              controller: _stockQuantityController,
              decoration: const InputDecoration(
                labelText: 'Stok Miktarı *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory),
                helperText: 'Mevcut stok miktarı',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen stok miktarını girin';
                }
                final stock = int.tryParse(value.trim());
                if (stock == null || stock < 0) {
                  return 'Geçerli bir stok miktarı girin (0 veya pozitif)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Reorder Level
            TextFormField(
              controller: _reorderLevelController,
              decoration: const InputDecoration(
                labelText: 'Yeniden Sipariş Seviyesi *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning_amber),
                helperText: 'Stok bu seviyenin altına düştüğünde uyarı verilir',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen yeniden sipariş seviyesini girin';
                }
                final level = int.tryParse(value.trim());
                if (level == null || level < 0) {
                  return 'Geçerli bir seviye girin (0 veya pozitif)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Availability Switch
            Card(
              child: SwitchListTile(
                title: const Text('Ürün Mevcut'),
                subtitle: Text(_isAvailable 
                  ? 'Ürün satışa açık' 
                  : 'Ürün satışa kapalı'
                ),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                secondary: Icon(
                  _isAvailable ? Icons.check_circle : Icons.cancel,
                  color: _isAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Kaydediliyor...'),
                      ],
                    )
                  : Text(
                      widget.product == null ? 'Ürün Ekle' : 'Değişiklikleri Kaydet',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Required fields note
            const Text(
              '* zorunlu alanlar',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveProduct() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = Product(
        id: widget.product?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        categoryId: _selectedCategoryId!,
        description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty 
          ? null 
          : _imageUrlController.text.trim(),
        isAvailable: _isAvailable,
        preparationTime: int.parse(_prepTimeController.text.trim()),
        stock: int.parse(_stockQuantityController.text.trim()),
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      widget.onSave(product);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 