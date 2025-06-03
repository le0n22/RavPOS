import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_status.dart';
import '../../providers/order_provider.dart';
import 'order_card.dart';
import 'order_detail_modal.dart';

class OrderColumn extends ConsumerWidget {
  final OrderStatus status;
  final List<Order> orders;
  final bool isLoading;

  const OrderColumn({
    super.key,
    required this.status,
    required this.orders,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          _buildHeader(context),
          
          // Order list
          Expanded(
            child: DragTarget<Order>(
              onWillAccept: (data) {
                // Only accept if the order is not already in this status
                return data != null && data.status != status;
              },
              onAccept: (data) {
                // Update the order status when dropped
                ref.read(orderProvider.notifier).updateOrderStatus(data.id, status);
              },
              builder: (context, candidateData, rejectedData) {
                return _buildOrderList(context, ref);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build the column header with status name and count badge
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 26),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: status.color.withValues(alpha: 77),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Status name
          Text(
            status.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          
          // Count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              orders.length.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the scrollable list of order cards
  Widget _buildOrderList(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return _buildLoadingState();
    }
    
    if (orders.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Draggable<Order>(
          data: order,
          feedback: Material(
            elevation: 4.0,
            child: SizedBox(
              width: 260,
              child: OrderCard(
                order: order,
                isDragging: true,
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: order.metadata?['is_new'] == true ? Colors.green.shade50 : Colors.white,
                border: Border(
                  left: BorderSide(
                    color: order.metadata?['is_new'] == true ? Colors.green : Colors.transparent,
                    width: 6,
                  ),
                ),
              ),
              child: OrderCard(
                order: order,
                onTap: () => _showOrderDetails(context, order),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: order.metadata?['is_new'] == true ? Colors.green.shade50 : Colors.white,
              border: Border(
                left: BorderSide(
                  color: order.metadata?['is_new'] == true ? Colors.green : Colors.transparent,
                  width: 6,
                ),
              ),
            ),
            child: OrderCard(
              order: order,
              onTap: () {
                ref.read(orderProvider.notifier).markAsSeen(order.id);
                _showOrderDetails(context, order);
              },
            ),
          ),
        );
      },
    );
  }

  // Show order details when card is tapped
  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: OrderDetailModal(order: order),
          );
        },
      ),
    );
  }

  // Loading state for the column
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: status.color,
          ),
          const SizedBox(height: 12),
          Text(
            'Yükleniyor...',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Empty state for the column
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Bu durumda sipariş yok',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 