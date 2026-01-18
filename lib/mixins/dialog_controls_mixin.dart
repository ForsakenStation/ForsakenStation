import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/gamepad_service.dart';

/// Layout de botones en diálogo
enum ButtonLayout {
  /// Botones en fila horizontal (default)
  horizontal,

  /// Botones en columna vertical
  vertical,
}

/// Mixin para diálogos con controles estándar de teclado y gamepad
///
/// Proporciona manejo integrado de:
/// - ESC key para cancelar/cerrar
/// - B button (gamepad) para cancelar/cerrar
/// - Gamepad polling automático
/// - Helper para wrap con KeyboardListener
/// - NUEVO: Navegación entre botones con D-pad/arrows
///
/// Uso básico (sin navegación entre botones):
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
/// Uso avanzado (con navegación entre botones):
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
///       defaultIndex: 2, // Play button por defecto
///       onButtonSelected: (index) {
///         setState(() {}); // Rebuild para actualizar UI
///       },
///       onConfirm: () {
///         // Ejecutar acción del botón seleccionado
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
///             // ... contenido ...
///             // Botones con visual feedback del seleccionado
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

  // Estado de navegación entre botones
  int _selectedButtonIndex = 0;
  int _buttonCount = 0;
  ButtonLayout _buttonLayout = ButtonLayout.horizontal;
  void Function(int selectedIndex)? _onButtonSelected;
  void Function()? _onConfirm;

  /// Obtiene el índice del botón actualmente seleccionado
  int get selectedButtonIndex => _selectedButtonIndex;

  /// Obtiene el número total de botones
  int get buttonCount => _buttonCount;

  /// Obtiene el layout actual de botones
  ButtonLayout get buttonLayout => _buttonLayout;

  /// Inicia los controles del diálogo (sin navegación entre botones)
  ///
  /// Configura un timer de polling para gamepad que automáticamente
  /// maneja el B button como cancelar/cerrar.
  ///
  /// [onCancel]: Callback cuando se presiona B button (requerido).
  ///             Típicamente: `() => Navigator.pop(context)`
  /// [customHandler]: Handler adicional para otros controles (opcional).
  ///                  Se ejecuta ANTES de verificar B button.
  ///                  Útil para acciones custom sin navegación.
  /// [interval]: Intervalo de polling (default: 50ms).
  void startDialogControls({
    required VoidCallback onCancel,
    void Function()? customHandler,
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Cancelar timer previo si existe
    _dialogGamepadTimer?.cancel();

    // Iniciar polling de gamepad
    _dialogGamepadTimer = Timer.periodic(interval, (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;

      // Ejecutar handler custom primero (si existe)
      customHandler?.call();

      // B button = Cancel/Close (comportamiento estándar)
      if (gamepad.isBackPressed()) {
        onCancel();
      }

      // IMPORTANTE: actualizar estados al final
      gamepad.updatePreviousButtonStates();
    });
  }

  /// Inicia los controles del diálogo CON navegación entre botones
  ///
  /// Además de ESC/B button para cerrar, habilita:
  /// - D-pad/arrows para navegar entre botones
  /// - A button para confirmar el botón seleccionado
  /// - Tab/Shift+Tab también funcionan (manejado por Flutter)
  ///
  /// [onCancel]: Callback cuando se presiona B button o ESC.
  /// [buttonCount]: Número total de botones en el diálogo.
  /// [onButtonSelected]: Callback cuando cambia la selección.
  ///                     Recibe el nuevo índice seleccionado.
  ///                     Típicamente: `(index) => setState(() {})`.
  /// [onConfirm]: Callback cuando se presiona A button (opcional).
  ///              Si no se proporciona, A button no hace nada.
  ///              Típicamente: ejecutar acción del botón seleccionado.
  /// [layout]: Layout de botones (horizontal o vertical).
  ///           Afecta cómo se navega:
  ///           - Horizontal: Left/Right navega, Up/Down no
  ///           - Vertical: Up/Down navega, Left/Right no
  /// [defaultIndex]: Índice inicial seleccionado (default: 0).
  /// [interval]: Intervalo de polling (default: 50ms).
  void startDialogControlsWithNavigation({
    required VoidCallback onCancel,
    required int buttonCount,
    required void Function(int selectedIndex) onButtonSelected,
    void Function()? onConfirm,
    ButtonLayout layout = ButtonLayout.horizontal,
    int defaultIndex = 0,
    Duration interval = const Duration(milliseconds: 50),
  }) {
    // Guardar configuración
    _buttonCount = buttonCount;
    _buttonLayout = layout;
    _onButtonSelected = onButtonSelected;
    _onConfirm = onConfirm;
    _selectedButtonIndex = defaultIndex.clamp(0, buttonCount - 1);

    // Cancelar timer previo si existe
    _dialogGamepadTimer?.cancel();

    // Iniciar polling con navegación
    _dialogGamepadTimer = Timer.periodic(interval, (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;

      // Manejar navegación direccional
      _handleButtonNavigation(gamepad);

      // A button = Confirmar botón seleccionado
      if (gamepad.isSelectPressed()) {
        _onConfirm?.call();
      }

      // B button = Cancel/Close
      if (gamepad.isBackPressed()) {
        onCancel();
      }

      // Actualizar estados
      gamepad.updatePreviousButtonStates();
    });
  }

  /// Maneja la navegación entre botones con gamepad
  void _handleButtonNavigation(GamepadService gamepad) {
    if (_buttonCount == 0) return;

    final direction = gamepad.getNavigationDirection();
    if (direction == null) return;

    int newIndex = _selectedButtonIndex;

    // Navegación según layout
    if (_buttonLayout == ButtonLayout.horizontal) {
      // Horizontal: solo left/right
      if (direction == 'left') {
        newIndex = _selectedButtonIndex - 1;
      } else if (direction == 'right') {
        newIndex = _selectedButtonIndex + 1;
      }
    } else {
      // Vertical: solo up/down
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

    // Si cambió, notificar
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Selecciona el siguiente botón (programáticamente)
  ///
  /// Útil si necesitas cambiar la selección desde código.
  void selectNextButton() {
    if (_buttonCount == 0) return;
    final newIndex = (_selectedButtonIndex + 1) % _buttonCount;
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Selecciona el botón anterior (programáticamente)
  void selectPreviousButton() {
    if (_buttonCount == 0) return;
    final newIndex = (_selectedButtonIndex - 1 + _buttonCount) % _buttonCount;
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Establece el botón seleccionado (programáticamente)
  ///
  /// [index]: Índice del botón a seleccionar (clamped al rango válido)
  void setSelectedButton(int index) {
    if (_buttonCount == 0) return;
    final newIndex = index.clamp(0, _buttonCount - 1);
    if (newIndex != _selectedButtonIndex) {
      _selectedButtonIndex = newIndex;
      _onButtonSelected?.call(_selectedButtonIndex);
    }
  }

  /// Detiene los controles del diálogo
  ///
  /// Limpia el timer y el focus node.
  /// Se llama automáticamente en dispose().
  void stopDialogControls() {
    _dialogGamepadTimer?.cancel();
    _dialogGamepadTimer = null;
    _dialogFocusNode?.dispose();
    _dialogFocusNode = null;

    // Reset estado de navegación
    _selectedButtonIndex = 0;
    _buttonCount = 0;
    _onButtonSelected = null;
    _onConfirm = null;
  }

  /// Envuelve el widget del diálogo con KeyboardListener para manejar teclas
  ///
  /// Crea un FocusNode automático si no existe y configura el listener
  /// para las teclas ESC y flechas (si hay navegación activa).
  ///
  /// [child]: Widget del diálogo (típicamente AlertDialog o Dialog)
  /// [onEscape]: Callback cuando se presiona ESC (requerido).
  ///             Típicamente: `() => Navigator.pop(context)`
  ///
  /// Retorna el widget envuelto con KeyboardListener.
  Widget wrapWithKeyboardHandler({
    required Widget child,
    required VoidCallback onEscape,
  }) {
    // Crear focus node si no existe (lazy initialization)
    _dialogFocusNode ??= FocusNode();

    return KeyboardListener(
      focusNode: _dialogFocusNode!,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;

        final key = event.logicalKey;

        // ESC = Cancelar
        if (key == LogicalKeyboardKey.escape) {
          onEscape();
          return;
        }

        // Si hay navegación activa, manejar flechas y Enter/Space
        if (_buttonCount > 0) {
          // Enter/Space = Confirmar botón seleccionado
          if (key == LogicalKeyboardKey.enter ||
              key == LogicalKeyboardKey.space) {
            _onConfirm?.call();
            return;
          }

          // Flechas = Navegar entre botones
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

  /// Verifica si el polling está activo
  bool get isDialogPollingActive =>
      _dialogGamepadTimer != null && _dialogGamepadTimer!.isActive;

  @override
  void dispose() {
    stopDialogControls();
    super.dispose();
  }
}

/// Helper para mostrar diálogos con blur background y barrier oscuro
///
/// Proporciona el patrón estándar de diálogo usado en la app:
/// - Blur background (5px gaussian)
/// - Barrier oscuro (70% opacity)
/// - Configurable dismissible
///
/// Uso:
/// ```dart
/// showDialogWithBlur<bool>(
///   context: context,
///   dialog: MyCustomDialog(),
/// ).then((result) {
///   if (result == true) {
///     // Usuario confirmó
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
