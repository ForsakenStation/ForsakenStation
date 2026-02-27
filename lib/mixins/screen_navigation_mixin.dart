import 'package:flutter/material.dart';
import 'gamepad_polling_mixin.dart';

/// Mixin for unified navigation management between screens
///
/// Provides helper methods that automatically pause/resume gamepad polling
/// when navigating to other screens or showing dialogs.
///
/// IMPORTANT: This mixin REQUIRES that you also use GamepadPollingMixin.
///
/// Basic usage:
/// ```dart
/// class MyScreenState extends State<MyScreen>
///     with GamepadPollingMixin, ScreenNavigationMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     startGamepadPolling(_handleGamepadInput);
///   }
///
///   void _openSettings() async {
///     // Automatically pauses polling, navigates, and resumes when returning
///     await navigateTo(SettingsScreen());
///   }
///
///   void _showDialog() async {
///     final result = await showDialogWithPause<bool>(
///       dialog: ConfirmDialog(),
///     );
///     if (result == true) {
///       // User confirmed
///     }
///   }
/// }
/// ```
///
/// Benefits:
/// - Eliminates repetitive boilerplate code
/// - Prevents input overlap bugs (background screen processing input)
/// - Consistent API across the app
/// - Automatic mounted check handling
mixin ScreenNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Navigates to another screen with automatic gamepad polling pause/resume
  ///
  /// Pauses polling before navigating and automatically resumes it when
  /// the new screen is closed.
  ///
  /// [screen]: Screen widget to display
  /// [pausePolling]: Whether to pause polling (default: true)
  /// [fullscreenDialog]: Whether to show as a fullscreen dialog
  ///
  /// Returns the Navigator.push result (generic type R).
  ///
  /// Example:
  /// ```dart
  /// final result = await navigateTo<bool>(
  ///   ConfirmationScreen(message: 'Are you sure?'),
  /// );
  /// if (result == true) {
  ///   // User confirmed
  /// }
  /// ```
  Future<R?> navigateTo<R>(
    Widget screen, {
    bool pausePolling = true,
    bool fullscreenDialog = false,
  }) async {
    // Dynamic cast to check if we have GamepadPollingMixin
    final hasPolling = this is GamepadPollingMixin;

    // Pause polling if enabled and available
    if (pausePolling && hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    // Navigate to the new screen
    final result = await Navigator.push<R>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
        fullscreenDialog: fullscreenDialog,
      ),
    );

    // Resume polling if mounted
    if (mounted && pausePolling && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Shows a dialog with automatic gamepad polling pause/resume
  ///
  /// Pauses polling before showing the dialog and resumes it when
  /// the dialog is closed.
  ///
  /// [dialog]: Dialog widget to display
  /// [barrierDismissible]: Whether it can be closed by tapping outside (default: false)
  /// [useRootNavigator]: Whether to use the root navigator (default: true)
  ///
  /// Returns the dialog result (generic type R).
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await showDialogWithPause<bool>(
  ///   dialog: ConfirmDialog(message: 'Delete this item?'),
  /// );
  /// if (confirmed == true) {
  ///   _deleteItem();
  /// }
  /// ```
  Future<R?> showDialogWithPause<R>({
    required Widget dialog,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
  }) async {
    final hasPolling = this is GamepadPollingMixin;

    // Pause polling
    if (hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    // Show dialog
    final result = await showDialog<R>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => dialog,
    );

    // Resume polling
    if (mounted && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Shows a modal bottom sheet with automatic pause/resume
  ///
  /// [builder]: Bottom sheet content builder
  /// [isScrollControlled]: Whether the sheet can use full height (default: false)
  ///
  /// Returns the bottom sheet result (generic type R).
  Future<R?> showBottomSheetWithPause<R>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) async {
    final hasPolling = this is GamepadPollingMixin;

    if (hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    final result = await showModalBottomSheet<R>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: builder,
    );

    if (mounted && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Push replacement with automatic pause/resume
  ///
  /// Similar to navigateTo but replaces the current screen instead of
  /// adding a new one to the stack.
  ///
  /// [screen]: New screen to display
  ///
  /// Returns the Navigator.pushReplacement result.
  Future<R?> navigateReplaceTo<R, TO>(Widget screen) async {
    final hasPolling = this is GamepadPollingMixin;

    if (hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    final result = await Navigator.pushReplacement<R, TO>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );

    if (mounted && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Push and remove all previous screens
  ///
  /// Useful for navigating to home/login after certain actions.
  ///
  /// [screen]: New screen to display
  ///
  /// Returns the Navigator.pushAndRemoveUntil result.
  Future<R?> navigateAndRemoveAll<R>(Widget screen) async {
    final hasPolling = this is GamepadPollingMixin;

    if (hasPolling) {
      (this as GamepadPollingMixin).stopGamepadPolling();
    }

    final result = await Navigator.pushAndRemoveUntil<R>(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => false, // Remove all routes
    );

    return result;
  }

  /// Pop with mounted check and optional temporary pause
  ///
  /// [result]: Optional result to return
  ///
  /// Example:
  /// ```dart
  /// void _cancel() {
  ///   safePop(); // No result
  /// }
  ///
  /// void _confirm() {
  ///   safePop(result: true); // With result
  /// }
  /// ```
  void safePop<R>({R? result}) {
    if (!mounted) return;
    Navigator.pop(context, result);
  }

  /// Checks if pop is possible (screens in stack)
  bool get canPop => Navigator.canPop(context);
}
