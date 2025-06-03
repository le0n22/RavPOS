import 'package:flutter/material.dart'; // IconData için

enum UserRole {
  admin,
  cashier,
  waiter,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin: return 'Yönetici';
      case UserRole.cashier: return 'Kasiyer';
      case UserRole.waiter: return 'Garson';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.admin: return Icons.admin_panel_settings;
      case UserRole.cashier: return Icons.point_of_sale;
      case UserRole.waiter: return Icons.room_service;
    }
  }
} 