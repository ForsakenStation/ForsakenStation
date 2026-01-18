import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/platform_info.dart';
import '../../services/gamepad_service.dart';

/// Dialog that displays detailed information about a gaming platform
class PlatformInfoDialog extends StatefulWidget {
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
  State<PlatformInfoDialog> createState() => _PlatformInfoDialogState();
}

class _PlatformInfoDialogState extends State<PlatformInfoDialog> {
  Timer? _gamepadPollTimer;
  final FocusNode _closeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _closeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _closeFocusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;

      if (gamepad.isBackPressed() || gamepad.isSelectPressed()) {
        Navigator.of(context).pop();
      }

      gamepad.updatePreviousButtonStates();
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      child: Focus(
        autofocus: true,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.platformInfo.fullName,
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
                Text(
                  widget.platformInfo.description,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Basic Info
                _buildInfoSection(context, 'Información General', [
                  _InfoItem('Fabricante', widget.platformInfo.manufacturer),
                  _InfoItem(
                    'Año de Lanzamiento',
                    widget.platformInfo.releaseYear.toString(),
                  ),
                  _InfoItem('Generación', widget.platformInfo.generationString),
                ]),
                const SizedBox(height: 16),

                // Technical Specs
                _buildInfoSection(context, 'Especificaciones Técnicas', [
                  _InfoItem('CPU', widget.platformInfo.cpu),
                  _InfoItem('Resolución', widget.platformInfo.resolution),
                  _InfoItem('Colores', widget.platformInfo.colors),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(
              focusNode: _closeFocusNode,
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cerrar'),
                  if (GamepadService.instance.isGamepadConnected) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Ⓑ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
