import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/platform_info.dart';
import '../common/navigable_dialog.dart';
import '../common/dialog_button_bar.dart';
import '../common/gamepad_button_indicator.dart';

/// Dialog that displays detailed information about a gaming platform
class PlatformInfoDialog extends NavigableDialog {
  final String platformName;
  final PlatformInfo platformInfo;

  const PlatformInfoDialog({
    super.key,
    required this.platformName,
    required this.platformInfo,
  });

  /// Show the platform info dialog
  static Future<void> show(
    BuildContext context,
    String platformName,
    PlatformInfo platformInfo,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: PlatformInfoDialog(
          platformName: platformName,
          platformInfo: platformInfo,
        ),
      ),
    );
  }

  @override
  String? getTitle(BuildContext context) {
    // Title is built in content
    return null;
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom title with icon
        Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                platformInfo.fullName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        Text(platformInfo.description, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),

        // Basic Info
        _buildInfoSection(context, 'General Information', [
          _InfoItem('Manufacturer', platformInfo.manufacturer),
          _InfoItem('Release Year', platformInfo.releaseYear.toString()),
          _InfoItem('Generation', platformInfo.generationString),
        ]),
        const SizedBox(height: 16),

        // Technical Specs
        _buildInfoSection(context, 'Technical Specifications', [
          _InfoItem('CPU', platformInfo.cpu),
          _InfoItem('Resolution', platformInfo.resolution),
          _InfoItem('Colors', platformInfo.colors),
        ]),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<_InfoItem> items,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${item.label}:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(item.value, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  List<DialogButton> buildButtons(BuildContext context) {
    return [
      DialogButton(
        label: 'Close',
        gamepadButton: GamepadButton.b,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }

  @override
  double getMaxWidth() => 600; // Wider to show info better
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
