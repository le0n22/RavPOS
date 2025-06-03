import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  void _refreshData() {
    // Veri yenileme işlemleri burada yapılabilir
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veriler yenileniyor...'))
    );
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for the mixin
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: () => context.go('/test-order'),
            tooltip: 'Test Sipariş',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard title and welcome message
                  const Text(
                    'Hoş Geldiniz',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bugün: ${_getCurrentDate()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Add New Order / Manage Tables Button
                  Card(
                    elevation: 2,
                    shadowColor: Colors.grey.shade200,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => context.goToTables(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.table_restaurant,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Masaları Yönet',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Masa seçerek yeni sipariş başlat veya mevcut siparişleri düzenle',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick stats cards
                  _buildQuickStatsSection(context),
                  
                  const SizedBox(height: 24),
                  
                  // Discounts navigation card
                  Card(
                    elevation: 2,
                    shadowColor: Colors.grey.shade200,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => context.go('/discounts'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.percent,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'İndirimler',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tüm kampanya ve indirimleri görüntüle ve uygula',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Recent orders section
                  _buildRecentOrdersSection(context),
                  
                  const SizedBox(height: 24),
                  
                  // Popular products section
                  _buildPopularProductsSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Quick stats cards (Revenue, Orders, Products)
  Widget _buildQuickStatsSection(BuildContext context) {
    return GridView.count(
      crossAxisCount: _getGridColumnCount(context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Günlük Gelir',
          '₺1,250.00',
          Icons.payments_outlined,
          Colors.green,
          onTap: () => context.go(AppConstants.reportsRoute),
        ),
        _buildStatCard(
          context,
          'Bekleyen Siparişler',
          '5',
          Icons.receipt_long_outlined,
          Colors.orange,
          onTap: () => context.go(AppConstants.ordersRoute),
        ),
        _buildStatCard(
          context,
          'Toplam Ürünler',
          '48',
          Icons.restaurant_menu_outlined,
          Colors.blue,
          onTap: () => context.go(AppConstants.productsRoute),
        ),
      ],
    );
  }

  // Helper to build a stat card
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.shade200,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 77),
                    size: 16,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent orders list
  Widget _buildRecentOrdersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Son Siparişler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppConstants.ordersRoute),
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shadowColor: Colors.grey.shade200,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 51),
                  child: Text('#${index + 1}'),
                ),
                title: Text(
                  'Sipariş #${1001 + index}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Masa ${index + 1} • ${index + 2} ürün'),
                trailing: Chip(
                  label: const Text('Hazırlanıyor'),
                  backgroundColor: Colors.orange.withValues(alpha: 51),
                  labelStyle: const TextStyle(color: Colors.orange),
                ),
                onTap: () => context.go(AppConstants.ordersRoute),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popular products list
  Widget _buildPopularProductsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popüler Ürünler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppConstants.productsRoute),
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shadowColor: Colors.grey.shade200,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final products = ['Izgara Köfte', 'Ayran', 'Künefe'];
              final prices = ['120.00', '15.00', '65.00'];
              final categories = ['Ana Yemekler', 'İçecekler', 'Tatlılar'];
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withValues(alpha: 51),
                  child: const Icon(Icons.restaurant_menu, color: Colors.blue),
                ),
                title: Text(
                  products[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${categories[index]} • ₺${prices[index]}'),
                trailing: Text(
                  '${(50 - index * 12)}x',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => context.go(AppConstants.productsRoute),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper to determine the number of columns based on screen width
  int _getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 3;
    } else if (width > 800) {
      return 3;
    } else if (width > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  // Helper to get a nicely formatted current date
  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
} 