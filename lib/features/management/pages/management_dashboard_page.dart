import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/core/router/app_router.dart';

class ManagementDashboardPage extends StatelessWidget {
  const ManagementDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetim Paneli'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              'Ürün Yönetimi',
              Icons.restaurant_menu,
              Colors.orange,
              () => context.goToProductManagement(),
            ),
            _buildDashboardCard(
              context,
              'Kategori Yönetimi',
              Icons.category,
              Colors.purple,
              () => context.goToCategoryManagement(),
            ),
            _buildDashboardCard(
              context,
              'Kullanıcı Yönetimi',
              Icons.people,
              Colors.blue,
              () => context.goToUserManagement(),
            ),
            _buildDashboardCard(
              context,
              'Ayarlar',
              Icons.settings,
              Colors.teal,
              () => context.go('/admin/settings'),
            ),
            _buildDashboardCard(
              context,
              'Veritabanı Araçları',
              Icons.storage,
              Colors.red,
              () => context.goToDatabaseManagement(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 