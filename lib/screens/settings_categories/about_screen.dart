import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/legal.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/gamepad_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/animated_lucide_icon.dart';
import '../../widgets/common/controls_bottom_bar.dart';

/// Full-screen About view showing app version, legal disclaimer, and credits.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _focusNode = FocusNode();
  final _gamepadService = GamepadService.instance;
  final _keyboardService = KeyboardService.instance;
  Timer? _gamepadTimer;
  DateTime _lastInputTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _gamepadTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _pollGamepad(),
    );
  }

  @override
  void dispose() {
    _gamepadTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _pollGamepad() {
    if (!mounted || !_gamepadService.isGamepadConnected) return;
    final now = DateTime.now();
    if (now.difference(_lastInputTime).inMilliseconds < 200) return;

    if (_gamepadService.isButtonPressed(GamepadService.buttonB)) {
      _lastInputTime = now;
      Navigator.of(context).pop();
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_keyboardService.isBackKey(event.logicalKey)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (_, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.aboutForsakenEmulator)),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App summary card
                        Container(
                          decoration: _cardDecoration(colorScheme),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0A84FF,
                                  ).withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const AnimatedLucideIcon(
                                  type: AnimatedLucideIconType.info,
                                  color: Color(0xFF0A84FF),
                                  size: 28,
                                  animate: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.aboutForsakenEmulator,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Text(
                                            '${l10n.version} $kAppVersion',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.appDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    ExcludeFocus(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => launchUrl(
                                          Uri.parse(
                                            'https://github.com/ForsakenStation/ForsakenStation',
                                          ),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.08,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.code_rounded,
                                                size: 16,
                                                color: Color(0xFF0A84FF),
                                              ),
                                              const SizedBox(width: 8),
                                              const Flexible(
                                                child: Text(
                                                  'github.com/ForsakenStation/ForsakenStation',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'monospace',
                                                    fontSize: 12,
                                                    color: Color(0xFF0A84FF),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Icon(
                                                Icons.open_in_new_rounded,
                                                size: 14,
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.55),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Legal disclaimer card
                        Material(
                          color: colorScheme.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.legalDisclaimer,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      kLegalDisclaimer,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.55,
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Credits card
                        Container(
                          decoration: _cardDecoration(colorScheme),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CreditSection(
                                title: l10n.romDatabase,
                                description: l10n.romDatabaseCredits,
                                url: 'https://github.com/Arley4d/AndroidRoms',
                                note: l10n.romDatabaseThanks,
                              ),
                              const SizedBox(height: 18),
                              Divider(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.14,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _CreditSection(
                                title: l10n.biosFilesSection,
                                description: l10n.biosFilesCredits,
                                url:
                                    'https://github.com/Abdess/retroarch_system',
                                note: l10n.biosFilesThanks,
                              ),
                              const SizedBox(height: 14),
                              _CreditSection(
                                description: l10n.amigaCopyProtection,
                                url: 'https://github.com/rsn8887/capsimg',
                                note: l10n.amigaCopyProtectionThanks,
                              ),
                              const SizedBox(height: 14),
                              _CreditSection(
                                description: l10n.additionalBiosFiles,
                                url: 'https://github.com/PIBSAS/RetroPieBios',
                                note: l10n.additionalBiosThanks,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: l10n.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(ColorScheme colorScheme) {
    return BoxDecoration(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    );
  }
}

class _CreditSection extends StatelessWidget {
  const _CreditSection({
    this.title,
    required this.description,
    required this.url,
    required this.note,
  });

  final String? title;
  final String description;
  final String url;
  final String note;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          url,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Color(0xFF0A84FF),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          note,
          style: TextStyle(
            fontSize: 12,
            color: onSurface.withValues(alpha: 0.58),
          ),
        ),
      ],
    );
  }
}
