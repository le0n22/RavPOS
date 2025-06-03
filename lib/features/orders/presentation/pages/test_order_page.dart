import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/models/models.dart';
import '../../../orders/providers/order_provider.dart';

class TestOrderPage extends ConsumerWidget {
  const TestOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Sipariş Oluştur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // UUID oluştur
                final uuid = const Uuid();
                
                // Sipariş öğeleri oluştur
                final items = [
                  OrderItem(
                    id: uuid.v4(),
                    productId: uuid.v4(),
                    productName: 'Test Ürünü 1',
                    quantity: 2,
                    unitPrice: 50.0,
                    totalPrice: 100.0,
                  ),
                  OrderItem(
                    id: uuid.v4(),
                    productId: uuid.v4(),
                    productName: 'Test Ürünü 2',
                    quantity: 1,
                    unitPrice: 75.0,
                    totalPrice: 75.0,
                  ),
                ];
                
                // Sipariş oluştur
                final order = Order(
                  id: uuid.v4(),
                  orderNumber: 'TST-001',
                  tableNumber: '5',
                  tableId: '5',
                  items: items,
                  status: OrderStatus.pending,
                  totalAmount: 175.0, // 100 + 75
                  createdAt: DateTime.now(),
                  userId: null,
                  discountAmount: null,
                  paymentMethod: null,
                  metadata: null,
                );
                
                // Siparişi kaydet
                final orderId = await ref.read(orderProvider.notifier).createOrder(order);
                
                if (orderId != null && context.mounted) {
                  // Siparişi seç
                  ref.read(orderProvider.notifier).selectOrder(order);
                  
                  // Ödeme sayfasına git
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sipariş oluşturuldu, ödeme sayfasına yönlendiriliyor')),
                  );
                  
                  Future.delayed(const Duration(seconds: 1), () {
                    if (context.mounted) {
                      context.push('/payments');
                    }
                  });
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sipariş oluşturulamadı')),
                  );
                }
              },
              child: const Text('Test Sipariş Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
} 