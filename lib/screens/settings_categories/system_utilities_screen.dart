import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/rom_storage_service.dart';
import '../../widgets/common/animated_lucide_icon.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/common/dialog_button_bar.dart';
import '../../widgets/common/gamepad_button_indicator.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for system utilities and maintenance
///
/// Allows users to:
/// - Cleanup temporary ROM files
/// - Verify ROM files exist
/// - Check for missing gamelists
/// - Backup/restore configuration
/// - Clear cache
/// - Check disk space
class SystemUtilitiesScreen extends StatefulWidget {
  const SystemUtilitiesScreen({super.key});

  @override
  State<SystemUtilitiesScreen> createState() => _SystemUtilitiesScreenState();
}

class _SystemUtilitiesScreenState extends State<SystemUtilitiesScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  Map<String, dynamic>? _stats;
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    // Handle refresh (R key)
    if (key == LogicalKeyboardKey.keyR && !_isLoadingStats) {
      _loadStats();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);

    try {
      final stats = <String, dynamic>{};
      final gamelistPath = await _configService.gamelistPath;
      stats['gamelistPath'] = gamelistPath;

      final storageStats = await RomStorageService.instance.getStorageStats();
      final tempCount = (storageStats['tempCount'] as int?) ?? 0;
      final foreverCount = (storageStats['foreverCount'] as int?) ?? 0;
      stats['romCount'] = tempCount + foreverCount;

      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _stats = {'romCount': 0, 'gamelistPath': '—'};
          _isLoadingStats = false;
        });
      }
    }
  }

  Future<void> _cleanupTempRoms() async {
    try {
      final storage = RomStorageService.instance;
      final beforeStats = await storage.getStorageStats();
      final deletedCount = (beforeStats['tempCount'] as int?) ?? 0;

      await storage.cleanupAllTempRoms();

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        AppSnackBar.success(
          context,
          l10n.cleanedUpTempFiles(deletedCount.toString()),
          icon: Icons.cleaning_services_outlined,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorCleaningTempFiles} $e',
        );
      }
    }
  }

  Future<void> _verifyRomFiles() async {
    try {
      final gamelistPath = await _configService.gamelistPath;
      final gamelistDir = Directory(gamelistPath);

      if (!await gamelistDir.exists()) {
        if (mounted) {
          AppSnackBar.warning(
            context,
            AppLocalizations.of(context)!.romsDirectoryDoesNotExist,
          );
        }
        return;
      }

      int totalFiles = 0;
      int emptyFiles = 0;

      await for (final entity in gamelistDir.list(recursive: true)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.jsonl')) {
          try {
            totalFiles++;
            final contents = await entity.readAsString();
            if (contents.trim().isEmpty) {
              emptyFiles++;
            }
          } catch (_) {
            continue;
          }
        }
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.romVerificationResults),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.totalRomFiles}: $totalFiles',
                ),
                Text(
                  '${AppLocalizations.of(context)!.emptyRomFiles}: $emptyFiles',
                ),
                Text(
                  '${AppLocalizations.of(context)!.validRomFiles}: ${totalFiles - emptyFiles}',
                ),
              ],
            ),
            actions: [
              DialogButtonBar(
                buttons: [
                  DialogButton(
                    label: AppLocalizations.of(context)!.close,
                    onPressed: () => Navigator.pop(context),
                    primary: true,
                    gamepadButton: GamepadButton.b,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorVerifyingRomFiles} $e',
        );
      }
    }
  }

  Future<void> _checkMissingGamelists() async {
    try {
      final gamelistPath = await _configService.gamelistPath;
      final gamelistDir = Directory(gamelistPath);

      if (!await gamelistDir.exists()) {
        if (mounted) {
          AppSnackBar.warning(
            context,
            AppLocalizations.of(context)!.romsDirectoryDoesNotExist,
          );
        }
        return;
      }

      final platforms = <String>[];
      final missingGamelists = <String>[];

      await for (final entity in gamelistDir.list()) {
        if (entity is Directory) {
          final platform = path.basename(entity.path);
          platforms.add(platform);

          final jsonlFile = File(path.join(entity.path, '$platform.jsonl'));
          final xmlFile = File(path.join(entity.path, 'gamelist.xml'));

          if (!await jsonlFile.exists() && !await xmlFile.exists()) {
            missingGamelists.add(platform);
          }
        }
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.gamelistCheckResults),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.totalPlatforms}: ${platforms.length}'),
                Text('${l10n.missingGamelists}: ${missingGamelists.length}'),
                if (missingGamelists.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.missingFor,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...missingGamelists.map((p) => Text('  • $p')),
                ],
              ],
            ),
            actions: [
              DialogButtonBar(
                buttons: [
                  DialogButton(
                    label: AppLocalizations.of(context)!.close,
                    onPressed: () => Navigator.pop(context),
                    primary: true,
                    gamepadButton: GamepadButton.b,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorCheckingGamelists} $e',
        );
      }
    }
  }

  Future<void> _backupConfiguration() async {
    try {
      // Get current active config
      final dialogTitle = AppLocalizations.of(context)!.saveConfigurationBackup;
      final config = await _configService.getConfig();

      // Format as JSON
      final encoder = const JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(config);

      // Get save location from user
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final result = await FilePicker.saveFile(
        fileName: 'config_backup_$timestamp.json',
        bytes: utf8.encode(jsonString),
        dialogTitle: dialogTitle,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result as String);
        await file.writeAsString(jsonString);

        if (mounted) {
          AppSnackBar.success(
            context,
            '${AppLocalizations.of(context)!.configurationBackedUp}\n$result',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorBackingUp} $e',
        );
      }
    }
  }

  Future<void> _importConfiguration() async {
    try {
      final result = await FilePicker.pickFiles(
        dialogTitle: AppLocalizations.of(context)!.systemUtilities,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result.isEmpty || result.single.path == null) return;

      final file = File(result.single.path!);
      final content = await file.readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic> || decoded['emulators'] is! List) {
        if (mounted) {
          AppSnackBar.error(
            context,
            '${AppLocalizations.of(context)!.errorSavingSettings} Invalid config.json format',
          );
        }
        return;
      }

      await _configService.saveConfig(decoded);
      if (mounted) {
        AppSnackBar.success(
          context,
          AppLocalizations.of(context)!.configurationReloaded,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorSavingSettings} $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.systemUtilities),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadStats,
              tooltip: AppLocalizations.of(context)!.refreshStatsR,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Card
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.systemStatistics,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              if (_isLoadingStats)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (_stats != null)
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final romFiles = _StatRow(
                                      label: AppLocalizations.of(
                                        context,
                                      )!.romFiles,
                                      value: '${_stats!['romCount'] ?? 0}',
                                      icon: Icons.file_copy_outlined,
                                    );
                                    final romsPath = _StatRow(
                                      label: AppLocalizations.of(
                                        context,
                                      )!.gamelistPathAutomatic,
                                      value:
                                          (_stats!['gamelistPath'] as String?)
                                                  ?.isNotEmpty ==
                                              true
                                          ? _stats!['gamelistPath'] as String
                                          : '—',
                                      icon: Icons.folder_outlined,
                                    );
                                    if (constraints.maxWidth >= 640) {
                                      return Row(
                                        children: [
                                          Expanded(child: romFiles),
                                          const SizedBox(width: 24),
                                          Expanded(flex: 2, child: romsPath),
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        romFiles,
                                        const SizedBox(height: 12),
                                        romsPath,
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text(
                          AppLocalizations.of(context)!.maintenanceTools,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 14),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cards = [
                              _UtilityCard(
                                iconType: AnimatedLucideIconType.trash2,
                                title: AppLocalizations.of(
                                  context,
                                )!.cleanupTemporaryRoms,
                                description: AppLocalizations.of(
                                  context,
                                )!.cleanupTemporaryRomsDescription,
                                onPressed: _cleanupTempRoms,
                              ),
                              _UtilityCard(
                                iconType: AnimatedLucideIconType.shieldCheck,
                                title: AppLocalizations.of(
                                  context,
                                )!.verifyRomFiles,
                                description: AppLocalizations.of(
                                  context,
                                )!.verifyRomFilesDescription,
                                onPressed: _verifyRomFiles,
                              ),
                              _UtilityCard(
                                iconType: AnimatedLucideIconType.folderCheck,
                                title: AppLocalizations.of(
                                  context,
                                )!.checkMissingGamelists,
                                description: AppLocalizations.of(
                                  context,
                                )!.checkMissingGamelistsDescription,
                                onPressed: _checkMissingGamelists,
                              ),
                              _UtilityCard(
                                iconType: AnimatedLucideIconType.archive,
                                title: 'Export config.json',
                                description: AppLocalizations.of(
                                  context,
                                )!.backupConfigurationDescription,
                                onPressed: _backupConfiguration,
                              ),
                              _UtilityCard(
                                iconType: AnimatedLucideIconType.folderCheck,
                                title: 'Import config.json',
                                description:
                                    'Restore emulators configuration from a config.json file',
                                onPressed: _importConfiguration,
                              ),
                            ];

                            if (constraints.maxWidth >= 720) {
                              final rows = <Widget>[];
                              for (var i = 0; i < cards.length; i += 2) {
                                if (i > 0) rows.add(const SizedBox(height: 14));
                                rows.add(
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: cards[i]),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: i + 1 < cards.length
                                              ? cards[i + 1]
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Column(children: rows);
                            }

                            return Column(
                              children: cards
                                  .map(
                                    (c) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: c,
                                    ),
                                  )
                                  .toList(),
                            );
                          },
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
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.refresh,
                  keyboardKey: 'R',
                  gamepadButton: 'Start',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying a stat row
class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget for a utility action card
class _UtilityCard extends StatefulWidget {
  final AnimatedLucideIconType iconType;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const _UtilityCard({
    required this.iconType,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  State<_UtilityCard> createState() => _UtilityCardState();
}

class _UtilityCardState extends State<_UtilityCard> {
  bool _isHoveredOrFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: _isHoveredOrFocused
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (hovered) => setState(() => _isHoveredOrFocused = hovered),
        onFocusChange: (focused) =>
            setState(() => _isHoveredOrFocused = focused),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedLucideIcon(
                  type: widget.iconType,
                  size: 22,
                  animate: _isHoveredOrFocused,
                  color: colorScheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
