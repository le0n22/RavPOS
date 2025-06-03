import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../orders/providers/cart_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 128),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () => _addToCart(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image or placeholder
            AspectRatio(
              aspectRatio: 4/3,
              child: _buildProductImage(),
            ),
            
            // Product info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: _buildProductInfo(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return Image.network(
        product.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImagePlaceholder(showLoading: true);
        },
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder({bool showLoading = false}) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: showLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.restaurant,
                size: 28,
                color: Colors.grey.shade400,
              ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product name
        Flexible(
          child: Text(
            product.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Product price
        Text(
          '₺${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
        ),
        
        // Status badges (only if needed, compact)
        if (!product.isAvailable || product.preparationTime > 0) ...[
          const SizedBox(height: 2),
          Wrap(
            spacing: 2,
            runSpacing: 2,
            children: [
              if (!product.isAvailable)
                _buildBadge(
                  context,
                  'Yok',
                  Colors.red.shade100,
                  Colors.red.shade900,
                ),
              if (product.preparationTime > 0)
                _buildBadge(
                  context,
                  '${product.preparationTime}dk',
                  Colors.amber.shade100,
                  Colors.amber.shade900,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref) {
    if (!product.isAvailable) return;
    
    final cartNotifier = ref.read(cartProvider.notifier);
    cartNotifier.addItem(product, 1);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Sepete Git',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    );
  }
} 