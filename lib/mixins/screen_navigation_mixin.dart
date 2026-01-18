import 'package:flutter/material.dart';
import 'package:forsaken/mixins/gamepad_polling_mixin.dart';

/// Mixin para gestión unificada de navegación entre screens
///
/// Proporciona métodos helper que automáticamente pausan/resumen el polling
/// de gamepad cuando se navega a otras pantallas o se muestran diálogos.
///
/// IMPORTANTE: Este mixin REQUIERE que también uses GamepadPollingMixin.
///
/// Uso básico:
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
///     // Automáticamente pausa polling, navega, y resume al volver
///     await navigateTo(SettingsScreen());
///   }
///
///   void _showDialog() async {
///     final result = await showDialogWithPause<bool>(
///       dialog: ConfirmDialog(),
///     );
///     if (result == true) {
///       // Usuario confirmó
///     }
///   }
/// }
/// ```
///
/// Beneficios:
/// - Elimina código boilerplate repetitivo
/// - Previene bugs de input overlap (pantalla de fondo procesando input)
/// - API consistente en toda la app
/// - Manejo automático de mounted check
mixin ScreenNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Navega a otra pantalla con pause/resume automático de gamepad polling
  ///
  /// Pausa el polling antes de navegar y lo reanuda automáticamente cuando
  /// la nueva pantalla se cierra.
  ///
  /// [screen]: Widget de la pantalla a mostrar
  /// [pausePolling]: Si debe pausar el polling (default: true)
  /// [fullscreenDialog]: Si debe mostrarse como diálogo fullscreen
  ///
  /// Retorna el resultado de Navigator.push (tipo genérico R).
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await navigateTo<bool>(
  ///   ConfirmationScreen(message: 'Are you sure?'),
  /// );
  /// if (result == true) {
  ///   // Usuario confirmó
  /// }
  /// ```
  Future<R?> navigateTo<R>(
    Widget screen, {
    bool pausePolling = true,
    bool fullscreenDialog = false,
  }) async {
    // Cast dinámico para verificar si tenemos GamepadPollingMixin
    final hasPolling = this is GamepadPollingMixin;

    // Pausar polling si está habilitado y disponible
    if (pausePolling && hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    // Navegar a la nueva pantalla
    final result = await Navigator.push<R>(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
        fullscreenDialog: fullscreenDialog,
      ),
    );

    // Reanudar polling si está montado
    if (mounted && pausePolling && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Muestra un diálogo con pause/resume automático de gamepad polling
  ///
  /// Pausa el polling antes de mostrar el diálogo y lo reanuda cuando
  /// el diálogo se cierra.
  ///
  /// [dialog]: Widget del diálogo a mostrar
  /// [barrierDismissible]: Si se puede cerrar tocando fuera (default: false)
  /// [useRootNavigator]: Si debe usar el navigator raíz (default: true)
  ///
  /// Retorna el resultado del diálogo (tipo genérico R).
  ///
  /// Ejemplo:
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

    // Pausar polling
    if (hasPolling) {
      (this as GamepadPollingMixin).pauseGamepadPolling();
    }

    // Mostrar diálogo
    final result = await showDialog<R>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => dialog,
    );

    // Reanudar polling
    if (mounted && hasPolling) {
      (this as GamepadPollingMixin).resumeGamepadPolling();
    }

    return result;
  }

  /// Muestra un modal bottom sheet con pause/resume automático
  ///
  /// [builder]: Builder del contenido del bottom sheet
  /// [isScrollControlled]: Si el sheet puede usar toda la altura (default: false)
  ///
  /// Retorna el resultado del bottom sheet (tipo genérico R).
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

  /// Push con reemplazo (replacement) con pause/resume automático
  ///
  /// Similar a navigateTo pero reemplaza la pantalla actual en lugar de
  /// agregar una nueva al stack.
  ///
  /// [screen]: Nueva pantalla a mostrar
  ///
  /// Retorna el resultado de Navigator.pushReplacement.
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

  /// Push y remover todas las pantallas anteriores
  ///
  /// Útil para navegación a home/login después de ciertas acciones.
  ///
  /// [screen]: Nueva pantalla a mostrar
  ///
  /// Retorna el resultado de Navigator.pushAndRemoveUntil.
  Future<R?> navigateAndRemoveAll<R>(Widget screen) async {
    final hasPolling = this is GamepadPollingMixin;

    if (hasPolling) {
      (this as GamepadPollingMixin).stopGamepadPolling();
    }

    final result = await Navigator.pushAndRemoveUntil<R>(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => false, // Remover todas las rutas
    );

    return result;
  }

  /// Pop con verificación de mounted y opcional pausa temporal
  ///
  /// [result]: Resultado opcional a retornar
  ///
  /// Ejemplo:
  /// ```dart
  /// void _cancel() {
  ///   safePop(); // Sin resultado
  /// }
  ///
  /// void _confirm() {
  ///   safePop(result: true); // Con resultado
  /// }
  /// ```
  void safePop<R>({R? result}) {
    if (!mounted) return;
    Navigator.pop(context, result);
  }

  /// Verifica si se puede hacer pop (hay pantallas en el stack)
  bool get canPop => Navigator.canPop(context);
}
