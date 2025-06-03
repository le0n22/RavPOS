import 'package:flutter/material.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';import '../../../features/orders/providers/cart_provider.dart';import '../../../features/tables/providers/table_provider.dart';import '../../../features/orders/providers/order_provider.dart';

class OrderSummaryCard extends ConsumerWidget {
  final String tableId;
  final String? orderId;

  const OrderSummaryCard({
    Key? key,
    required this.tableId,
    this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final tableAsync = ref.watch(tableByIdProvider(tableId));
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adisyon - ${tableAsync.when(
                    data: (table) => table?.name ?? 'Masa',
                    loading: () => 'Yükleniyor...',
                    error: (_, __) => 'Masa',
                  )}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (orderId != null)
                  FutureBuilder(
                    future: ref.read(orderProvider.notifier).getOrderById(orderId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(
                          snapshot.data!.orderNumber,
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      }
                      return Text(
                        'Sipariş',
                        style: Theme.of(context).textTheme.titleMedium,
                      );
                    },
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildSummaryItem(
              context, 
              'Toplam Ürün Sayısı:', 
              '${ref.read(cartProvider.notifier).getItemCount()} adet'
            ),
            const SizedBox(height: 4),
            _buildSummaryItem(
              context, 
              'Ara Toplam:', 
              '₺${ref.read(cartProvider.notifier).getTotal().toStringAsFixed(2)}'
            ),
            const SizedBox(height: 4),
            _buildSummaryItem(
              context, 
              'İndirim:', 
              '₺0.00',
              textColor: Colors.red,
            ),
            const Divider(),
            _buildSummaryItem(
              context, 
              'Toplam Tutar:', 
              '₺${ref.read(cartProvider.notifier).getTotal().toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value, {Color? textColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ],
    );
  }
} 