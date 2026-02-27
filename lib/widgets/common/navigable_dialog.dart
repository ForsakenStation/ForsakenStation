import 'package:flutter/material.dart';
import '../../mixins/dialog_controls_mixin.dart';
import 'dialog_button_bar.dart';

/// Abstract base class for simple dialogs with automatic navigation
///
/// Provides a complete base to create dialogs with:
/// - Automatic gamepad/keyboard navigation
/// - ESC/B button to close
/// - A button to confirm
/// - Standard blur background
/// - Automatic focus management
///
/// Ideal for simple dialogs with 1-3 buttons (confirmation, error, info, etc.)
///
/// For more complex dialogs, use DialogControlsMixin + DialogButtonBar directly.
///
/// Usage:
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
/// // Usage
/// final confirmed = await showDialog<bool>(
///   context: context,
///   builder: (_) => ConfirmDialog(message: 'Delete this item?'),
/// );
/// ```
abstract class NavigableDialog extends StatefulWidget {
  const NavigableDialog({super.key});

  /// Dialog title
  ///
  /// Returns the text shown in the AppBar/header of the dialog.
  /// If null, no title is shown.
  String? getTitle(BuildContext context);

  /// Builds the dialog content
  ///
  /// This is the main body of the dialog.
  /// Can be any widget (Text, Column, etc.)
  Widget buildContent(BuildContext context);

  /// Builds the list of dialog buttons
  ///
  /// Returns a list of DialogButton to be rendered with DialogButtonBar.
  /// Order matters: the last button is usually the primary one.
  List<DialogButton> buildButtons(BuildContext context);

  /// Button layout (horizontal or vertical)
  ///
  /// Defaults to horizontal.
  /// Override if you need to change the layout.
  ButtonLayout getButtonLayout() => ButtonLayout.horizontal;

  /// Index of the default selected button
  ///
  /// Defaults to the last button (typically the primary one).
  /// Override to change the initial selected button.
  int getDefaultButtonIndex(BuildContext context) {
    final buttons = buildButtons(context);
    return buttons.isEmpty ? 0 : buttons.length - 1;
  }

  /// Maximum width of the dialog
  ///
  /// Defaults to 400px.
  /// Override to change the size.
  double getMaxWidth() => 400;

  /// Whether the dialog can be closed by clicking outside
  ///
  /// Defaults to false.
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

    // Build buttons
    _buttons = widget.buildButtons(context);

    // Configure controls with navigation
    if (_buttons.isNotEmpty) {
      startDialogControlsWithNavigation(
        onCancel: _handleDismiss,
        buttonCount: _buttons.length,
        defaultIndex: widget.getDefaultButtonIndex(context),
        onButtonSelected: (index) {
          if (mounted) setState(() {});
        },
        onConfirm: _handleConfirm,
        layout: widget.getButtonLayout(),
      );
    } else {
      // No buttons, just close with B/ESC
      startDialogControls(onCancel: _handleDismiss);
    }
  }

  void _handleDismiss() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleConfirm() {
    if (_buttons.isEmpty) return;
    // Execute action of selected button
    _buttons[selectedButtonIndex].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.getTitle(context);

    return wrapWithKeyboardHandler(
      onEscape: _handleDismiss,
      child: Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: widget.getMaxWidth()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with title (optional)
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

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: widget.buildContent(context),
                ),
              ),

              // Buttons
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

/// Helper to show NavigableDialog with standard blur background
///
/// Simplifies usage of NavigableDialog by automatically applying
/// the app's standard pattern (blur + dark barrier).
///
/// Usage:
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
