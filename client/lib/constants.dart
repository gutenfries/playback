import 'package:flutter/foundation.dart' as flutter_foundation;

/// Class that contains constants about the current environment
class Constants {
  /// Returns the current platform
  static flutter_foundation.TargetPlatform get kPlatform =>
      flutter_foundation.defaultTargetPlatform;

  /// Whether or not the current environment is web
  static bool kIsWeb = flutter_foundation.kIsWeb;

  // Whether or not the current environment is native
  static bool kIsNative = !flutter_foundation.kIsWeb;

  /// Whether or not the current environment is desktop
  static bool get kIsDesktop {
    if (flutter_foundation.kIsWeb) return false;
    return [
      flutter_foundation.TargetPlatform.windows,
      flutter_foundation.TargetPlatform.linux,
      flutter_foundation.TargetPlatform.macOS,
    ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Whether or not the current environment is mobile
  static bool get kIsMobile {
    if (flutter_foundation.kIsWeb) return false;
    return [
      flutter_foundation.TargetPlatform.android,
      flutter_foundation.TargetPlatform.iOS,
    ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Whether the current environment supports window effects
  static bool get kIsWindowEffectsSupported {
    // Suppported on Windows, Linux*, and macOS
    return !flutter_foundation.kIsWeb &&
        [
          flutter_foundation.TargetPlatform.windows,
          flutter_foundation.TargetPlatform.linux,
          flutter_foundation.TargetPlatform.macOS,
        ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Whether the current environment supports system accent colors
  static bool get kIsSystemAccentColorSupported {
    // Suppported on Windows, Android, and Web
    return flutter_foundation.kIsWeb ||
        [
          flutter_foundation.TargetPlatform.windows,
          flutter_foundation.TargetPlatform.android,
        ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Whether the current environment is Windows
  static bool get kIsWindows =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.windows;

  /// Whether the current environment is Linux
  static bool get kIsLinux =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.linux;

  /// Whether the current environment is macOS
  static bool get kIsMacOS =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.macOS;

  /// Whether the current environment is Android
  static bool get kIsAndroid =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.android;

  /// Whether the current environment is iOS
  static bool get kIsIOS =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.iOS;

  /// Whether the current environment is Native Windows
  static bool get kIsNativeWindows =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Windows
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.windows;

  /// Whether the current environment is Native Linux
  static bool get kIsNativeLinux =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Linux
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.linux;

  /// Whether the current environment is Native macOS
  static bool get kIsNativeMacOS =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on MacOS
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.macOS;

  /// Whether the current environment is Native Android
  static bool get kIsNativeAndroid =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Android
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.android;

  /// Whether the current environment is Native iOS
  static bool get kIsNativeIOS =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on IOS
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.iOS;

  /// Whether the current environment is in debug mode
  static bool kIsDebugMode = flutter_foundation.kDebugMode;

  /// Whether the current environment is in profile mode
  static bool kIsProfileMode = flutter_foundation.kProfileMode;

  /// Whether the current environment is in release mode
  static bool kIsReleaseMode = flutter_foundation.kReleaseMode;
}
