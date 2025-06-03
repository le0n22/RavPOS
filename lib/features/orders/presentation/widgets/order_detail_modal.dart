import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_provider.dart';
import '../../providers/order_item_provider.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_status.dart';
import '../../../../shared/models/order_item.dart';

class OrderDetailModal extends ConsumerWidget {
  final Order order;

  const OrderDetailModal({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with order info and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sipariş #${order.orderNumber}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          // Order metadata
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Table info
                if (order.tableNumber != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                                        child: Text(                      order.tableNumber!,                      style: TextStyle(                        color: Colors.blueGrey.shade800,                        fontWeight: FontWeight.w500,                      ),                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.status.color.withValues(alpha: 38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status.displayName,
                    style: TextStyle(
                      color: order.status.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Creation time
                Flexible(
                  child: Text(
                    _formatDateTime(order.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          
          // Customer note if available
          if (order.customerNote != null && order.customerNote!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.note, color: Colors.amber.shade800, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerNote!,
                      style: TextStyle(
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Order items list
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Sipariş Kalemleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          
          Flexible(
            child: Consumer(
              builder: (context, ref, _) {
                final orderItemsAsync = ref.watch(orderItemProvider(order.id));
                return orderItemsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Hata: $e')),
                  data: (items) => ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty)
                                    Text(
                                      item.specialInstructions!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '₺${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (order.status == OrderStatus.pending) ...[
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                tooltip: 'Düzenle',
                                onPressed: () async {
                                  final updated = await showDialog<OrderItem>(
                                    context: context,
                                    builder: (context) {
                                      final qtyController = TextEditingController(text: item.quantity.toString());
                                      final instructionsController = TextEditingController(text: item.specialInstructions ?? '');
                                      return AlertDialog(
                                        title: const Text('Sipariş Kalemini Düzenle'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: qtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(labelText: 'Adet'),
                                            ),
                                            TextFormField(
                                              controller: instructionsController,
                                              decoration: const InputDecoration(labelText: 'Açıklama'),
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
                                              final qty = int.tryParse(qtyController.text) ?? item.quantity;
                                              final updatedItem = item.copyWith(
                                                quantity: qty,
                                                totalPrice: qty * item.unitPrice,
                                                specialInstructions: instructionsController.text,
                                              );
                                              Navigator.of(context).pop(updatedItem);
                                            },
                                            child: const Text('Kaydet'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (updated != null) {
                                    await ref.read(orderItemProvider(order.id).notifier).updateOrderItem(order.id, updated);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                tooltip: 'Sil',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Sipariş Kalemini Sil'),
                                      content: const Text('Bu kalemi silmek istediğinize emin misiniz?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('İptal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Sil'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ref.read(orderItemProvider(order.id).notifier).deleteOrderItem(order.id, item.id);
                                  }
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          
          const Divider(),
          
          // Order total
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Toplam',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '₺${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              // Edit button (only for pending orders)
              if (order.status == OrderStatus.pending)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Close modal and navigate to edit
                      Navigator.of(context).pop();
                      // TODO: Add navigation to edit order
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Düzenle'),
                  ),
                ),
              
              if (order.status == OrderStatus.pending)
                const SizedBox(width: 8),
              
              // Print receipt button
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Add print receipt functionality
                  },
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Fiş Yazdır'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Status change buttons
          if (order.status != OrderStatus.delivered)
            SizedBox(
              width: double.infinity,
              child: _buildStatusChangeButton(context, ref),
            ),
        ],
      ),
    );
  }

  // Format datetime in a readable format
  String _formatDateTime(DateTime? dateTime) {
    final today = DateTime.now();
    final difference = today.difference(dateTime ?? DateTime(0));
    
    if (difference.inDays == 0) {
      return 'Bugün ${dateTime?.hour}:${dateTime?.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Dün ${dateTime?.hour}:${dateTime?.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime?.day}/${dateTime?.month}/${dateTime?.year} ${dateTime?.hour}:${dateTime?.minute.toString().padLeft(2, '0')}';
    }
  }

  // Build status change button based on current status
  Widget _buildStatusChangeButton(BuildContext context, WidgetRef ref) {
    String label;
    IconData icon;
    Color color;
    OrderStatus newStatus;
    
    switch (order.status) {
      case OrderStatus.pending:
        label = 'Hazırlamaya Başla';
        icon = Icons.play_arrow;
        color = Colors.blue;
        newStatus = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        label = 'Hazır Olarak İşaretle';
        icon = Icons.check_circle;
        color = Colors.green;
        newStatus = OrderStatus.ready;
        break;
      case OrderStatus.ready:
        label = 'Teslim Edildi Olarak İşaretle';
        icon = Icons.delivery_dining;
        color = Colors.purple;
        newStatus = OrderStatus.delivered;
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return FilledButton.icon(
      onPressed: () async {
        try {
          await ref.read(orderProvider.notifier).updateOrderStatus(order.id, newStatus);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sipariş durumu güncellendi'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hata: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
      ),
    );
  }
} 