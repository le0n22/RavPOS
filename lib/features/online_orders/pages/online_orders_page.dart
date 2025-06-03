import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/online_orders/providers/online_order_provider.dart';
import 'package:ravpos/features/online_orders/widgets/online_order_card.dart';

class OnlineOrdersPage extends ConsumerStatefulWidget {
  const OnlineOrdersPage({super.key});

  @override
  ConsumerState<OnlineOrdersPage> createState() => _OnlineOrdersPageState();
}

class _OnlineOrdersPageState extends ConsumerState<OnlineOrdersPage> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetch orders on initial load
    Future.microtask(() => ref.read(onlineOrderProvider.notifier).fetchOnlineOrders());
  }

  // Refresh orders with pull-to-refresh
  Future<void> _refreshOrders() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      await ref.read(onlineOrderProvider.notifier).fetchOnlineOrders();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onlineOrdersAsync = ref.watch(onlineOrderProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Siparişler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: onlineOrdersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return _buildEmptyState();
            }
            
            return ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.only(top: 8, bottom: 72),
              itemBuilder: (context, index) => OnlineOrderCard(order: orders[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _buildErrorState(error),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isRefreshing 
            ? null 
            : () => ref.read(onlineOrderProvider.notifier).fetchOnlineOrders(),
        icon: _isRefreshing 
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.sync),
        label: const Text('Yeni Siparişleri Kontrol Et'),
        backgroundColor: _isRefreshing 
            ? Theme.of(context).colorScheme.surfaceVariant
            : Theme.of(context).colorScheme.primary,
        foregroundColor: _isRefreshing 
            ? Theme.of(context).colorScheme.onSurfaceVariant
            : Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
  
  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 128),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz online sipariş bulunmamaktadır',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni siparişleri kontrol etmek için aşağıdaki butona tıklayabilirsiniz',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Error state widget
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _refreshOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
} 