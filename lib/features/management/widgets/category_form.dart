import 'package:flutter/material.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;
  final Function(Category category) onSave;

  const CategoryForm({
    Key? key,
    this.category,
    required this.onSave,
  }) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();
  final _displayOrderController = TextEditingController();
  
  bool _isActive = true;
  bool _isLoading = false;
  
  // Common icon options for categories
  static const List<Map<String, dynamic>> _iconOptions = [
    {'name': 'restaurant_menu', 'icon': Icons.restaurant_menu, 'label': 'Genel Yemek'},
    {'name': 'local_pizza', 'icon': Icons.local_pizza, 'label': 'Pizza'},
    {'name': 'coffee', 'icon': Icons.local_cafe, 'label': 'Kahve'},
    {'name': 'fastfood', 'icon': Icons.fastfood, 'label': 'Fast Food'},
    {'name': 'cake', 'icon': Icons.cake, 'label': 'Tatlı'},
    {'name': 'local_drink', 'icon': Icons.local_drink, 'label': 'İçecek'},
    {'name': 'lunch_dining', 'icon': Icons.lunch_dining, 'label': 'Öğle Yemeği'},
    {'name': 'dinner_dining', 'icon': Icons.dinner_dining, 'label': 'Akşam Yemeği'},
    {'name': 'breakfast_dining', 'icon': Icons.breakfast_dining, 'label': 'Kahvaltı'},
    {'name': 'icecream', 'icon': Icons.icecream, 'label': 'Dondurma'},
    {'name': 'liquor', 'icon': Icons.liquor, 'label': 'Alkol'},
    {'name': 'wine_bar', 'icon': Icons.wine_bar, 'label': 'Şarap'},
    {'name': 'emoji_food_beverage', 'icon': Icons.emoji_food_beverage, 'label': 'Yemek & İçecek'},
  ];
  
  @override
  void initState() {
    super.initState();
    
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _iconController.text = widget.category!.icon ?? '';
      _displayOrderController.text = widget.category!.displayOrder.toString();
      _isActive = widget.category!.isActive;
    } else {
      _displayOrderController.text = '0';
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              widget.category == null ? 'Yeni Kategori Ekle' : 'Kategoriyi Düzenle',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Category Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Kategori Adı *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen bir kategori adı girin';
                }
                if (value.trim().length < 2) {
                  return 'Kategori adı en az 2 karakter olmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Icon Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'İkon Seçimi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Custom icon input
                      TextFormField(
                        controller: _iconController,
                        decoration: const InputDecoration(
                          labelText: 'Özel İkon Adı',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit),
                          hintText: 'Örn: restaurant_menu, local_pizza',
                          helperText: 'Boş bırakılırsa varsayılan ikon kullanılır',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Veya aşağıdaki önerilen ikonlardan seçin:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      // Icon grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _iconOptions.length,
                        itemBuilder: (context, index) {
                          final iconOption = _iconOptions[index];
                          final isSelected = _iconController.text == iconOption['name'];
                          
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _iconController.text = iconOption['name'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 26)
                                  : Colors.grey.withValues(alpha: 51),
                                border: Border.all(
                                  color: isSelected 
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconOption['icon'],
                                    color: isSelected 
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    iconOption['label'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Display Order
            TextFormField(
              controller: _displayOrderController,
              decoration: const InputDecoration(
                labelText: 'Görüntülenme Sırası *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sort),
                helperText: 'Kategorilerin sıralanma düzeni (0 = en üstte)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen bir sıra numarası girin';
                }
                final order = int.tryParse(value.trim());
                if (order == null || order < 0) {
                  return 'Geçerli bir sayı girin (0 veya pozitif)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Active Switch
            Card(
              child: SwitchListTile(
                title: const Text('Kategori Aktif'),
                subtitle: Text(_isActive 
                  ? 'Kategori ürün listeleme sayfalarında görünür' 
                  : 'Kategori gizlenir (mevcut ürünler etkilenmez)'
                ),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                secondary: Icon(
                  _isActive ? Icons.visibility : Icons.visibility_off,
                  color: _isActive ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Preview Card
            if (_nameController.text.isNotEmpty) ...[
              const Text(
                'Önizleme:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _isActive 
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 26)
                      : Colors.grey.withValues(alpha: 51),
                    child: Icon(
                      _getIconFromName(_iconController.text),
                      color: _isActive 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    ),
                  ),
                  title: Text(
                    _nameController.text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isActive ? null : Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    'Sıra: ${_displayOrderController.text}${!_isActive ? " (Aktif Değil)" : ""}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveCategory,
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
                      widget.category == null ? 'Kategori Ekle' : 'Değişiklikleri Kaydet',
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
  
  IconData _getIconFromName(String iconName) {
    final iconOption = _iconOptions.firstWhere(
      (option) => option['name'] == iconName,
      orElse: () => {'icon': Icons.category},
    );
    return iconOption['icon'] as IconData;
  }
  
  void _saveCategory() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final category = Category(
        id: widget.category?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        icon: _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        displayOrder: int.parse(_displayOrderController.text.trim()),
        isActive: _isActive,
        createdAt: widget.category?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      widget.onSave(category);
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