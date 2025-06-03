import 'package:flutter/material.dart';

/// Standardized spacing values for consistent layout across the app
class AppSpacing {
  /// Extra small spacing - 4.0
  static const xs = 4.0;
  
  /// Small spacing - 8.0
  static const s = 8.0;
  
  /// Medium spacing - 16.0
  static const m = 16.0;
  
  /// Large spacing - 24.0
  static const l = 24.0;
  
  /// Extra large spacing - 32.0
  static const xl = 32.0;
  
  /// Double extra large spacing - 48.0
  static const xxl = 48.0;
  
  /// Triple extra large spacing - 64.0
  static const xxxl = 64.0;

  // Helper methods for padding
  
  /// All sides padding with same value
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  
  /// Horizontal padding (left and right)
  static EdgeInsets horizontal(double value) => EdgeInsets.symmetric(horizontal: value);
  
  /// Vertical padding (top and bottom)
  static EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value);
  
  /// Predefined paddings
  static final EdgeInsets paddingXS = EdgeInsets.all(xs);
  static final EdgeInsets paddingS = EdgeInsets.all(s);
  static final EdgeInsets paddingM = EdgeInsets.all(m);
  static final EdgeInsets paddingL = EdgeInsets.all(l);
  static final EdgeInsets paddingXL = EdgeInsets.all(xl);
  
  /// Horizontal paddings
  static final EdgeInsets horizontalXS = horizontal(xs);
  static final EdgeInsets horizontalS = horizontal(s);
  static final EdgeInsets horizontalM = horizontal(m);
  static final EdgeInsets horizontalL = horizontal(l);
  static final EdgeInsets horizontalXL = horizontal(xl);
  
  /// Vertical paddings
  static final EdgeInsets verticalXS = vertical(xs);
  static final EdgeInsets verticalS = vertical(s);
  static final EdgeInsets verticalM = vertical(m);
  static final EdgeInsets verticalL = vertical(l);
  static final EdgeInsets verticalXL = vertical(xl);
} 