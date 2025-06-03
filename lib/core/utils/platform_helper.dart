import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class PlatformHelper {
  static final PlatformHelper _instance = PlatformHelper._internal();

  factory PlatformHelper() => _instance;

  PlatformHelper._internal();

  static PlatformHelper get instance => _instance;

  bool get isWeb => kIsWeb;

  bool get isWindows => !kIsWeb && Platform.isWindows;
  
  bool get isLinux => !kIsWeb && Platform.isLinux;
  
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  
  bool get isDesktop => isWindows || isLinux || isMacOS;
  
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  bool get isIOS => !kIsWeb && Platform.isIOS;
  
  bool get isMobile => isAndroid || isIOS;
} 