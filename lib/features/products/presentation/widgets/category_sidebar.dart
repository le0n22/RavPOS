import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/category.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';

class CategorySidebar extends ConsumerWidget {
  final String? selectedCategoryId;
  final Function(String? categoryId) onCategorySelected;
  final Axis orientation;
  
  const CategorySidebar({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
    this.orientation = Axis.vertical,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    
    // Different layout based on orientation
    if (orientation == Axis.horizontal) {
      return _buildHorizontalLayout(context, categoriesAsync);
    }
    
    // Default vertical layout
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 128),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildAllProductsOption(context, ref),
          const Divider(),
          Expanded(
            child: categoriesAsync.when(
              data: (categories) => _buildCategoryList(context, categories, ref),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorView(context, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.category_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Kategoriler',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAllProductsOption(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    final productCount = productsAsync.maybeWhen(
      data: (products) => products.length,
      orElse: () => 0,
    );
    
    return Material(
      color: selectedCategoryId == null
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 77)
          : null,
      child: ListTile(
        leading: Icon(
          Icons.grid_view_rounded,
          color: selectedCategoryId == null
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        title: Text(
          'Tüm Ürünler',
          style: TextStyle(
            fontWeight: selectedCategoryId == null
                ? FontWeight.bold
                : FontWeight.normal,
            color: selectedCategoryId == null
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            productCount.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        onTap: () => onCategorySelected(null),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories, WidgetRef ref) {
    final activeCategories = categories.where((c) => c.isActive).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      
    if (activeCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            const Text('Henüz kategori bulunmuyor'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: activeCategories.length,
      itemBuilder: (context, index) {
        final category = activeCategories[index];
        return _buildCategoryTile(context, category, ref);
      },
    );
  }
  
  Widget _buildCategoryTile(BuildContext context, Category category, WidgetRef ref) {
    final isSelected = category.id == selectedCategoryId;
    final productsAsync = ref.watch(productProvider);
    
    int productCount = 0;
    productsAsync.maybeWhen(
      data: (products) {
        productCount = products.where((p) => p.categoryId == category.id).length;
      },
      orElse: () {},
    );
    
    // Safely handle icon parsing
    IconData iconData;
    try {
      iconData = category.icon != null && category.icon!.isNotEmpty
          ? IconData(int.parse(category.icon!), fontFamily: 'MaterialIcons')
          : Icons.folder_outlined;
    } catch (e) {
      // Fallback to default icon if parsing fails
      iconData = Icons.folder_outlined;
    }
    
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 77)
          : null,
      child: ListTile(
        leading: Icon(
          iconData,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            productCount.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        onTap: () => onCategorySelected(category.id),
      ),
    );
  }
  
  Widget _buildErrorView(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Kategori yüklenirken hata oluştu',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // Horizontal layout for category sidebar
  Widget _buildHorizontalLayout(BuildContext context, AsyncValue<List<Category>> categoriesAsync) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 128),
            width: 1,
          ),
        ),
      ),
      child: categoriesAsync.when(
        data: (categories) {
          final activeCategories = categories.where((c) => c.isActive).toList()
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          
          if (activeCategories.isEmpty) {
            return const Center(child: Text('Henüz kategori bulunmuyor'));
          }
          
          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // All products option
              _buildHorizontalCategoryChip(
                context,
                null,
                'Tüm Ürünler',
                Icons.grid_view_rounded,
              ),
              // Category chips
              ...activeCategories.map((category) {
                // Safely handle icon parsing
                IconData iconData;
                try {
                  iconData = category.icon != null && category.icon!.isNotEmpty
                      ? IconData(int.parse(category.icon!), fontFamily: 'MaterialIcons')
                      : Icons.folder_outlined;
                } catch (e) {
                  iconData = Icons.folder_outlined;
                }
                
                return _buildHorizontalCategoryChip(
                  context,
                  category.id,
                  category.name,
                  iconData,
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
  
  // Horizontal category chip
  Widget _buildHorizontalCategoryChip(
    BuildContext context,
    String? categoryId,
    String name,
    IconData icon,
  ) {
    final isSelected = categoryId == selectedCategoryId || (categoryId == null && selectedCategoryId == null);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onCategorySelected(categoryId),
      ),
    );
  }
} 