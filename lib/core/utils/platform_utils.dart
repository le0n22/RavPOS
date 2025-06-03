import 'package:flutter/widgets.dart';
import 'platform_helper.dart';

/// @deprecated Use PlatformHelper.instance instead
class PlatformUtils {
  static bool get isWeb => PlatformHelper.instance.isWeb;
  static bool get isDesktop => PlatformHelper.instance.isDesktop;
  static bool get isMobile => PlatformHelper.instance.isMobile;
  
  static bool get isWindows => PlatformHelper.instance.isWindows;
  static bool get isLinux => PlatformHelper.instance.isLinux;
  static bool get isMacOS => PlatformHelper.instance.isMacOS;
  static bool get isAndroid => PlatformHelper.instance.isAndroid;
  static bool get isIOS => PlatformHelper.instance.isIOS;
  
  static bool get isDesktopWeb => isWeb && !isMobileWeb;
  static bool get isMobileWeb {
    if (!isWeb) return false;
    // Simple detection based on window size for mobile browser
    final windowWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return windowWidth < 600;
  }
} 