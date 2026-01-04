import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'debug_service.dart';

/// Service for unified keyboard management across the application
/// Handles common keyboard actions and navigation patterns
class KeyboardService {
  static KeyboardService? _instance;
  final _debug = DebugService.instance;

  KeyboardService._();

  /// Get the singleton instance
  static KeyboardService get instance {
    _instance ??= KeyboardService._();
    return _instance!;
  }

  /// Common keyboard shortcuts
  static const keySelect = LogicalKeyboardKey.enter;
  static const keyBack = LogicalKeyboardKey.escape;
  static const keyUp = LogicalKeyboardKey.arrowUp;
  static const keyDown = LogicalKeyboardKey.arrowDown;
  static const keyLeft = LogicalKeyboardKey.arrowLeft;
  static const keyRight = LogicalKeyboardKey.arrowRight;
  static const keyPageUp = LogicalKeyboardKey.pageUp;
  static const keyPageDown = LogicalKeyboardKey.pageDown;
  static const keyHome = LogicalKeyboardKey.home;
  static const keyEnd = LogicalKeyboardKey.end;
  static const keySearch = LogicalKeyboardKey.keyS;
  static const keyRefresh = LogicalKeyboardKey.keyR;
  static const keyToggleView = LogicalKeyboardKey.keyV;

  /// Handle grid navigation
  /// Returns new index or null if navigation not possible
  int? handleGridNavigation({
    required LogicalKeyboardKey key,
    required int currentIndex,
    required int itemCount,
    required int columns,
  }) {
    if (itemCount == 0) return null;

    int newIndex = currentIndex;

    if (key == keyUp) {
      newIndex = currentIndex - columns;
    } else if (key == keyDown) {
      newIndex = currentIndex + columns;
    } else if (key == keyLeft) {
      newIndex = currentIndex - 1;
    } else if (key == keyRight) {
      newIndex = currentIndex + 1;
    } else if (key == keyPageUp) {
      newIndex = currentIndex - (columns * 3); // Move 3 rows up
    } else if (key == keyPageDown) {
      newIndex = currentIndex + (columns * 3); // Move 3 rows down
    } else if (key == keyHome) {
      newIndex = 0;
    } else if (key == keyEnd) {
      newIndex = itemCount - 1;
    } else {
      return null; // Key not handled
    }

    // Clamp to valid range
    if (newIndex < 0) newIndex = 0;
    if (newIndex >= itemCount) newIndex = itemCount - 1;

    _debug.debug(
      'Grid navigation: $currentIndex -> $newIndex (key: ${key.keyLabel})',
      tag: 'KeyboardService',
    );

    return newIndex != currentIndex ? newIndex : null;
  }

  /// Handle list navigation (single column)
  /// Returns new index or null if navigation not possible
  int? handleListNavigation({
    required LogicalKeyboardKey key,
    required int currentIndex,
    required int itemCount,
  }) {
    return handleGridNavigation(
      key: key,
      currentIndex: currentIndex,
      itemCount: itemCount,
      columns: 1,
    );
  }

  /// Handle carousel navigation (horizontal only)
  /// Returns new index or null if navigation not possible
  int? handleCarouselNavigation({
    required LogicalKeyboardKey key,
    required int currentIndex,
    required int itemCount,
    bool loop = true,
  }) {
    if (itemCount == 0) return null;

    int newIndex = currentIndex;

    if (key == keyLeft) {
      newIndex = currentIndex - 1;
      if (newIndex < 0) {
        newIndex = loop ? itemCount - 1 : 0;
      }
    } else if (key == keyRight) {
      newIndex = currentIndex + 1;
      if (newIndex >= itemCount) {
        newIndex = loop ? 0 : itemCount - 1;
      }
    } else if (key == keyHome) {
      newIndex = 0;
    } else if (key == keyEnd) {
      newIndex = itemCount - 1;
    } else {
      return null; // Key not handled
    }

    _debug.debug(
      'Carousel navigation: $currentIndex -> $newIndex (key: ${key.keyLabel})',
      tag: 'KeyboardService',
    );

    return newIndex != currentIndex ? newIndex : null;
  }

  /// Check if key is a navigation key
  bool isNavigationKey(LogicalKeyboardKey key) {
    return key == keyUp ||
        key == keyDown ||
        key == keyLeft ||
        key == keyRight ||
        key == keyPageUp ||
        key == keyPageDown ||
        key == keyHome ||
        key == keyEnd;
  }

  /// Check if key is a selection key
  bool isSelectKey(LogicalKeyboardKey key) {
    return key == keySelect || key == LogicalKeyboardKey.space;
  }

  /// Check if key is a back key
  bool isBackKey(LogicalKeyboardKey key) {
    return key == keyBack || key == LogicalKeyboardKey.backspace;
  }

  /// Create a keyboard listener widget
  Widget createKeyboardListener({
    required Widget child,
    required FocusNode focusNode,
    required KeyEventResult Function(KeyEvent event) onKeyEvent,
    bool autofocus = true,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          return onKeyEvent(event);
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  /// Log keyboard event for debugging
  void logKeyEvent(KeyEvent event, String context) {
    if (event is KeyDownEvent) {
      _debug.debug(
        'Key pressed in $context: ${event.logicalKey.keyLabel}',
        tag: 'KeyboardService',
      );
    }
  }
}
