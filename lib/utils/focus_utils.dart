import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utilidades comunes para gestión de focus en la aplicación
///
/// Proporciona helpers para:
/// - Request focus después del build
/// - Wrappers para manejo de ESC key
/// - Helpers para focus trapping en diálogos
class FocusUtils {
  /// Request focus en un FocusNode después del próximo frame
  ///
  /// Útil cuando necesitas hacer focus en un widget inmediatamente después
  /// de que se construya, como en initState() o didChangeDependencies().
  ///
  /// Uso:
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

  /// Envuelve un widget con un Focus listener para manejar la tecla ESC
  ///
  /// Útil para diálogos, modals, y otras UIs que necesitan cerrarse con ESC.
  ///
  /// [child]: Widget a envolver
  /// [onEscape]: Callback cuando se presiona ESC
  /// [autofocus]: Si debe auto-enfocarse (default: true)
  ///
  /// Uso:
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

  /// Envuelve un widget con un KeyboardListener para múltiples teclas
  ///
  /// Más flexible que withEscapeKey cuando necesitas manejar múltiples teclas.
  ///
  /// [child]: Widget a envolver
  /// [onKeyEvent]: Handler de eventos de teclado
  /// [autofocus]: Si debe auto-enfocarse (default: true)
  ///
  /// Uso:
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

  /// Crea un FocusNode simple
  ///
  /// NOTA: El caller es responsable de llamar dispose() manualmente.
  /// Preferir crear FocusNodes como campos de clase y hacer dispose en dispose().
  static FocusNode createFocusNode() {
    return FocusNode();
  }

  /// Verifica si un FocusNode puede recibir focus
  ///
  /// Útil antes de llamar requestFocus() para evitar errores.
  static bool canRequestFocus(FocusNode node) {
    return node.context != null && node.canRequestFocus;
  }

  /// Unfocus el FocusNode actual si está focused
  ///
  /// Útil para cerrar el teclado en móvil o remover focus de un campo.
  static void unfocusIfFocused(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();
    }
  }

  /// Mueve el focus al siguiente FocusNode en el árbol de focus
  ///
  /// Equivalente a presionar Tab.
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Mueve el focus al FocusNode anterior en el árbol de focus
  ///
  /// Equivalente a presionar Shift+Tab.
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus todo en el scope actual
  ///
  /// Útil para cerrar teclados o limpiar focus state.
  static void unfocusAll(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Request focus en un widget específico por su BuildContext
  ///
  /// [context]: BuildContext del widget que debe recibir focus
  static void requestFocusInContext(BuildContext context) {
    FocusScope.of(context).requestFocus();
  }
}
