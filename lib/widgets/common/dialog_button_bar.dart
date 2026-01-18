import 'package:flutter/material.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';
import 'package:forsaken/mixins/dialog_controls_mixin.dart';

/// Modelo de datos para un botón en diálogo
///
/// Contiene toda la información necesaria para renderizar un botón:
/// - Label y acción
/// - Icono opcional
/// - Estilo (primary/secondary)
/// - Indicador de gamepad opcional
class DialogButton {
  /// Texto del botón
  final String label;

  /// Callback cuando se presiona el botón
  final VoidCallback onPressed;

  /// Icono opcional (mostrado antes del label)
  final IconData? icon;

  /// Si es true, se renderiza con estilo destacado (ElevatedButton)
  /// Si es false, se usa TextButton
  final bool primary;

  /// Botón de gamepad asociado (para mostrar indicador)
  /// Solo se muestra si hay gamepad conectado
  final GamepadButton? gamepadButton;

  /// Si el botón está habilitado (default: true)
  final bool enabled;

  const DialogButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = false,
    this.gamepadButton,
    this.enabled = true,
  });
}

/// Barra de botones para diálogos con navegación gamepad/teclado
///
/// Características:
/// - Navegación con D-pad/arrows entre botones
/// - Visual feedback del botón seleccionado (border + scale)
/// - Indicadores de gamepad opcionales
/// - Layout horizontal o vertical
/// - A button = activar botón seleccionado
/// - B button = cancelar (gestionado por DialogControlsMixin)
///
/// IMPORTANTE: Este widget debe usarse junto con DialogControlsMixin
/// para que la navegación funcione correctamente.
///
/// Uso:
/// ```dart
/// class MyDialogState extends State<MyDialog>
///     with DialogControlsMixin<MyDialog> {
///
///   @override
///   void initState() {
///     super.initState();
///     startDialogControlsWithNavigation(
///       onCancel: () => Navigator.pop(context, false),
///       buttonCount: 2,
///       onButtonSelected: (index) => setState(() {}),
///       onConfirm: _handleConfirm,
///     );
///   }
///
///   void _handleConfirm() {
///     final buttons = [
///       DialogButton(label: 'Cancel', onPressed: () => Navigator.pop(context, false)),
///       DialogButton(label: 'OK', onPressed: () => Navigator.pop(context, true)),
///     ];
///     buttons[selectedButtonIndex].onPressed();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return wrapWithKeyboardHandler(
///       onEscape: () => Navigator.pop(context, false),
///       child: AlertDialog(
///         title: Text('Confirm'),
///         content: Text('Are you sure?'),
///         actions: [
///           DialogButtonBar(
///             selectedIndex: selectedButtonIndex,
///             buttons: [
///               DialogButton(
///                 label: 'Cancel',
///                 onPressed: () => Navigator.pop(context, false),
///               ),
///               DialogButton(
///                 label: 'OK',
///                 primary: true,
///                 gamepadButton: GamepadButton.a,
///                 onPressed: () => Navigator.pop(context, true),
///               ),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
class DialogButtonBar extends StatelessWidget {
  /// Lista de botones a mostrar
  final List<DialogButton> buttons;

  /// Índice del botón actualmente seleccionado
  final int selectedIndex;

  /// Layout de los botones (horizontal o vertical)
  final ButtonLayout layout;

  /// Alineación de los botones en el eje principal
  final MainAxisAlignment alignment;

  /// Espaciado entre botones
  final double spacing;

  const DialogButtonBar({
    super.key,
    required this.buttons,
    this.selectedIndex = 0,
    this.layout = ButtonLayout.horizontal,
    this.alignment = MainAxisAlignment.end,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay botones, no renderizar nada
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Construir widgets de botones
    final buttonWidgets = List.generate(
      buttons.length,
      (index) => _buildButton(context, index),
    );

    // Renderizar según layout
    if (layout == ButtonLayout.horizontal) {
      return Row(
        mainAxisAlignment: alignment,
        children: _intersperse(buttonWidgets, SizedBox(width: spacing)),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _intersperse(buttonWidgets, SizedBox(height: spacing)),
      );
    }
  }

  /// Construye un botón individual con visual feedback
  Widget _buildButton(BuildContext context, int index) {
    final button = buttons[index];
    final isSelected = index == selectedIndex;

    // Visual feedback del botón seleccionado
    // Envolver en un Container con padding para dar espacio al borde
    return Padding(
      padding: const EdgeInsets.all(2.0), // Espacio para el borde
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _buildButtonContent(context, button),
        ),
      ),
    );
  }

  /// Construye el contenido del botón (ElevatedButton o TextButton)
  Widget _buildButtonContent(BuildContext context, DialogButton button) {
    // Construir label con icono opcional
    final labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (button.icon != null) ...[
          Icon(button.icon, size: 16),
          const SizedBox(width: 8),
        ],
        Text(button.label),
        if (button.gamepadButton != null)
          GamepadButtonIndicator(
            button: button.gamepadButton!,
            showOnlyWhenConnected: true,
          ),
      ],
    );

    // Padding estándar para botones
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    // Renderizar según estilo
    if (button.primary) {
      return ElevatedButton(
        onPressed: button.enabled ? button.onPressed : null,
        style: ElevatedButton.styleFrom(padding: buttonPadding),
        child: labelWidget,
      );
    } else {
      return TextButton(
        onPressed: button.enabled ? button.onPressed : null,
        style: TextButton.styleFrom(padding: buttonPadding),
        child: labelWidget,
      );
    }
  }

  /// Helper para intercalar widgets con separadores
  List<Widget> _intersperse(List<Widget> widgets, Widget separator) {
    if (widgets.isEmpty) return [];
    if (widgets.length == 1) return widgets;

    final result = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

/// Builder para construir una barra de botones con navegación automática
///
/// Simplifica la creación de diálogos con múltiples botones navegables.
/// Maneja automáticamente la integración con DialogControlsMixin.
///
/// Uso:
/// ```dart
/// DialogButtonBarBuilder(
///   buttons: [
///     DialogButton(label: 'Cancel', onPressed: _cancel),
///     DialogButton(label: 'OK', primary: true, gamepadButton: GamepadButton.a, onPressed: _confirm),
///   ],
///   onButtonSelected: (index) {
///     // Opcional: manejar cambio de selección
///   },
/// )
/// ```
class DialogButtonBarBuilder extends StatefulWidget {
  final List<DialogButton> buttons;
  final void Function(int index)? onButtonSelected;
  final ButtonLayout layout;
  final MainAxisAlignment alignment;
  final int defaultSelectedIndex;

  const DialogButtonBarBuilder({
    super.key,
    required this.buttons,
    this.onButtonSelected,
    this.layout = ButtonLayout.horizontal,
    this.alignment = MainAxisAlignment.end,
    this.defaultSelectedIndex = 0,
  });

  @override
  State<DialogButtonBarBuilder> createState() => _DialogButtonBarBuilderState();
}

class _DialogButtonBarBuilderState extends State<DialogButtonBarBuilder> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DialogButtonBar(
      buttons: widget.buttons,
      selectedIndex: _selectedIndex,
      layout: widget.layout,
      alignment: widget.alignment,
    );
  }
}
