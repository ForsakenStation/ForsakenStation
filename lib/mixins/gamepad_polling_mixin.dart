import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/gamepad_service.dart';

/// Mixin para manejar gamepad polling de forma consistente
///
/// Proporciona gestión automática del timer de polling, métodos para
/// pausar/reanudar durante navegación, y dispose automático.
///
/// Uso básico:
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
///     // Manejar botón de volver
///     if (gamepad.isBackPressed()) {
///       Navigator.pop(context);
///     }
///
///     // Manejar navegación direccional
///     final direction = gamepad.getNavigationDirection();
///     if (direction != null) {
///       // Procesar dirección (up/down/left/right)
///     }
///
///     // Manejar botones de acción
///     if (gamepad.isSelectPressed()) {
///       // Acción principal (A button)
///     }
///
///     // IMPORTANTE: siempre llamar al final del handler
///     gamepad.updatePreviousButtonStates();
///   }
/// }
/// ```
///
/// Uso avanzado con navegación:
/// ```dart
/// Future<void> _navigateToDetail() async {
///   pauseGamepadPolling();  // Pausar antes de navegar
///
///   await Navigator.push(
///     context,
///     MaterialPageRoute(builder: (_) => DetailScreen()),
///   );
///
///   if (mounted) {
///     resumeGamepadPolling(_handleGamepadInput);  // Reanudar al volver
///   }
/// }
/// ```
mixin GamepadPollingMixin<T extends StatefulWidget> on State<T> {
  Timer? _gamepadPollTimer;
  Duration? _currentInterval;
  void Function()? _currentHandler;
  bool _isGamepadConnected = false;

  /// Inicia el polling de gamepad con el handler proporcionado
  ///
  /// El handler se ejecutará periódicamente según el intervalo especificado.
  /// Si ya existe un timer activo, se cancelará antes de crear uno nuevo.
  ///
  /// [handler]: Función que se ejecuta cada intervalo para manejar input.
  ///            Debe llamar a `gamepad.updatePreviousButtonStates()` al final.
  /// [interval]: Intervalo de polling (default: 50ms = 20 veces por segundo).
  ///            Para la mayoría de casos, 50ms es suficiente.
  ///            PDF viewer usa 100ms para reducir procesamiento.
  void startGamepadPolling(
    void Function() handler, {
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Cancelar timer previo si existe (evita memory leaks)
    _gamepadPollTimer?.cancel();

    // Guardar configuración para resume
    _currentHandler = handler;
    _currentInterval = interval;

    // Iniciar nuevo timer
    _gamepadPollTimer = Timer.periodic(interval, (_) {
      // Verificar que el widget aún existe antes de procesar
      if (!mounted) return;

      // Verificar estado de conexión del gamepad
      final gamepad = GamepadService.instance;
      final connected = gamepad.isGamepadConnected;
      if (connected != _isGamepadConnected) {
        setState(() {
          _isGamepadConnected = connected;
        });
      }

      // Ejecutar handler
      handler();
    });
  }

  /// Detiene completamente el polling de gamepad
  ///
  /// Útil al hacer dispose o cuando ya no se necesita procesar input.
  void stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
    _currentHandler = null;
    _currentInterval = null;
  }

  /// Pausa temporalmente el polling (útil para navegación)
  ///
  /// Cuando navegas a otra pantalla, debes pausar el polling para evitar
  /// que la pantalla de fondo procese input del gamepad.
  ///
  /// Ejemplo:
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
    // Mantener handler e interval guardados para resume
  }

  /// Reanuda el polling después de una pausa
  ///
  /// Si no se proporciona handler, usa el último que fue configurado.
  /// Si no se proporciona interval, usa el último que fue configurado.
  ///
  /// [handler]: Handler opcional (default: usa el último configurado)
  /// [interval]: Intervalo opcional (default: usa el último configurado)
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

  /// Verifica si el polling está actualmente activo
  bool get isPolling =>
      _gamepadPollTimer != null && _gamepadPollTimer!.isActive;

  /// Verifica si hay un gamepad conectado
  ///
  /// NOTA: Este estado se actualiza automáticamente durante el polling.
  /// Si necesitas verificar el estado antes de iniciar polling, usa:
  /// `GamepadService.instance.isGamepadConnected`
  bool get isGamepadConnected => _isGamepadConnected;

  /// Verifica manualmente el estado de conexión del gamepad
  ///
  /// Útil cuando necesitas verificar el estado antes de iniciar polling
  /// o para mostrar UI condicional.
  ///
  /// Retorna true si hay un gamepad conectado.
  bool checkGamepadConnection() {
    final connected = GamepadService.instance.isGamepadConnected;
    if (connected != _isGamepadConnected) {
      // Solo actualizar state si cambió y el widget está montado
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
