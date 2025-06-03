import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/order_item.dart';
import '../providers/table_order_provider.dart';

class DraftOrdersSection extends ConsumerWidget {
  final String tableId;
  final String? orderId;

  const DraftOrdersSection({
    Key? key,
    required this.tableId,
    this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableOrderState = ref.watch(tableOrderProvider(tableId));
    final tableOrderNotifier = ref.read(tableOrderProvider(tableId).notifier);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff0f9ff), // Light blue background
        border: Border(
          left: BorderSide(
            color: Colors.blue.shade400,
            width: 4,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Yeni Siparişler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const Spacer(),
                if (tableOrderState.draftOrders.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tableOrderState.draftItemCount} ürün',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: tableOrderState.draftOrders.isEmpty
                ? _buildEmptyState(context)
                : _buildDraftOrdersList(context, tableOrderState.draftOrders, tableOrderNotifier),
          ),
          
          // Action buttons
          if (tableOrderState.draftOrders.isNotEmpty) ...[
            const Divider(height: 1),
            _buildActionButtons(context, tableOrderState, tableOrderNotifier),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 48,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'Henüz sipariş eklenmemiş',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ürün katalogdan ürün seçerek sipariş ekleyin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDraftOrdersList(
    BuildContext context,
    List<OrderItem> draftOrders,
    TableOrderNotifier notifier,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: draftOrders.length,
      itemBuilder: (context, index) {
        final item = draftOrders[index];
        return _buildDraftOrderItem(context, item, notifier);
      },
    );
  }

  Widget _buildDraftOrderItem(
    BuildContext context,
    OrderItem item,
    TableOrderNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product info
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₺${item.unitPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      notifier.updateDraftQuantity(
                        item.productId,
                        item.quantity - 1,
                      );
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 20,
                    color: Colors.red.shade600,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      notifier.updateDraftQuantity(
                        item.productId,
                        item.quantity + 1,
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 20,
                    color: Colors.green.shade600,
                  ),
                ],
              ),
            ),
            
            // Total price
            Expanded(
              flex: 2,
              child: Text(
                '₺${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Delete button
            IconButton(
              onPressed: () {
                notifier.removeFromDraft(item.productId);
              },
              icon: const Icon(Icons.delete_outline),
              iconSize: 20,
              color: Colors.red.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TableOrderState state,
    TableOrderNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toplam:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                '₺${state.draftTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.isLoading ? null : () {
                    notifier.clearDraft();
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('TEMİZLE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    side: BorderSide(color: Colors.red.shade600),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: state.isLoading ? null : () async {
                    final success = await notifier.saveDraftOrder();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sipariş başarıyla kaydedildi'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (!success && context.mounted && state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: state.isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text('SİPARİŞİ KAYDET'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 