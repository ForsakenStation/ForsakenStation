import 'package:flutter/material.dart';
import '../../services/gamepad_service.dart';

/// Botones disponibles del gamepad Xbox
///
/// Cada botón tiene su etiqueta Unicode y color estándar:
/// - A (verde): Acción principal, confirmar
/// - B (rojo): Cancelar, volver
/// - X (azul): Acción secundaria, búsqueda
/// - Y (amarillo): Ayuda, información
enum GamepadButton {
  a('Ⓐ', Colors.green),
  b('Ⓑ', Colors.red),
  x('Ⓧ', Colors.blue),
  y('Ⓨ', Color(0xFFFFD700)); // Amarillo dorado

  const GamepadButton(this.label, this.color);

  /// Etiqueta Unicode del botón (ej: "Ⓐ")
  final String label;

  /// Color estándar del botón
  final Color color;
}

/// Widget que muestra indicador visual de botón de gamepad
///
/// Se usa junto a botones o acciones para mostrar al usuario
/// qué botón del gamepad puede usar. Solo se muestra cuando
/// hay un gamepad conectado (por defecto).
///
/// Uso básico:
/// ```dart
/// ElevatedButton(
///   onPressed: _handleSave,
///   child: Row(
///     children: [
///       Text('Save'),
///       GamepadButtonIndicator(button: GamepadButton.a),
///     ],
///   ),
/// )
/// ```
///
/// Uso con personalización:
/// ```dart
/// GamepadButtonIndicator(
///   button: GamepadButton.a,
///   size: 14,
///   padding: EdgeInsets.all(6),
///   customColor: Colors.purple,
///   showOnlyWhenConnected: false, // Mostrar siempre
/// )
/// ```
class GamepadButtonIndicator extends StatelessWidget {
  /// Botón del gamepad a mostrar
  final GamepadButton button;

  /// Etiqueta custom (sobrescribe la del enum)
  final String? customLabel;

  /// Color custom (sobrescribe el del enum)
  final Color? customColor;

  /// Tamaño del texto en píxeles
  final double size;

  /// Padding interno del contenedor circular
  final EdgeInsets padding;

  /// Si es true, solo muestra cuando gamepad está conectado
  final bool showOnlyWhenConnected;

  const GamepadButtonIndicator({
    super.key,
    required this.button,
    this.customLabel,
    this.customColor,
    this.size = 12,
    this.padding = const EdgeInsets.all(4),
    this.showOnlyWhenConnected = true,
  });

  @override
  Widget build(BuildContext context) {
    // Ocultar si no hay gamepad y está configurado para ocultarse
    if (showOnlyWhenConnected && !GamepadService.instance.isGamepadConnected) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: customColor ?? button.color,
          shape: BoxShape.circle,
        ),
        child: Text(
          customLabel ?? button.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold,
            height: 1.0, // Centrado vertical
          ),
        ),
      ),
    );
  }
}

/// Widget helper para agregar indicador a texto existente
///
/// Facilita crear Row con texto + indicador sin escribir
/// tanto código boilerplate.
///
/// Uso:
/// ```dart
/// TextButton(
///   onPressed: _handleCancel,
///   child: TextWithGamepadButton(
///     text: 'Cancel',
///     button: GamepadButton.b,
///   ),
/// )
/// ```
///
/// Uso con estilo custom:
/// ```dart
/// TextWithGamepadButton(
///   text: 'Advanced',
///   button: GamepadButton.x,
///   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
///   indicatorSize: 14,
/// )
/// ```
class TextWithGamepadButton extends StatelessWidget {
  /// Texto a mostrar
  final String text;

  /// Botón del gamepad a mostrar
  final GamepadButton button;

  /// Estilo del texto (opcional)
  final TextStyle? textStyle;

  /// Tamaño del indicador en píxeles
  final double indicatorSize;

  /// Padding del indicador
  final EdgeInsets indicatorPadding;

  /// Si es true, solo muestra indicador cuando gamepad está conectado
  final bool showOnlyWhenConnected;

  const TextWithGamepadButton({
    super.key,
    required this.text,
    required this.button,
    this.textStyle,
    this.indicatorSize = 12,
    this.indicatorPadding = const EdgeInsets.all(4),
    this.showOnlyWhenConnected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: textStyle),
        GamepadButtonIndicator(
          button: button,
          size: indicatorSize,
          padding: indicatorPadding,
          showOnlyWhenConnected: showOnlyWhenConnected,
        ),
      ],
    );
  }
}

/// Widget para mostrar múltiples controles en una fila
///
/// Útil para mostrar leyendas de controles (ej: en ayuda, tutoriales)
///
/// Uso:
/// ```dart
/// GamepadControlsRow(
///   controls: [
///     (GamepadButton.a, 'Confirm'),
///     (GamepadButton.b, 'Cancel'),
///     (GamepadButton.x, 'Search'),
///   ],
/// )
/// ```
class GamepadControlsRow extends StatelessWidget {
  /// Lista de (botón, descripción) a mostrar
  final List<(GamepadButton, String)> controls;

  /// Espaciado entre controles
  final double spacing;

  /// Tamaño de los indicadores
  final double indicatorSize;

  const GamepadControlsRow({
    super.key,
    required this.controls,
    this.spacing = 16,
    this.indicatorSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    // No mostrar si no hay gamepad
    if (!GamepadService.instance.isGamepadConnected) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      children: controls.map((control) {
        final (button, description) = control;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GamepadButtonIndicator(
              button: button,
              size: indicatorSize,
              showOnlyWhenConnected: false, // Ya verificamos arriba
            ),
            const SizedBox(width: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      }).toList(),
    );
  }
}
