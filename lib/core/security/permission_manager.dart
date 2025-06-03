import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/shared/models/user_role.dart';
import 'package:ravpos/features/auth/providers/auth_provider.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';

enum Permission {
  // Dashboard permissions
  viewDashboard,
  viewReports,
  
  // Product management permissions
  viewProducts,
  createProduct,
  editProduct,
  deleteProduct,
  importProducts,
  
  // Category management permissions
  viewCategories,
  createCategory,
  editCategory,
  deleteCategory,
  
  // User management permissions
  viewUsers,
  createUser,
  editUser,
  deleteUser,
  resetPassword,
  
  // Order management permissions
  viewOrders,
  createOrder,
  editOrder,
  deleteOrder,
  processPayment,
  
  // Table management permissions
  viewTables,
  manageTables,
  
  // System management permissions
  viewSystemSettings,
  editSystemSettings,
  viewDatabase,
  manageDatabase,
  
  // Report permissions
  viewSalesReports,
  viewInventoryReports,
  viewUserReports,
  exportReports,
}

class PermissionManager {
  static const Map<UserRole, Set<Permission>> _rolePermissions = {
    UserRole.admin: {
      // Admins have all permissions
      Permission.viewDashboard,
      Permission.viewReports,
      Permission.viewProducts,
      Permission.createProduct,
      Permission.editProduct,
      Permission.deleteProduct,
      Permission.importProducts,
      Permission.viewCategories,
      Permission.createCategory,
      Permission.editCategory,
      Permission.deleteCategory,
      Permission.viewUsers,
      Permission.createUser,
      Permission.editUser,
      Permission.deleteUser,
      Permission.resetPassword,
      Permission.viewOrders,
      Permission.createOrder,
      Permission.editOrder,
      Permission.deleteOrder,
      Permission.processPayment,
      Permission.viewTables,
      Permission.manageTables,
      Permission.viewSystemSettings,
      Permission.editSystemSettings,
      Permission.viewDatabase,
      Permission.manageDatabase,
      Permission.viewSalesReports,
      Permission.viewInventoryReports,
      Permission.viewUserReports,
      Permission.exportReports,
    },
    UserRole.cashier: {
      // Cashiers have limited permissions
      Permission.viewDashboard,
      Permission.viewProducts,
      Permission.viewCategories,
      Permission.viewOrders,
      Permission.createOrder,
      Permission.editOrder,
      Permission.processPayment,
      Permission.viewTables,
      Permission.viewSalesReports,
    },
    UserRole.waiter: {
      // Waiters have basic permissions
      Permission.viewDashboard,
      Permission.viewProducts,
      Permission.viewCategories,
      Permission.viewOrders,
      Permission.createOrder,
      Permission.editOrder,
      Permission.viewTables,
      Permission.manageTables,
    },
  };

  static bool hasPermission(UserRole role, Permission permission) {
    final permissions = _rolePermissions[role];
    return permissions?.contains(permission) ?? false;
  }

  static Set<Permission> getPermissions(UserRole role) {
    return _rolePermissions[role] ?? {};
  }

  static bool canAccessManagement(UserRole role) {
    return role == UserRole.admin;
  }
  
  static bool canManageUsers(UserRole role) {
    return hasPermission(role, Permission.viewUsers);
  }
  
  static bool canManageProducts(UserRole role) {
    return hasPermission(role, Permission.createProduct) || 
           hasPermission(role, Permission.editProduct) || 
           hasPermission(role, Permission.deleteProduct);
  }
  
  static bool canManageCategories(UserRole role) {
    return hasPermission(role, Permission.createCategory) || 
           hasPermission(role, Permission.editCategory) || 
           hasPermission(role, Permission.deleteCategory);
  }
  
  static bool canViewReports(UserRole role) {
    return hasPermission(role, Permission.viewSalesReports) ||
           hasPermission(role, Permission.viewInventoryReports) ||
           hasPermission(role, Permission.viewUserReports);
  }
}

// Convenience providers for common permission checks
final canManageUsersProvider = Provider<bool>((ref) {
  final authState = ref.watch(currentUserAsyncProvider);
  final user = authState.valueOrNull;
  return user != null && PermissionManager.canManageUsers(user.role);
});

final canManageProductsProvider = Provider<bool>((ref) {
  final authState = ref.watch(currentUserAsyncProvider);
  final user = authState.valueOrNull;
  return user != null && PermissionManager.canManageProducts(user.role);
});

final canManageCategoriesProvider = Provider<bool>((ref) {
  final authState = ref.watch(currentUserAsyncProvider);
  final user = authState.valueOrNull;
  return user != null && PermissionManager.canManageCategories(user.role);
});

final canAccessManagementProvider = Provider<bool>((ref) {
  final authState = ref.watch(currentUserAsyncProvider);
  final user = authState.valueOrNull;
  return user != null && PermissionManager.canAccessManagement(user.role);
}); 