import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Common utilities for focus management in the application
///
/// Provides helpers for:
/// - Requesting focus after build
/// - Wrappers for ESC key handling
/// - Helpers for focus trapping in dialogs
class FocusUtils {
  /// Requests focus on a FocusNode after the next frame
  ///
  /// Useful when you need to focus a widget immediately after
  /// it is built, such as in initState() or didChangeDependencies().
  ///
  /// Usage:
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   FocusUtils.requestFocusAfterBuild(_myFocusNode);
  /// }
  /// ```
  static void requestFocusAfterBuild(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (node.context != null && node.canRequestFocus) {
        node.requestFocus();
      }
    });
  }

  /// Wraps a widget with a Focus listener to handle the ESC key
  ///
  /// Useful for dialogs, modals, and other UIs that need to close with ESC.
  ///
  /// [child]: Widget to wrap
  /// [onEscape]: Callback when ESC is pressed
  /// [autofocus]: Whether it should auto-focus (default: true)
  ///
  /// Usage:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return FocusUtils.withEscapeKey(
  ///     onEscape: () => Navigator.pop(context),
  ///     child: AlertDialog(...),
  ///   );
  /// }
  /// ```
  static Widget withEscapeKey({
    required Widget child,
    required VoidCallback onEscape,
    bool autofocus = true,
  }) {
    return Focus(
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          onEscape();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  /// Wraps a widget with a KeyboardListener for multiple keys
  ///
  /// More flexible than withEscapeKey when you need to handle multiple keys.
  ///
  /// [child]: Widget to wrap
  /// [onKeyEvent]: Keyboard event handler
  /// [autofocus]: Whether it should auto-focus (default: true)
  ///
  /// Usage:
  /// ```dart
  /// FocusUtils.withKeyboardHandler(
  ///   onKeyEvent: (event) {
  ///     if (event is KeyDownEvent) {
  ///       if (event.logicalKey == LogicalKeyboardKey.escape) {
  ///         Navigator.pop(context);
  ///       } else if (event.logicalKey == LogicalKeyboardKey.enter) {
  ///         _handleConfirm();
  ///       }
  ///     }
  ///   },
  ///   child: MyWidget(),
  /// )
  /// ```
  static Widget withKeyboardHandler({
    required Widget child,
    required void Function(KeyEvent event) onKeyEvent,
    bool autofocus = true,
  }) {
    return Focus(
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        onKeyEvent(event);
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  /// Creates a simple FocusNode
  ///
  /// NOTE: The caller is responsible for calling dispose() manually.
  /// Prefer creating FocusNodes as class fields and disposing in dispose().
  static FocusNode createFocusNode() {
    return FocusNode();
  }

  /// Checks if a FocusNode can receive focus
  ///
  /// Useful before calling requestFocus() to avoid errors.
  static bool canRequestFocus(FocusNode node) {
    return node.context != null && node.canRequestFocus;
  }

  /// Unfocuses the current FocusNode if it is focused
  ///
  /// Useful for closing the keyboard on mobile or removing focus from a field.
  static void unfocusIfFocused(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();
    }
  }

  /// Moves focus to the next FocusNode in the focus tree
  ///
  /// Equivalent to pressing Tab.
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Moves focus to the previous FocusNode in the focus tree
  ///
  /// Equivalent to pressing Shift+Tab.
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocuses everything in the current scope
  ///
  /// Useful for closing keyboards or clearing focus state.
  static void unfocusAll(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Requests focus on a specific widget by its BuildContext
  ///
  /// [context]: BuildContext of the widget that should receive focus
  static void requestFocusInContext(BuildContext context) {
    FocusScope.of(context).requestFocus();
  }
}
