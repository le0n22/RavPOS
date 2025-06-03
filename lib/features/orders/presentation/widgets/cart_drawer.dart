import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_item.dart';

class CartDrawer extends ConsumerWidget {
  final String? tableId;
  final String? orderId;
  final VoidCallback? onCheckout;
  
  const CartDrawer({
    super.key,
    this.tableId,
    this.orderId,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.getTotal();
    
    return Drawer(
      width: 350,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (cartItems.isEmpty)
              _buildEmptyCart(context)
            else
              _buildItemsList(context, cartItems, ref),
            _buildFooter(context, total, cartItems.isNotEmpty, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String title = 'Sepet';
    if (tableId != null) {
      title = orderId != null ? 'Masa $tableId - Sipariş' : 'Masa $tableId - Yeni Sipariş';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Kapat',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Sepetiniz boş',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sepete ürün eklemek için ürünlere tıklayın',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, List<OrderItem> items, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildCartItem(context, item, ref);
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, OrderItem item, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        cartNotifier.removeItem(item.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₺${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₺${item.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              
              // Quantity controls
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      cartNotifier.updateQuantity(item.productId, item.quantity - 1);
                    },
                    tooltip: 'Azalt',
                  ),
                  Text(
                    item.quantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      cartNotifier.updateQuantity(item.productId, item.quantity + 1);
                    },
                    tooltip: 'Artır',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, double total, bool hasItems, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = ref.read(cartProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 13),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Toplam Tutar:'),
              Text(
                '₺${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (hasItems)
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Temizle'),
                    onPressed: () {
                      cartNotifier.clearCart();
                    },
                  ),
                ),
              if (hasItems) const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: orderId != null ? const Text('Siparişi Güncelle') : const Text('Sipariş Ver'),
                  onPressed: hasItems 
                    ? () => _handleCheckout(context, ref, cartItems, total) 
                    : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _handleCheckout(
    BuildContext context, 
    WidgetRef ref, 
    List<OrderItem> cartItems, 
    double total
  ) async {
    if (onCheckout != null) {
      onCheckout!();
      return;
    }
    
    // If we have an orderId, update the existing order
    if (orderId != null) {
      // Get the existing order
      final existingOrder = await ref.read(orderProvider.notifier).getOrderById(orderId!);
      if (existingOrder != null) {
        // Update the order with new items and total
        final updatedOrder = Order(
          id: existingOrder.id,
          orderNumber: existingOrder.orderNumber,
          status: existingOrder.status,
          totalAmount: total,
          createdAt: existingOrder.createdAt,
          updatedAt: DateTime.now(),
          tableNumber: tableId,
          tableId: tableId,
          items: cartItems,
          userId: null,
          discountAmount: null,
          paymentMethod: null,
          metadata: null,
        );
        
        await ref.read(orderProvider.notifier).updateOrder(updatedOrder);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sipariş güncellendi')),
        );
        
        Navigator.of(context).pop(); // Close the drawer
      }
    }
    // Otherwise create a new order
    else if (tableId != null) {
      // Navigate to payment or confirmation page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş oluşturuldu')),
      );
      
      Navigator.of(context).pop(); // Close the drawer
      context.go('/payments'); // Navigate to payment page
    }
  }
} 