import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/products/providers/product_provider.dart';
import '../../../../shared/models/discount.dart';

class DiscountsPage extends ConsumerStatefulWidget {
  const DiscountsPage({super.key});

  @override
  ConsumerState<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends ConsumerState<DiscountsPage> {
  String? selectedDiscountId;
  bool isApplying = false;
  String orderId = 'demo-order-id'; // Replace with actual orderId in real usage

  @override
  Widget build(BuildContext context) {
    final discountsAsync = ref.watch(discountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discounts')),
      body: discountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (discounts) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: discounts.length,
                itemBuilder: (context, index) {
                  final discount = discounts[index];
                  return ListTile(
                    title: Text(discount.name),
                    subtitle: Text(
                      discount.type == DiscountType.percentage
                        ? '${discount.value}%'
                        : '${discount.value} ₺',
                    ),
                    trailing: discount.isActive
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),
                    selected: selectedDiscountId == discount.id,
                    onTap: () {
                      setState(() {
                        selectedDiscountId = discount.id;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: selectedDiscountId == null || isApplying
                  ? null
                  : () async {
                      setState(() { isApplying = true; });
                      await ref.read(discountProvider.notifier)
                        .applyDiscountToOrder(orderId, selectedDiscountId!);
                      setState(() { isApplying = false; });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Discount applied!')),
                      );
                    },
                child: isApplying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Apply Discount'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 