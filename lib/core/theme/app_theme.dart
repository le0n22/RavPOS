import 'package:flutter/material.dart';
import 'package:ravpos/core/theme/app_text_styles.dart';

class AppTheme {
  // Primary colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryContainer = Color(0xFFFFE0D6);
  
  // Secondary colors
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryContainer = Color(0xFFB2DFDB);
  
  // Surface colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // Feedback colors
  static const Color error = Color(0xFFF44336);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  
  // Text colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFFFFFFFF);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: secondary,
      tertiary: warning,
      onTertiary: Colors.white,
      tertiaryContainer: warning.withValues(alpha: 51),
      onTertiaryContainer: warning,
      error: error,
      onError: onError,
      errorContainer: error.withValues(alpha: 51),
      onErrorContainer: error,
      background: surface,
      onBackground: onSurface,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurface.withValues(alpha: 179),
      outline: onSurface.withValues(alpha: 77),
      outlineVariant: onSurface.withValues(alpha: 38),
      shadow: Colors.black.withValues(alpha: 26),
      scrim: Colors.black.withValues(alpha: 77),
      inverseSurface: onSurface,
      onInverseSurface: surface,
      inversePrimary: primaryContainer,
    ),
    textTheme: AppTextStyles.getTextTheme(
      const ColorScheme.light(
        onSurface: onSurface,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white.withValues(alpha: 26),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
    ),
    dividerTheme: const DividerThemeData(
      color: surfaceVariant,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: surface,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: secondary,
      tertiary: warning,
      onTertiary: Colors.white,
      tertiaryContainer: warning.withValues(alpha: 51),
      onTertiaryContainer: warning,
      error: error,
      onError: onError,
      errorContainer: error.withValues(alpha: 51),
      onErrorContainer: error,
      background: const Color(0xFF121212),
      onBackground: onSurfaceDark,
      surface: const Color(0xFF1E1E1E),
      onSurface: onSurfaceDark,
      surfaceVariant: const Color(0xFF2C2C2C),
      onSurfaceVariant: onSurfaceDark.withValues(alpha: 179),
      outline: onSurfaceDark.withValues(alpha: 77),
      outlineVariant: onSurfaceDark.withValues(alpha: 38),
      shadow: Colors.black.withValues(alpha: 77),
      scrim: Colors.black.withValues(alpha: 128),
      inverseSurface: onSurfaceDark,
      onInverseSurface: const Color(0xFF121212),
      inversePrimary: primaryContainer,
    ),
    textTheme: AppTextStyles.getTextTheme(
      const ColorScheme.dark(
        onSurface: onSurfaceDark,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: onSurfaceDark,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF2C2C2C),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 4,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 26),
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    ),
  );
  
  // Helper method to get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  // Helper methods to access theme colors
  static Color getSuccessColor(BuildContext context) {
    return success;
  }
  
  static Color getWarningColor(BuildContext context) {
    return warning;
  }
  
  static Color getErrorColor(BuildContext context) {
    return error;
  }
} 