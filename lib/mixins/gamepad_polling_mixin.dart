import 'dart:async';
import 'package:flutter/widgets.dart';
import '../services/debug_service.dart';
import '../services/gamepad_service.dart';

/// Mixin to handle gamepad polling consistently across screens
///
/// Provides automatic management of the polling timer, methods to
/// pause/resume during navigation, and automatic dispose.
///
/// Basic usage:
/// ```dart
/// class MyScreenState extends State<MyScreen>
///     with GamepadPollingMixin<MyScreen> {
///
///   @override
///   void initState() {
///     super.initState();
///     startGamepadPolling(_handleGamepadInput);
///   }
///
///   void _handleGamepadInput() {
///     final gamepad = GamepadService.instance;
///
///     // Handle back button
///     if (gamepad.isBackPressed()) {
///       Navigator.pop(context);
///     }
///
///     // Handle directional navigation
///     final direction = gamepad.getNavigationDirection();
///     if (direction != null) {
///       // Process direction (up/down/left/right)
///     }
///
///     // Handle action buttons
///     if (gamepad.isSelectPressed()) {
///       // Main action (A button)
///     }
///
///     // IMPORTANT: always call at the end of the handler
///     gamepad.updatePreviousButtonStates();
///   }
/// }
/// ```
///
/// Advanced usage with navigation:
/// ```dart
/// Future<void> _navigateToDetail() async {
///   pauseGamepadPolling();  // Pause before navigating
///
///   await Navigator.push(
///     context,
///     MaterialPageRoute(builder: (_) => DetailScreen()),
///   );
///
///   if (mounted) {
///     resumeGamepadPolling(_handleGamepadInput);  // Resume when returning
///   }
/// }
/// ```
mixin GamepadPollingMixin<T extends StatefulWidget> on State<T> {
  Timer? _gamepadPollTimer;
  Duration? _currentInterval;
  void Function()? _currentHandler;
  bool _isGamepadConnected = false;

  /// Starts gamepad polling with the provided handler
  ///
  /// The handler will execute periodically according to the specified interval.
  /// If an active timer already exists, it will be cancelled before creating a new one.
  ///
  /// [handler]: Function that executes each interval to handle input.
  ///            Must call `gamepad.updatePreviousButtonStates()` at the end.
  /// [interval]: Polling interval (default: 50ms = 20 times per second).
  ///            For most cases, 50ms is sufficient.
  void startGamepadPolling(
    void Function() handler, {
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Cancel previous timer if exists (avoids memory leaks)
    _gamepadPollTimer?.cancel();

    // Save configuration for resume
    _currentHandler = handler;
    _currentInterval = interval;

    // Start new timer
    _gamepadPollTimer = Timer.periodic(interval, (_) {
      // Check that the widget still exists before processing
      if (!mounted) return;

      // Check gamepad connection status
      final gamepad = GamepadService.instance;
      final connected = gamepad.isGamepadConnected;
      if (connected != _isGamepadConnected) {
        setState(() {
          _isGamepadConnected = connected;
        });
      }

      // Execute handler
      handler();
    });
  }

  /// Stops gamepad polling completely
  ///
  /// Useful when disposing or when input processing is no longer needed.
  void stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
    _currentHandler = null;
    _currentInterval = null;
  }

  /// Temporarily pauses polling (useful for navigation)
  ///
  /// When navigating to another screen, you should pause polling to avoid
  /// the background screen processing gamepad input.
  ///
  /// Example:
  /// ```dart
  /// void _openDialog() {
  ///   pauseGamepadPolling();
  ///
  ///   showDialog(...).then((_) {
  ///     if (mounted) resumeGamepadPolling(_handleGamepadInput);
  ///   });
  /// }
  /// ```
  void pauseGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
    // Keep handler and interval saved for resume
  }

  /// Resumes polling after a pause
  ///
  /// If no handler is provided, uses the last one configured.
  /// If no interval is provided, uses the last one configured.
  ///
  /// [handler]: Optional handler (default: uses last configured)
  /// [interval]: Optional interval (default: uses last configured)
  void resumeGamepadPolling([void Function()? handler, Duration? interval]) {
    final handlerToUse = handler ?? _currentHandler;
    final intervalToUse =
        interval ?? _currentInterval ?? const Duration(milliseconds: 50);

    if (handlerToUse == null) {
      DebugService.instance.warning(
        'Cannot resume, no handler configured',
        tag: 'GamepadPolling',
      );
      return;
    }

    startGamepadPolling(handlerToUse, interval: intervalToUse);
  }

  /// Checks if polling is currently active
  bool get isPolling =>
      _gamepadPollTimer != null && _gamepadPollTimer!.isActive;

  /// Checks if a gamepad is connected
  ///
  /// NOTE: This state updates automatically during polling.
  /// If you need to check the status before starting polling, use:
  /// `GamepadService.instance.isGamepadConnected`
  bool get isGamepadConnected => _isGamepadConnected;

  /// Manually checks the gamepad connection status
  ///
  /// Useful when you need to check the status before starting polling
  /// or for showing conditional UI.
  ///
  /// Returns true if a gamepad is connected.
  bool checkGamepadConnection() {
    final connected = GamepadService.instance.isGamepadConnected;
    if (connected != _isGamepadConnected) {
      // Only update state if changed and widget is mounted
      if (mounted) {
        setState(() {
          _isGamepadConnected = connected;
        });
      } else {
        _isGamepadConnected = connected;
      }
    }
    return connected;
  }

  @override
  void dispose() {
    stopGamepadPolling();
    super.dispose();
  }
}
