import 'package:flutter/foundation.dart';

/// Service for managing debug logging throughout the application.
/// Allows centralized control over log output based on environment and log levels.
class DebugService {
  static DebugService? _instance;

  /// Whether debug logging is enabled
  bool _isEnabled;

  /// Current minimum log level to display
  LogLevel _minLevel;

  DebugService._({
    bool isEnabled = kDebugMode,
    LogLevel minLevel = LogLevel.debug,
  }) : _isEnabled = isEnabled,
       _minLevel = minLevel;

  /// Get the singleton instance of DebugService
  static DebugService get instance {
    _instance ??= DebugService._();
    return _instance!;
  }

  /// Initialize the DebugService with custom settings
  static void initialize({bool? isEnabled, LogLevel? minLevel}) {
    _instance = DebugService._(
      isEnabled: isEnabled ?? kDebugMode,
      minLevel: minLevel ?? LogLevel.debug,
    );
  }

  /// Enable or disable all logging
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Set the minimum log level to display
  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Check if logging is enabled for a given level
  bool _shouldLog(LogLevel level) {
    return _isEnabled && level.value >= _minLevel.value;
  }

  /// Log a debug message (lowest priority)
  void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Log an info message
  void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Log a warning message
  void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Log an error message
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, tag: tag);
    if (error != null && _shouldLog(LogLevel.error)) {
      debugPrint('  ↳ Error: $error');
    }
    if (stackTrace != null && _shouldLog(LogLevel.error)) {
      debugPrint('  ↳ Stack trace:\n$stackTrace');
    }
  }

  /// Internal logging method
  void _log(LogLevel level, String message, {String? tag}) {
    if (!_shouldLog(level)) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final levelStr = level.name.toUpperCase().padRight(7);
    final tagStr = tag != null ? '[$tag] ' : '';

    final formattedMessage = '$timestamp $levelStr $tagStr$message';

    // Use debugPrint to avoid truncation in Flutter
    debugPrint(formattedMessage);
  }

  /// Log a separator line (useful for visual grouping)
  void separator({String? label}) {
    if (!_isEnabled) return;

    if (label != null) {
      debugPrint('═══════════════ $label ═══════════════');
    } else {
      debugPrint('═════════════════════════════════════════════════════════');
    }
  }

  /// Log a section header
  void section(String title) {
    if (!_isEnabled) return;

    debugPrint('');
    debugPrint('┌─── $title ───');
  }

  /// Log a section footer
  void sectionEnd() {
    if (!_isEnabled) return;

    debugPrint('└───────────────────────');
    debugPrint('');
  }
}

/// Log levels for filtering messages
enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  none(999); // Special level to disable all logs

  const LogLevel(this.value);
  final int value;
}
