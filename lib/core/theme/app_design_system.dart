import 'package:flutter/material.dart';
import 'package:ravpos/core/theme/app_spacing.dart';
import 'package:ravpos/core/theme/app_text_styles.dart';
import 'package:ravpos/core/theme/app_theme.dart';

/// The central class that brings together all aspects of the RavPOS design system
class AppDesignSystem {
  // Theme
  static ThemeData getLightTheme() => AppTheme.lightTheme;
  static ThemeData getDarkTheme() => AppTheme.darkTheme;
  static ThemeData getThemeByBrightness(Brightness brightness) => 
      AppTheme.getTheme(brightness);
  
  // Colors
  static Color getPrimaryColor() => AppTheme.primary;
  static Color getSecondaryColor() => AppTheme.secondary;
  static Color getSurfaceColor() => AppTheme.surface;
  static Color getErrorColor(BuildContext context) => AppTheme.getErrorColor(context);
  static Color getSuccessColor(BuildContext context) => AppTheme.getSuccessColor(context);
  static Color getWarningColor(BuildContext context) => AppTheme.getWarningColor(context);
  
  // Typography
  static TextStyle getDisplayLargeStyle() => AppTextStyles.displayLarge;
  static TextStyle getHeadlineLargeStyle() => AppTextStyles.headlineLarge;
  static TextStyle getHeadlineMediumStyle() => AppTextStyles.headlineMedium;
  static TextStyle getTitleLargeStyle() => AppTextStyles.titleLarge;
  static TextStyle getBodyLargeStyle() => AppTextStyles.bodyLarge;
  static TextStyle getBodyMediumStyle() => AppTextStyles.bodyMedium;
  static TextStyle getLabelLargeStyle() => AppTextStyles.labelLarge;
  static TextStyle getPriceStyle() => AppTextStyles.priceLarge;
  
  // Spacing
  static double getSpacingXS() => AppSpacing.xs;
  static double getSpacingS() => AppSpacing.s;
  static double getSpacingM() => AppSpacing.m;
  static double getSpacingL() => AppSpacing.l;
  static double getSpacingXL() => AppSpacing.xl;
  
  // Radius values for consistent rounding
  static final BorderRadius radiusSmall = BorderRadius.circular(4);
  static final BorderRadius radiusMedium = BorderRadius.circular(8);
  static final BorderRadius radiusLarge = BorderRadius.circular(16);
  static final BorderRadius radiusXLarge = BorderRadius.circular(24);
  
  // Elevation values
  static const List<double> elevations = [0, 1, 2, 3, 4, 6, 8, 12, 16, 24];
  
  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  
  // Helper method to get themed BoxDecoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.cardTheme.color,
      borderRadius: radiusMedium,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
} 