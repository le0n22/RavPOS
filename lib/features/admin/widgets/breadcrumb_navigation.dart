import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BreadcrumbNavigation extends StatelessWidget {
  final String currentRoute;

  const BreadcrumbNavigation({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = _generateBreadcrumbs(currentRoute);
    
    return Row(
      children: [
        for (int i = 0; i < breadcrumbs.length; i++) ...[
          if (i > 0) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
            ),
            const SizedBox(width: 8),
          ],
          _buildBreadcrumbItem(
            context,
            breadcrumbs[i],
            isLast: i == breadcrumbs.length - 1,
          ),
        ],
      ],
    );
  }

  List<BreadcrumbItem> _generateBreadcrumbs(String route) {
    final segments = route.split('/').where((s) => s.isNotEmpty).toList();
    final breadcrumbs = <BreadcrumbItem>[];

    // Always start with Admin
    breadcrumbs.add(const BreadcrumbItem(title: 'Admin', route: '/admin'));

    String currentPath = '/admin';
    for (int i = 0; i < segments.length; i++) {
      if (segments[i] == 'admin') continue;
      
      currentPath += '/${segments[i]}';
      final title = _getDisplayTitle(segments[i]);
      breadcrumbs.add(BreadcrumbItem(title: title, route: currentPath));
    }

    return breadcrumbs;
  }

  String _getDisplayTitle(String segment) {
    switch (segment) {
      case 'dashboard':
        return 'Dashboard';
      case 'users':
        return 'Kullanıcılar';
      case 'products':
        return 'Ürünler';
      case 'categories':
        return 'Kategoriler';
      case 'orders':
        return 'Siparişler';
      case 'tables':
        return 'Masalar';
      case 'reports':
        return 'Raporlar';
      case 'sales':
        return 'Satış';
      case 'inventory':
        return 'Stok';
      case 'settings':
        return 'Ayarlar';
      default:
        return segment.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
            .map((word) => word.isNotEmpty ? 
                '${word[0].toUpperCase()}${word.substring(1)}' : '')
            .join(' ');
    }
  }

  Widget _buildBreadcrumbItem(
    BuildContext context,
    BreadcrumbItem item,
    {required bool isLast}
  ) {
    if (isLast) {
      return Text(
        item.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class BreadcrumbItem {
  final String title;
  final String route;

  const BreadcrumbItem({
    required this.title,
    required this.route,
  });
} 