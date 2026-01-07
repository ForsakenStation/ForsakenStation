import 'package:flutter/material.dart';
import '../../models/platform_info.dart';

/// Dialog that displays detailed information about a gaming platform
class PlatformInfoDialog extends StatelessWidget {
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
      builder: (context) => PlatformInfoDialog(
        platformName: platformName,
        platformInfo: platformInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description
            Text(platformInfo.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),

            // Basic Info
            _buildInfoSection(context, 'Información General', [
              _InfoItem('Fabricante', platformInfo.manufacturer),
              _InfoItem(
                'Año de Lanzamiento',
                platformInfo.releaseYear.toString(),
              ),
              _InfoItem('Generación', platformInfo.generationString),
            ]),
            const SizedBox(height: 16),

            // Technical Specs
            _buildInfoSection(context, 'Especificaciones Técnicas', [
              _InfoItem('CPU', platformInfo.cpu),
              _InfoItem('Resolución', platformInfo.resolution),
              _InfoItem('Colores', platformInfo.colors),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
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
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
