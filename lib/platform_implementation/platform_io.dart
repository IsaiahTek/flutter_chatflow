import 'dart:io';

/// Platform wrapper for native platforms
class PlatformHelper {
  /// returns isIOS of native platform
  static bool get isIOS {
    return Platform.isIOS;
  }
}
