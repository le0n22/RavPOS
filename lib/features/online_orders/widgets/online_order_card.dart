import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/features/online_orders/providers/online_order_provider.dart';

class OnlineOrderCard extends ConsumerWidget {
  final OnlineOrder order;
  final VoidCallback? onTap;

  const OnlineOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Card border color based on order status
    final borderColor = order.isAccepted
        ? colorScheme.primary
        : order.isRejected
            ? colorScheme.error
            : colorScheme.outline;
    
    // Format currency
    final currencyFormatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    
    // Format date
    final dateFormatter = DateFormat('HH:mm - dd.MM.yyyy');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with platform and order ID
            Row(
              children: [
                // Platform icon/badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.platform.displayName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Order ID
                Text(
                  'Sipariş #${order.onlineOrderId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Status indicator
                if (order.isAccepted)
                  _buildStatusChip(context, 'Kabul Edildi', colorScheme.primary)
                else if (order.isRejected)
                  _buildStatusChip(context, 'Reddedildi', colorScheme.error)
                else
                  _buildStatusChip(context, 'Yeni', colorScheme.tertiary),
              ],
            ),
            
            const Divider(height: 24),
            
            // Customer information
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Müşteri: ${order.customerName}', style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Text('Tel: ${order.customerPhone}', style: theme.textTheme.bodyMedium),
                      if (order.customerAddress != null) ...[
                        const SizedBox(height: 4),
                        Text('Adres: ${order.customerAddress}', 
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Order summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(order.totalAmount),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.items.length} Ürün',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormatter.format(order.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            
            if (order.customerNote != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Müşteri Notu:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.customerNote!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            
            // Order items summary (collapsible)
            ExpansionTile(
              title: const Text('Sipariş Detayı'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ListTile(
                      dense: true,
                      title: Text(item.productName),
                      subtitle: item.specialInstructions != null
                          ? Text(item.specialInstructions!)
                          : null,
                      trailing: Text(
                        '${item.quantity} x ${currencyFormatter.format(item.unitPrice)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
            
            // Action buttons
            if (!order.isAccepted && !order.isRejected) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Reject button
                  OutlinedButton.icon(
                    onPressed: () => _showRejectDialog(context, ref),
                    icon: const Icon(Icons.close),
                    label: const Text('Reddet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Accept button
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(onlineOrderProvider.notifier).acceptOnlineOrder(order.onlineOrderId);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Kabul Et'),
                  ),
                ],
              ),
            ] else if (order.isRejected && order.rejectionReason != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ret Nedeni:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.rejectionReason!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Helper to build status chips
  Widget _buildStatusChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  // Show dialog to enter rejection reason
  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Siparişi Reddet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sipariş reddetme nedeninizi giriniz:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Ret Nedeni',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                Navigator.of(context).pop();
                ref.read(onlineOrderProvider.notifier).rejectOnlineOrder(order.onlineOrderId, reason);
              }
            },
            child: const Text('Reddet'),
          ),
        ],
      ),
    );
  }
} 