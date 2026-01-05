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
  static const keyHelp = LogicalKeyboardKey.question; // ? key (shift + slash)

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
    } else if (key == keyPageUp) {
      newIndex = currentIndex + 10;
      if (newIndex >= itemCount) {
        newIndex = loop ? 0 : itemCount - 10;
      }
    } else if (key == keyPageDown) {
      newIndex = currentIndex - 10;
      if (newIndex < 0) {
        newIndex = loop ? itemCount - 10 : 0;
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

  /// Check if key is a help key (? character, works with any keyboard layout)
  bool isHelpKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Use the character property to detect '?' regardless of keyboard layout
    // This works for QWERTY (Shift+/), QWERTZ (Shift+ß), Spanish (Shift+-), etc.
    final character = event.character;

    _debug.debug(
      'Checking help key: character="$character"',
      tag: 'KeyboardService',
    );

    return character == '?';
  }

  /// Check if event is an alphabetical jump (Shift + Letter)
  bool isAlphabeticalJump(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Check if shift is pressed using both methods for reliability
    final hardwareShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final logicalShiftPressed = HardwareKeyboard.instance.logicalKeysPressed
        .any(
          (key) =>
              key == LogicalKeyboardKey.shiftLeft ||
              key == LogicalKeyboardKey.shiftRight,
        );

    final isShiftPressed = hardwareShiftPressed || logicalShiftPressed;

    final key = event.logicalKey;

    _debug.debug(
      'Checking alphabetical jump: shift=$isShiftPressed, key=${key.keyLabel}, keyId=${key.keyId}',
      tag: 'KeyboardService',
    );

    // Check if it's a letter key (keyA to keyZ)
    final isLetterKey =
        (key.keyId >= LogicalKeyboardKey.keyA.keyId &&
        key.keyId <= LogicalKeyboardKey.keyZ.keyId);

    return isShiftPressed && isLetterKey;
  }

  /// Get the letter from an alphabetical jump event
  String? getAlphabeticalJumpLetter(KeyEvent event) {
    if (!isAlphabeticalJump(event)) return null;

    // Convert keyId to letter (keyA = 0x00000000061, so subtract keyA's id and add 'A')
    final key = event.logicalKey;
    final letterIndex = key.keyId - LogicalKeyboardKey.keyA.keyId;
    if (letterIndex >= 0 && letterIndex < 26) {
      return String.fromCharCode('A'.codeUnitAt(0) + letterIndex);
    }

    return null;
  }

  /// Find item index by letter (or next available letter in alphabet)
  /// Returns null if no match found
  int? findIndexByLetter<T>({
    required String letter,
    required List<T> items,
    required String Function(T item) getDisplayName,
  }) {
    if (items.isEmpty) return null;

    final upperLetter = letter.toUpperCase();

    // First try to find exact match
    final exactIndex = items.indexWhere(
      (item) => getDisplayName(item).toUpperCase().startsWith(upperLetter),
    );

    if (exactIndex != -1) {
      _debug.debug(
        'Found item starting with "$upperLetter" at index $exactIndex',
        tag: 'KeyboardService',
      );
      return exactIndex;
    }

    // If no exact match, find the next letter that exists
    for (
      int charCode = upperLetter.codeUnitAt(0) + 1;
      charCode <= 'Z'.codeUnitAt(0);
      charCode++
    ) {
      final nextLetter = String.fromCharCode(charCode);
      final nextIndex = items.indexWhere(
        (item) => getDisplayName(item).toUpperCase().startsWith(nextLetter),
      );

      if (nextIndex != -1) {
        _debug.debug(
          'No item with "$upperLetter", jumping to "$nextLetter" at index $nextIndex',
          tag: 'KeyboardService',
        );
        return nextIndex;
      }
    }

    // If nothing found after this letter, return null (no change)
    _debug.debug(
      'No items found starting with or after "$upperLetter"',
      tag: 'KeyboardService',
    );
    return null;
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
