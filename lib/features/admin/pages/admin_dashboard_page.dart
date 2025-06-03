import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Admin Dashboard',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'RavPOS Yönetim Paneline Hoş Geldiniz',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Cards
            _buildStatsGrid(context),
            
            const SizedBox(height: 32),
            
            // Charts Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildSalesChart(context),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildCategoryChart(context),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Bottom Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildRecentActivities(context),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _buildQuickActions(context),
                      const SizedBox(height: 20),
                      _buildLowStockAlerts(context),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 20,
      childAspectRatio: 2.5,
      children: [
        _buildStatCard(
          context,
          'Toplam Ürün',
          '24',
          Icons.inventory_2,
          Colors.blue,
          () => context.go('/admin/products'),
        ),
        _buildStatCard(
          context,
          'Kategoriler',
          '5',
          Icons.category,
          Colors.purple,
          () => context.go('/admin/categories'),
        ),
        _buildStatCard(
          context,
          'Kullanıcılar',
          '12',
          Icons.people,
          Colors.green,
          () => context.go('/admin/users'),
        ),
        _buildStatCard(
          context,
          'Düşük Stok',
          '3',
          Icons.warning,
          Colors.orange,
          () => _showLowStockDialog(context),
        ),
        _buildStatCard(
          context,
          'Ayarlar',
          '',
          Icons.settings,
          Colors.teal,
          () => context.go('/admin/settings'),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük Satış Trendi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Son 7 günün satış performansı',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => context.go('/admin/reports/sales'),
                  icon: const Icon(Icons.fullscreen),
                  tooltip: 'Detaylı Görünüm',
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 500,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 51),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 51),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(fontSize: 12);
                          switch (value.toInt()) {
                            case 0: return const Text('Pzt', style: style);
                            case 1: return const Text('Sal', style: style);
                            case 2: return const Text('Çar', style: style);
                            case 3: return const Text('Per', style: style);
                            case 4: return const Text('Cum', style: style);
                            case 5: return const Text('Cmt', style: style);
                            case 6: return const Text('Paz', style: style);
                          }
                          return const Text('', style: style);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 500,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${value.toInt()}₺',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 50,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 51),
                    ),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 3000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1500),
                        FlSpot(1, 1800),
                        FlSpot(2, 1200),
                        FlSpot(3, 2100),
                        FlSpot(4, 2400),
                        FlSpot(5, 1900),
                        FlSpot(6, 2200),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 77),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 51),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withValues(alpha: 13),
                            Theme.of(context).colorScheme.primary.withValues(alpha: 51),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori Performansı',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kategorilere göre satış dağılımı',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: 40,
                            title: '40%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: 30,
                            title: '30%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: 20,
                            title: '20%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.purple,
                            value: 10,
                            title: '10%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('Ana Yemekler', Colors.blue),
                      _buildLegendItem('İçecekler', Colors.orange),
                      _buildLegendItem('Tatlılar', Colors.green),
                      _buildLegendItem('Aperatifler', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Son Aktiviteler',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Tümünü Gör'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              context,
              'Yeni ürün eklendi',
              'Margherita Pizza kategoriye eklendi',
              Icons.add_circle,
              Colors.green,
              '2 saat önce',
            ),
            _buildActivityItem(
              context,
              'Stok güncellendi',
              'Coca Cola stok miktarı güncellendi',
              Icons.inventory,
              Colors.blue,
              '4 saat önce',
            ),
            _buildActivityItem(
              context,
              'Yeni kullanıcı',
              'Ahmet Yılmaz kasiyer olarak eklendi',
              Icons.person_add,
              Colors.purple,
              '6 saat önce',
            ),
            _buildActivityItem(
              context,
              'Düşük stok uyarısı',
              'Pepsi stok seviyesi kritik',
              Icons.warning,
              Colors.orange,
              '8 saat önce',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hızlı İşlemler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickActionButton(
              context,
              'Yeni Ürün Ekle',
              Icons.add_box,
              Colors.blue,
              () => context.go('/admin/products'),
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              context,
              'Kategori Yönet',
              Icons.category,
              Colors.purple,
              () => context.go('/admin/categories'),
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              context,
              'Rapor Oluştur',
              Icons.analytics,
              Colors.green,
              () => context.go('/admin/reports/sales'),
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              context,
              'Kullanıcı Ekle',
              Icons.person_add,
              Colors.orange,
              () => context.go('/admin/users'),
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              context,
              'Ayarlar',
              Icons.settings,
              Colors.teal,
              () => context.go('/admin/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(title),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildLowStockAlerts(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Düşük Stok Uyarıları',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStockAlertItem('Coca Cola', 'Stok: 3'),
            _buildStockAlertItem('Hamburger', 'Stok: 5'),
            _buildStockAlertItem('Pizza Malzemesi', 'Stok: 2'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _showLowStockDialog(context),
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockAlertItem(String name, String stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(name),
          ),
          Text(
            stock,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLowStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Düşük Stok Uyarısı'),
        content: const SizedBox(
          width: 400,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Coca Cola'),
                  subtitle: Text('Mevcut: 3, Minimum: 10'),
                  trailing: Icon(Icons.warning, color: Colors.orange),
                ),
                ListTile(
                  title: Text('Hamburger'),
                  subtitle: Text('Mevcut: 5, Minimum: 15'),
                  trailing: Icon(Icons.warning, color: Colors.orange),
                ),
                ListTile(
                  title: Text('Pizza Malzemesi'),
                  subtitle: Text('Mevcut: 2, Minimum: 20'),
                  trailing: Icon(Icons.warning, color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/admin/products');
            },
            child: const Text('Ürünleri Yönet'),
          ),
        ],
      ),
    );
  }
} 