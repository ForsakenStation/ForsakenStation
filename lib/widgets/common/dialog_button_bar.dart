import 'package:flutter/material.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';
import 'package:forsaken/mixins/dialog_controls_mixin.dart';

/// Data model for a dialog button
///
/// Contains all information needed to render a button:
/// - Label and action
/// - Optional icon
/// - Style (primary/secondary)
/// - Optional gamepad indicator
class DialogButton {
  /// Button text
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Optional icon (shown before label)
  final IconData? icon;

  /// If true, renders with prominent style (ElevatedButton)
  /// If false, uses TextButton
  final bool primary;

  /// Associated gamepad button (to show indicator)
  /// Only shown if a gamepad is connected
  final GamepadButton? gamepadButton;

  /// Whether the button is enabled (default: true)
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

/// Button bar for dialogs with gamepad/keyboard navigation
///
/// Features:
/// - Navigation with D-pad/arrows between buttons
/// - Visual feedback for selected button (border + scale)
/// - Optional gamepad indicators
/// - Horizontal or vertical layout
/// - A button = activate selected button
/// - B button = cancel (managed by DialogControlsMixin)
///
/// IMPORTANT: This widget must be used together with DialogControlsMixin
/// for navigation to function correctly.
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
  /// List of buttons to show
  final List<DialogButton> buttons;

  /// Index of the currently selected button
  final int selectedIndex;

  /// Button layout (horizontal or vertical)
  final ButtonLayout layout;

  /// Button alignment on the main axis
  final MainAxisAlignment alignment;

  /// Spacing between buttons
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
    // If no buttons, render nothing
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Build button widgets
    final buttonWidgets = List.generate(
      buttons.length,
      (index) => _buildButton(context, index),
    );

    // Render based on layout
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

  /// Builds an individual button with visual feedback
  Widget _buildButton(BuildContext context, int index) {
    final button = buttons[index];
    final isSelected = index == selectedIndex;

    // Visual feedback for selected button
    // Wrap in a Padding to give space for the border
    return Padding(
      padding: const EdgeInsets.all(2.0), // Space for border
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

  /// Builds the button content (ElevatedButton or TextButton)
  Widget _buildButtonContent(BuildContext context, DialogButton button) {
    // Build label with optional icon
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

    // Standard button padding
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    // Render based on style
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

  /// Helper to intersperse widgets with separators
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
