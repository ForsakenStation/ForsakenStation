import 'package:flutter/material.dart';
import '../../services/gamepad_service.dart';

/// Available Xbox-style gamepad buttons
///
/// Each button has a Unicode label and standard color:
/// - A (green): Main action, confirm
/// - B (red): Cancel, back
/// - X (blue): Secondary action, search
/// - Y (yellow): Help, info
enum GamepadButton {
  a('Ⓐ', Colors.green),
  b('Ⓑ', Colors.red),
  x('Ⓧ', Colors.blue),
  y('Ⓨ', Color(0xFFFFD700)); // Golden yellow

  const GamepadButton(this.label, this.color);

  /// Unicode label for the button (e.g. "Ⓐ")
  final String label;

  /// Standard button color
  final Color color;
}

/// Widget that displays a visual indicator of a gamepad button
///
/// Used alongside buttons or actions to show the user
/// which gamepad button can be used. By default, only shows
/// when a gamepad is connected.
///
/// Basic usage:
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
/// Customized usage:
/// ```dart
/// GamepadButtonIndicator(
///   button: GamepadButton.a,
///   size: 14,
///   padding: EdgeInsets.all(6),
///   customColor: Colors.purple,
///   showOnlyWhenConnected: false, // Always show
/// )
/// ```
class GamepadButtonIndicator extends StatelessWidget {
  /// Gamepad button to display
  final GamepadButton button;

  /// Custom label (overrides enum label)
  final String? customLabel;

  /// Custom color (overrides enum color)
  final Color? customColor;

  /// Text size in pixels
  final double size;

  /// Internal padding of the circular container
  final EdgeInsets padding;

  /// If true, only shows when a gamepad is connected
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
    // Hide if no gamepad and configured to hide
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
            height: 1.0, // Vertical centering
          ),
        ),
      ),
    );
  }
}

/// Helper widget to add an indicator to existing text
///
/// Makes it easy to create a Row with text + indicator without
/// much boilerplate code.
///
/// Usage:
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
/// Custom style usage:
/// ```dart
/// TextWithGamepadButton(
///   text: 'Advanced',
///   button: GamepadButton.x,
///   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
///   indicatorSize: 14,
/// )
/// ```
class TextWithGamepadButton extends StatelessWidget {
  /// Text to display
  final String text;

  /// Gamepad button to display
  final GamepadButton button;

  /// Text style (optional)
  final TextStyle? textStyle;

  /// Indicator size in pixels
  final double indicatorSize;

  /// Indicator padding
  final EdgeInsets indicatorPadding;

  /// If true, only shows indicator when a gamepad is connected
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

/// Widget to display multiple controls in a row
///
/// Useful for displaying control legends (e.g. in help, tutorials)
///
/// Usage:
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
  /// List of (button, description) to display
  final List<(GamepadButton, String)> controls;

  /// Spacing between controls
  final double spacing;

  /// Indicator size
  final double indicatorSize;

  const GamepadControlsRow({
    super.key,
    required this.controls,
    this.spacing = 16,
    this.indicatorSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show if no gamepad
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
              showOnlyWhenConnected: false, // Already checked above
            ),
            const SizedBox(width: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      }).toList(),
    );
  }
}
