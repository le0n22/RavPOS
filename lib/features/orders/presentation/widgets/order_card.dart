import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_status.dart';
import '../../providers/order_provider.dart';
import 'package:ravpos/features/tables/providers/table_provider.dart';
import 'package:intl/intl.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  final Function()? onTap;
  final bool isDragging;

  const OrderCard({
    Key? key,
    required this.order,
    this.onTap,
    this.isDragging = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch table information to display table name
    final tableAsync = order.tableId != null
        ? ref.watch(tableByIdProvider(order.tableId!))
        : const AsyncValue.data(null);
    // Calculate time elapsed since creation
    final Duration timeElapsed = DateTime.now().difference(order.createdAt);
    final String timeElapsedText = _formatTimeElapsed(timeElapsed);
    
    // Determine urgency color based on elapsed time
    final Color timeColor = _getTimeColor(timeElapsed);

    // Get items summary
    final String itemsSummary = _getItemsSummary(order);

    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      elevation: isDragging ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: order.status.color,
          width: isDragging ? 3 : 2,
        ),
      ),
      child: InkWell(
        onTap: isDragging ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section: Order number, table badge, time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order number
                  Text(
                    '#${order.orderNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  
                  // Table name badge
                  if (order.tableId != null)
                    tableAsync.when(
                      data: (table) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          table?.name ?? order.tableNumber ?? '',
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      loading: () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.tableNumber ?? '',
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  else if (order.tableNumber != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.tableNumber!,
                        style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              
              // Items summary
              Text(
                itemsSummary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Bottom section: Total amount, time elapsed, and action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total amount
                  Text(
                    NumberFormat.currency(locale: 'tr_TR', symbol: '₺')
                        .format(order.totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  // Time elapsed
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: timeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeElapsedText,
                        style: TextStyle(
                          fontSize: 12,
                          color: timeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Status change buttons
              if (!isDragging) _buildStatusChangeButtons(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  // Format time elapsed in a human-readable format
  String _formatTimeElapsed(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} dk';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '$hours sa ${minutes > 0 ? '$minutes dk' : ''}';
    }
  }

  // Determine color based on elapsed time
  Color _getTimeColor(Duration duration) {
    if (duration.inMinutes < 15) {
      return Colors.green;
    } else if (duration.inMinutes < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Get a summary of order items
  String _getItemsSummary(Order order) {
    final buffer = StringBuffer();
    final itemCount = order.items.length;
    
    for (var i = 0; i < (itemCount > 2 ? 2 : itemCount); i++) {
      final item = order.items[i];
      buffer.write('${item.quantity}x ${item.productName}');
      if (i < (itemCount > 2 ? 1 : itemCount - 1)) {
        buffer.write(', ');
      }
    }
    
    if (itemCount > 2) {
      buffer.write(' +${itemCount - 2} diğer');
    }
    
    return buffer.toString();
  }

  // Build status change buttons based on current status
  Widget _buildStatusChangeButtons(BuildContext context, WidgetRef ref) {
    // Show no buttons for delivered status
    if (order.status == OrderStatus.delivered) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Different buttons based on status
        if (order.status == OrderStatus.pending)
          _buildStatusButton(
            context, 
            'Başla',
            Icons.play_arrow,
            Colors.blue,
            () => _updateStatus(ref, OrderStatus.preparing),
          ),
        if (order.status == OrderStatus.preparing)
          _buildStatusButton(
            context, 
            'Hazır',
            Icons.check_circle_outline,
            Colors.green,
            () => _updateStatus(ref, OrderStatus.ready),
          ),
        if (order.status == OrderStatus.ready)
          _buildStatusButton(
            context, 
            'Teslim Et',
            Icons.delivery_dining,
            Colors.purple,
            () => _updateStatus(ref, OrderStatus.delivered),
          ),
      ],
    );
  }

  // Helper method to build a status change button
  Widget _buildStatusButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // Update order status
  void _updateStatus(WidgetRef ref, OrderStatus newStatus) {
    ref.read(orderProvider.notifier).updateOrderStatus(order.id, newStatus);
  }
} 