import 'package:flutter/material.dart';
import 'package:forsaken/mixins/dialog_controls_mixin.dart';
import 'package:forsaken/widgets/common/dialog_button_bar.dart';

/// Clase base abstracta para diálogos simples con navegación automática
///
/// Proporciona una base completa para crear diálogos con:
/// - Navegación con gamepad/teclado automática
/// - ESC/B button para cerrar
/// - A button para confirmar
/// - Blur background estándar
/// - Focus management automático
///
/// Ideal para diálogos simples con 1-3 botones (confirmación, error, info, etc.)
///
/// Para diálogos más complejos, usar DialogControlsMixin + DialogButtonBar directamente.
///
/// Uso:
/// ```dart
/// class ConfirmDialog extends NavigableDialog {
///   final String message;
///
///   const ConfirmDialog({super.key, required this.message});
///
///   @override
///   String getTitle(BuildContext context) => 'Confirm';
///
///   @override
///   Widget buildContent(BuildContext context) {
///     return Text(message);
///   }
///
///   @override
///   List<DialogButton> buildButtons(BuildContext context) {
///     return [
///       DialogButton(
///         label: 'Cancel',
///         onPressed: () => Navigator.pop(context, false),
///       ),
///       DialogButton(
///         label: 'OK',
///         primary: true,
///         gamepadButton: GamepadButton.a,
///         onPressed: () => Navigator.pop(context, true),
///       ),
///     ];
///   }
/// }
///
/// // Uso
/// final confirmed = await showDialog<bool>(
///   context: context,
///   builder: (_) => ConfirmDialog(message: 'Delete this item?'),
/// );
/// ```
abstract class NavigableDialog extends StatefulWidget {
  const NavigableDialog({super.key});

  /// Título del diálogo
  ///
  /// Retorna el texto que se muestra en el AppBar/header del diálogo.
  /// Si retorna null, no se muestra título.
  String? getTitle(BuildContext context);

  /// Construye el contenido del diálogo
  ///
  /// Este es el cuerpo principal del diálogo.
  /// Puede ser cualquier widget (Text, Column, etc.)
  Widget buildContent(BuildContext context);

  /// Construye la lista de botones del diálogo
  ///
  /// Retorna una lista de DialogButton que se renderizarán con DialogButtonBar.
  /// El orden importa: el último botón suele ser el primario.
  List<DialogButton> buildButtons(BuildContext context);

  /// Layout de los botones (horizontal o vertical)
  ///
  /// Por defecto es horizontal.
  /// Override si necesitas cambiar el layout.
  ButtonLayout getButtonLayout() => ButtonLayout.horizontal;

  /// Índice del botón seleccionado por defecto
  ///
  /// Por defecto es el último botón (típicamente el primario).
  /// Override para cambiar el botón inicial seleccionado.
  int getDefaultButtonIndex(BuildContext context) {
    final buttons = buildButtons(context);
    return buttons.isEmpty ? 0 : buttons.length - 1;
  }

  /// Ancho máximo del diálogo
  ///
  /// Por defecto es 400px.
  /// Override para cambiar el tamaño.
  double getMaxWidth() => 400;

  /// Si el diálogo se puede cerrar haciendo clic fuera
  ///
  /// Por defecto es false.
  bool isDismissible() => false;

  @override
  State<NavigableDialog> createState() => _NavigableDialogState();
}

class _NavigableDialogState extends State<NavigableDialog>
    with DialogControlsMixin<NavigableDialog> {
  late List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    // Construir botones
    _buttons = widget.buildButtons(context);

    // Configurar controles con navegación
    if (_buttons.isNotEmpty) {
      startDialogControlsWithNavigation(
        onCancel: _handleCancel,
        buttonCount: _buttons.length,
        defaultIndex: widget.getDefaultButtonIndex(context),
        onButtonSelected: (index) {
          if (mounted) setState(() {});
        },
        onConfirm: _handleConfirm,
        layout: widget.getButtonLayout(),
      );
    } else {
      // Sin botones, solo cerrar con B/ESC
      startDialogControls(onCancel: _handleCancel);
    }
  }

  void _handleCancel() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleConfirm() {
    if (_buttons.isEmpty) return;
    // Ejecutar acción del botón seleccionado
    _buttons[selectedButtonIndex].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.getTitle(context);

    return wrapWithKeyboardHandler(
      onEscape: _handleCancel,
      child: Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: widget.getMaxWidth()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con título (opcional)
              if (title != null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

              // Contenido
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: widget.buildContent(context),
                ),
              ),

              // Botones
              if (_buttons.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: DialogButtonBar(
                    buttons: _buttons,
                    selectedIndex: selectedButtonIndex,
                    layout: widget.getButtonLayout(),
                    alignment: MainAxisAlignment.end,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper para mostrar NavigableDialog con blur background estándar
///
/// Simplifica el uso de NavigableDialog aplicando automáticamente
/// el patrón estándar de la app (blur + barrier oscuro).
///
/// Uso:
/// ```dart
/// final result = await showNavigableDialog<bool>(
///   context: context,
///   dialog: MyNavigableDialog(),
/// );
/// ```
Future<T?> showNavigableDialog<T>({
  required BuildContext context,
  required NavigableDialog dialog,
}) {
  return showDialogWithBlur<T>(
    context: context,
    dialog: dialog,
    dismissible: dialog.isDismissible(),
  );
}
