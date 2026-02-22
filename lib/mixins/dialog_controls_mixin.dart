import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/gamepad_service.dart';

/// Button layout in dialogs
enum ButtonLayout {
  /// Buttons in a horizontal row (default)
  horizontal,

  /// Buttons in a vertical column
  vertical,
}

/// Mixin for dialogs with standard keyboard and gamepad controls
///
/// Provides integrated handling for:
/// - ESC key to cancel/close
/// - B button (gamepad) to cancel/close
/// - Automatic gamepad polling
/// - Helper to wrap with KeyboardListener
/// - Button navigation with D-pad/arrows
///
/// Basic usage (without button navigation):
/// ```dart
/// class MyDialogState extends State<MyDialog>
///     with DialogControlsMixin<MyDialog> {
///
///   @override
///   void initState() {
///     super.initState();
///     startDialogControls(onCancel: () => Navigator.pop(context));
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return wrapWithKeyboardHandler(
///       onEscape: () => Navigator.pop(context),
///       child: AlertDialog(
///         title: Text('My Dialog'),
///         actions: [
///           TextButton(
///             onPressed: () => Navigator.pop(context),
///             child: Text('OK'),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// Advanced usage (with button navigation):
/// ```dart
/// class MyDialogState extends State<MyDialog>
///     with DialogControlsMixin<MyDialog> {
///
///   @override
///   void initState() {
///     super.initState();
///     startDialogControlsWithNavigation(
///       onCancel: () => Navigator.pop(context, false),
///       buttonCount: 3,
///       defaultIndex: 2, // Play button by default
///       onButtonSelected: (index) {
///         setState(() {}); // Rebuild to update UI
///       },
///       onConfirm: () {
///         // Execute action of selected button
///         _buttons[selectedButtonIndex].onPressed();
///       },
///       layout: ButtonLayout.horizontal,
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return wrapWithKeyboardHandler(
///       onEscape: () => Navigator.pop(context, false),
///       child: Dialog(
///         child: Column(
///           children: [
///             // ... content ...
///             // Buttons with visual feedback for selection
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
mixin DialogControlsMixin<T extends StatefulWidget> on State<T> {
  Timer? _dialogGamepadTimer;
  FocusNode? _dialogFocusNode;

  // Button navigation state
  int _selectedButtonIndex = 0;
  int _buttonCount = 0;
  ButtonLayout _buttonLayout = ButtonLayout.horizontal;
  void Function(int selectedIndex)? _onButtonSelected;
  void Function()? _onConfirm;

  /// Gets the index of the currently selected button
  int get selectedButtonIndex => _selectedButtonIndex;

  /// Gets the total number of buttons
  int get buttonCount => _buttonCount;

  /// Gets the current button layout
  ButtonLayout get buttonLayout => _buttonLayout;

  /// Starts dialog controls (without button navigation)
  ///
  /// Configures a gamepad polling timer that automatically
  /// handles the B button as cancel/close.
  ///
  /// [onCancel]: Callback when B button is pressed (required).
  ///             Typically: `() => Navigator.pop(context)`
  /// [customHandler]: Additional handler for other controls (optional).
  ///                  Runs BEFORE checking B button.
  ///                  Useful for custom actions without navigation.
  /// [interval]: Polling interval (default: 50ms).
  void startDialogControls({
    required VoidCallback onCancel,
    void Function()? customHandler,
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Cancel previous timer if exists
    _dialogGamepadTimer?.cancel();

    // Start gamepad polling
    _dialogGamepadTimer = Timer.periodic(interval, (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;

      // Execute custom handler first (if exists)
      customHandler?.call();

      // B button = Cancel/Close (standard behavior)
      if (gamepad.isBackPressed()) {
        onCancel();
      }

      // IMPORTANT: update states at the end
      gamepad.updatePreviousButtonStates();
    });
  }

  /// Starts dialog controls WITH button navigation
  ///
  /// In addition to ESC/B button to close, enables:
  /// - D-pad/arrows to navigate between buttons
  /// - A button to confirm selected button
  /// - Tab/Shift+Tab also work (managed by Flutter)
  ///
  /// [onCancel]: Callback when B button or ESC is pressed.
  /// [buttonCount]: Total number of buttons in the dialog.
  /// [onButtonSelected]: Callback when selection changes.
  ///                     Receives the new selected index.
  ///                     Typically: `(index) => setState(() {})`.
  /// [onConfirm]: Callback when A button is pressed (optional).
  ///              If not provided, A button does nothing.
  ///              Typically: execute action of selected button.
  /// [layout]: Button layout (horizontal or vertical).
  ///           Affects how navigation works:
  ///           - Horizontal: Left/Right navigates, Up/Down does not
  ///           - Vertical: Up/Down navigates, Left/Right does not
  /// [defaultIndex]: Initial selected index (default: 0).
  /// [interval]: Polling interval (default: 50ms).
  void startDialogControlsWithNavigation({
    required VoidCallback onCancel,
    required int buttonCount,
    required void Function(int selectedIndex) onButtonSelected,
    void Function()? onConfirm,
    ButtonLayout layout = ButtonLayout.horizontal,
    int defaultIndex = 0,
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Save configuration
    _buttonCount = buttonCount;
    _buttonLayout = layout;
    _onButtonSelected = onButtonSelected;
    _onConfirm = onConfirm;
    _selectedButtonIndex = defaultIndex.clamp(0, buttonCount - 1);

    // Cancel previous timer if exists
    _dialogGamepadTimer?.cancel();

    // Start polling with navigation
    _dialogGamepadTimer = Timer.periodic(interval, (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;

      // Handle directional navigation
      _handleButtonNavigation(gamepad);

      // A button = Confirm selected button
      if (gamepad.isSelectPressed()) {
        _onConfirm?.call();
      }

      // B button = Cancel/Close
      if (gamepad.isBackPressed()) {
        onCancel();
      }

      // Update states
      gamepad.updatePreviousButtonStates();
    });
  }

  /// Handles button navigation with gamepad
  void _handleButtonNavigation(GamepadService gamepad) {
    if (_buttonCount == 0) return;

    final direction = gamepad.getNavigationDirection();
    if (direction == null) return;

    int newIndex = _selectedButtonIndex;

    // Navigation according to layout
    if (_buttonLayout == ButtonLayout.horizontal) {
      // Horizontal: only left/right
      if (direction == 'left') {
        newIndex = _selectedButtonIndex - 1;
      } else if (direction == 'right') {
        newIndex = _selectedButtonIndex + 1;
      }
    } else {
      // Vertical: only up/down
      if (direction == 'up') {
        newIndex = _selectedButtonIndex - 1;
      } else if (direction == 'down') {
        newIndex = _selectedButtonIndex + 1;
      }
    }

    // Wrap around (circular)
    if (newIndex < 0) {
      newIndex = _buttonCount - 1;
    } else if (newIndex >= _buttonCount) {
      newIndex = 0;
    }

    // If changed, notify
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Selects the next button (programmatically)
  void selectNextButton() {
    if (_buttonCount == 0) return;
    final newIndex = (_selectedButtonIndex + 1) % _buttonCount;
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Selects the previous button (programmatically)
  void selectPreviousButton() {
    if (_buttonCount == 0) return;
    final newIndex = (_selectedButtonIndex - 1 + _buttonCount) % _buttonCount;
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Sets the selected button (programmatically)
  ///
  /// [index]: Index of the button to select (clamped to valid range)
  void setSelectedButton(int index) {
    if (_buttonCount == 0) return;
    final newIndex = index.clamp(0, _buttonCount - 1);
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Stops dialog controls
  ///
  /// Clears timer and focus node.
  /// Called automatically in dispose().
  void stopDialogControls() {
    _dialogGamepadTimer?.cancel();
    _dialogGamepadTimer = null;
    _dialogFocusNode?.dispose();
    _dialogFocusNode = null;

    // Reset navigation state
    _selectedButtonIndex = 0;
    _buttonCount = 0;
    _onButtonSelected = null;
    _onConfirm = null;
  }

  /// Wraps the dialog widget with KeyboardListener to handle keys
  ///
  /// Creates an automatic FocusNode if not exists and configures the listener
  /// for ESC and arrow keys (if navigation is active).
  ///
  /// [child]: Dialog widget (typically AlertDialog or Dialog)
  /// [onEscape]: Callback when ESC is pressed (required).
  ///             Typically: `() => Navigator.pop(context)`
  ///
  /// Returns the widget wrapped with KeyboardListener.
  Widget wrapWithKeyboardHandler({
    required Widget child,
    required VoidCallback onEscape,
  }) {
    // Create focus node if not exists (lazy initialization)
    _dialogFocusNode ??= FocusNode();

    return KeyboardListener(
      focusNode: _dialogFocusNode!,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;

        final key = event.logicalKey;

        // ESC = Cancel
        if (key == LogicalKeyboardKey.escape) {
          onEscape();
          return;
        }

        // If navigation is active, handle arrows and Enter/Space
        if (_buttonCount > 0) {
          // Enter/Space = Confirm selected button
          if (key == LogicalKeyboardKey.enter ||
              key == LogicalKeyboardKey.space) {
            _onConfirm?.call();
            return;
          }

          // Arrows = Navigate between buttons
          bool handled = false;
          if (_buttonLayout == ButtonLayout.horizontal) {
            if (key == LogicalKeyboardKey.arrowLeft) {
              selectPreviousButton();
              handled = true;
            } else if (key == LogicalKeyboardKey.arrowRight) {
              selectNextButton();
              handled = true;
            }
          } else {
            if (key == LogicalKeyboardKey.arrowUp) {
              selectPreviousButton();
              handled = true;
            } else if (key == LogicalKeyboardKey.arrowDown) {
              selectNextButton();
              handled = true;
            }
          }

          if (handled && _onButtonSelected != null) {
            _onButtonSelected!(_selectedButtonIndex);
          }
        }
      },
      child: child,
    );
  }

  /// Checks if polling is active
  bool get isDialogPollingActive =>
      _dialogGamepadTimer != null && _dialogGamepadTimer!.isActive;

  @override
  void dispose() {
    stopDialogControls();
    super.dispose();
  }
}

/// Helper to show dialogs with blur background and dark barrier
///
/// Provides the standard dialog pattern used in the app:
/// - Blur background (5px gaussian)
/// - Dark barrier (70% opacity)
/// - Configurable dismissible
///
/// Usage:
/// ```dart
/// showDialogWithBlur<bool>(
///   context: context,
///   dialog: MyCustomDialog(),
/// ).then((result) {
///   if (result == true) {
///     // User confirmed
///   }
/// });
/// ```
Future<T?> showDialogWithBlur<T>({
  required BuildContext context,
  required Widget dialog,
  bool dismissible = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: dialog,
    ),
  );
}
