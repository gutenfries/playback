import 'dart:developer' as developer;
import 'dart:io';

import 'constants.dart';

/// Utility class that contains helpful debug functions and information
class Debug {
  /// Prints out ALL available environmental information to the dart stdout.
  /// (will print in the web console if running on web)
  static void dumpEnviroment() {
    debugLog(
      ' -- Debug Enviroment Dump --\n',
      showTime: false,
      color: _ANSIColorString.blue,
    );
    debugLog(
      ' -- Platform k* Consts: --',
      showTime: false,
      color: _ANSIColorString.purple,
    );
    debugLog(
      ' - kPlatform: ${Constants.kPlatform}',
      showTime: false,
    );
    debugLog(
      ' - kIsWeb: ${_colorizeBool(Constants.kIsWeb)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNative: ${_colorizeBool(Constants.kIsNative)}',
      showTime: false,
    );
    debugLog(
      ' - kIsDesktop: ${_colorizeBool(Constants.kIsDesktop)}',
      showTime: false,
    );
    debugLog(
      ' - kIsMobile: ${_colorizeBool(Constants.kIsMobile)}',
      showTime: false,
    );
    debugLog(
      ' - kIsWindowEffectsSupported: ${_colorizeBool(Constants.kIsWindowEffectsSupported)}',
      showTime: false,
    );
    debugLog(
      ' - kIsSystemAccentColorSupported: ${_colorizeBool(Constants.kIsSystemAccentColorSupported)}',
      showTime: false,
    );
    debugLog(
      ' - kIsWindows: ${_colorizeBool(Constants.kIsWindows)}',
      showTime: false,
    );
    debugLog(
      ' - kIsLinux: ${_colorizeBool(Constants.kIsLinux)}',
      showTime: false,
    );
    debugLog(
      ' - kIsMacOS: ${_colorizeBool(Constants.kIsMacOS)}',
      showTime: false,
    );
    debugLog(
      ' - kIsAndroid: ${_colorizeBool(Constants.kIsAndroid)}',
      showTime: false,
    );
    debugLog(
      ' - kIsIOS: ${_colorizeBool(Constants.kIsIOS)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNativeWindows: ${_colorizeBool(Constants.kIsNativeWindows)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNativeLinux: ${_colorizeBool(Constants.kIsNativeLinux)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNativeMacOS: ${_colorizeBool(Constants.kIsNativeMacOS)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNativeAndroid: ${_colorizeBool(Constants.kIsNativeAndroid)}',
      showTime: false,
    );
    debugLog(
      ' - kIsNativeIOS: ${_colorizeBool(Constants.kIsNativeIOS)}',
      showTime: false,
    );
    debugLog(
      ' - kIsDebugMode: ${_colorizeBool(Constants.kIsDebugMode)}',
      showTime: false,
    );
    debugLog(
      ' - kIsProfileMode: ${_colorizeBool(Constants.kIsProfileMode)}',
      showTime: false,
    );
    debugLog(
      ' - kIsReleaseMode: ${_colorizeBool(Constants.kIsReleaseMode)}',
      showTime: false,
    );
  }

  /// Color a string
  ///
  /// - `String string` - the string to colorize
  /// - `ColorString color` - the color to use
  static String _colorize(String string, String color) {
    // return the colorized string
    return '\x1B[$color$string\x1B[0m';
  }

  /// Prints a message to the console
  /// - `String message` - the message to print
  /// - `String? color` - color to use for the message
  /// - `bool? newLine` - if true, a new line will be added after the message
  /// - `bool? showTime` - if true, the current time will be added to the message
  /// - `bool? showStackTrace` - if true, the current stack trace will be added to the message
  static void debugLog(
    String message, {
    String? color,
    bool? newLine,
    bool? showTime,
    bool? showStackTrace,
  }) {
    if (color != null) {
      // colorize the message
      message = _colorize(message, color);
      // drop `color` form the heap
      color = null;
    }

    // show time by default
    if (showTime != null && !showTime) {
      // drop `showTime` form the heap
      showTime = null;
    } else {
      // add the current time to the message
      message = '${DateTime.now()} - $message';
    }

    if (showStackTrace != null && showStackTrace) {
      // add the current stack trace to the message
      message = '$message\n${StackTrace.current}';
      // drop `showStackTrace` form the heap
      showStackTrace = null;
    }

    // add a newline by default
    if (newLine != null && !newLine) {
      newLine = null;
    } else {
      // add a new line to the message
      message = '$message\n';
    }

    // print the message
    stdout.write(message);
    // write the message to the dart developer console
    developer.log(message, name: 'Debug');
  }

  /// Colors a boolean? value for printing.
  ///
  /// `false` values are colored red, `true` values are colored green, and `null` values are colored orange.
  /// - `bool? value` - the value to colorize
  static String _colorizeBool(bool? value) {
    // colorize the value
    if (value == null) {
      // value is null
      return _colorize('null', _ANSIColorString.yellow);
    } else if (value) {
      // value is true
      return _colorize('true', _ANSIColorString.green);
    } else {
      // value is false
      return _colorize('false', _ANSIColorString.red);
    }
  }
}

/// Colors for use with `Debug.colorize`
///
/// Converts a plain text color name into a matching ANSI escape code.
class _ANSIColorString {
  /// ANSI Red
  // ignore: unused_field
  static const String red = '\x1B[31m';

  /// ANSI Green
  // ignore: unused_field
  static const String green = '\x1B[32m';

  /// ANSI Yellow
  // ignore: unused_field
  static const String yellow = '\x1B[33m';

  /// ANSI Blue
  // ignore: unused_field
  static const String blue = '\x1B[34m';

  /// ANSI Purple
  // ignore: unused_field
  static const String purple = '\x1B[35m';

  /// ANSI Cyan
  // ignore: unused_field
  static const String cyan = '\x1B[36m';

  /// ANSI White
  // ignore: unused_field
  static const String white = '\x1B[37m';

  /// ANSI Black
  // ignore: unused_field
  static const String black = '\x1B[30m';
}
