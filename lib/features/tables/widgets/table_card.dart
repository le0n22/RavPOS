import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/features/tables/providers/table_provider.dart';
import 'package:ravpos/features/orders/providers/order_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';

class TableCard extends ConsumerWidget {
  final RestaurantTable table;

  const TableCard({super.key, required this.table});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<double>(
      future: _getCurrentOrderTotal(ref),
      builder: (context, snapshot) {
        final currentTotal = snapshot.data ?? 0.0;
        
        return SizedBox(
          height: 90, // Even more compact height for better ratio
          child: Card(
            elevation: 2,
            color: table.status.color.withValues(alpha: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: table.status.color,
                width: 1.5,
              ),
            ),
            child: InkWell(
              onTap: () => _handleTableTap(context, ref),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Table Name - Centered and Bold
                    Text(
                      table.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Category - Centered (if available)
                    if (table.category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          table.category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    // Person Count - Centered
                    Text(
                      '${table.capacity} Kişi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // Status - Centered
                    Text(
                      table.status.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: table.status.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    
                    // Total Amount - Centered (only for occupied or payment pending tables)
                    if ((table.status == TableStatus.occupied || 
                         table.status == TableStatus.paymentPending) && 
                        snapshot.hasData)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade50,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '₺${snapshot.data!.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<double> _getCurrentOrderTotal(WidgetRef ref) async {
    if (table.status != TableStatus.occupied && 
        table.status != TableStatus.paymentPending) {
      return 0.0;
    }

    try {
      final orderNotifier = ref.read(orderProvider.notifier);
      final tableOrders = await orderNotifier.getOrdersByTable(table.id);
      
      // Calculate total from active orders (not delivered or cancelled)
      double total = 0.0;
      for (final order in tableOrders) {
        if (order.status != OrderStatus.delivered && 
            order.status != OrderStatus.cancelled) {
          total += order.totalAmount;
        }
      }
      
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  void _handleTableTap(BuildContext context, WidgetRef ref) async {
    print('[DEBUG] Table tapped: id=\u001b[1m${table.id}\u001b[0m, currentOrderId=${table.currentOrderId}, status=${table.status}, tableObj=${table.toString()}');
    final orderNotifier = ref.read(orderProvider.notifier);
    final tableNotifier = ref.read(tableProvider.notifier);
    switch (table.status) {
      case TableStatus.available:
        // Sadece sipariş alma ekranına yönlendir
        if (context.mounted) {
          context.push('/tables/${table.id}/order');
        }
        break;
      case TableStatus.occupied:
      case TableStatus.paymentPending:
        if (table.currentOrderId != null && table.currentOrderId!.isNotEmpty) {
          final order = await ref.read(orderProvider.notifier).getOrderById(table.currentOrderId!);
          if (order != null) {
            context.push('/tables/${table.id}/order?orderId=${table.currentOrderId}');
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu masaya ait sipariş bilgisi bulunamadı.')),
              );
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bu masaya ait sipariş bilgisi bulunamadı.')),
            );
          }
        }
        break;
      case TableStatus.outOfService:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bu masa servis dışı durumda.')),
          );
        }
        break;
    }
  }
} 