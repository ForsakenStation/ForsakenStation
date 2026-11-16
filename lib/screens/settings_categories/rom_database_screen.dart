import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/romlist_download_service.dart';
import '../../services/gamelist_download_service.dart';
import '../../services/gamelist_media_cache_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/debug_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/common/dialog_button_bar.dart';
import '../../widgets/common/gamepad_button_indicator.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for managing ROM database, gamelists, and media cache.
///
/// Allows users to:
/// - View ROM database status and download/clear romLists
/// - View gamelists status and download/clear gamelists
/// - Rebuild media cache (scan media dirs, write paths to gamelists)
class RomDatabaseScreen extends StatefulWidget {
  const RomDatabaseScreen({super.key});

  @override
  State<RomDatabaseScreen> createState() => _RomDatabaseScreenState();
}

class _RomDatabaseScreenState extends State<RomDatabaseScreen>
    with GamepadPollingMixin<RomDatabaseScreen> {
  final _romlistService = RomlistDownloadService.instance;
  final _gamelistService = GamelistDownloadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _debug = DebugService.instance;
  final _focusNode = FocusNode();

  // ROM database state
  bool _isLoading = true;
  bool _isRomDbDownloaded = false;
  Map<String, dynamic>? _romDbInfo;
  bool _isRomDbDownloading = false;
  double _romDbProgress = 0.0;
  int _romDbReceived = 0;
  int _romDbTotal = 0;

  // Gamelists state
  bool _isGamelistsDownloaded = false;
  Map<String, dynamic>? _gamelistsInfo;
  bool _isGamelistsDownloading = false;
  double _gamelistsProgress = 0.0;
  int _gamelistsReceived = 0;
  int _gamelistsTotal = 0;

  // Media cache state
  bool _isRebuildingCache = false;
  String _cacheProgressText = '';

  // Navigation state: section + button within section
  // Sections: 0=ROM Database, 1=Gamelists, 2=Media Cache
  int _selectedSection = 0;
  int _selectedButtonInSection = 0;
  bool _isGamepadConnected = false;

  @override
  void initState() {
    super.initState();
    startGamepadPolling(_handleGamepadInput);
    _loadStatus();
    _checkGamepadConnection();
  }

  void _checkGamepadConnection() {
    final gamepad = GamepadService.instance;
    setState(() {
      _isGamepadConnected = gamepad.isGamepadConnected;
    });
  }

  int _buttonCountForSection(int section) {
    switch (section) {
      case 0: // ROM Database
        return _isRomDbDownloaded ? 2 : 1;
      case 1: // Gamelists
        return _isGamelistsDownloaded ? 2 : 1;
      case 2: // Media Cache
        return 1;
      default:
        return 1;
    }
  }

  static const _sectionCount = 3;

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

    final connected = gamepad.isGamepadConnected;
    if (connected != _isGamepadConnected) {
      setState(() => _isGamepadConnected = connected);
    }

    if (!connected) {
      gamepad.updatePreviousButtonStates();
      return;
    }

    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      setState(() {
        if (direction == 'left') {
          final count = _buttonCountForSection(_selectedSection);
          _selectedButtonInSection =
              (_selectedButtonInSection - 1 + count) % count;
        } else if (direction == 'right') {
          final count = _buttonCountForSection(_selectedSection);
          _selectedButtonInSection = (_selectedButtonInSection + 1) % count;
        } else if (direction == 'up') {
          _selectedSection =
              (_selectedSection - 1 + _sectionCount) % _sectionCount;
          _selectedButtonInSection = 0;
        } else if (direction == 'down') {
          _selectedSection = (_selectedSection + 1) % _sectionCount;
          _selectedButtonInSection = 0;
        }
      });
    }

    if (gamepad.isSelectPressed()) {
      _activateSelectedButton();
    } else if (gamepad.isBackPressed()) {
      Navigator.of(context).pop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedButton() {
    switch (_selectedSection) {
      case 0: // ROM Database
        if (_selectedButtonInSection == 0) {
          _downloadRomDatabase();
        } else if (_selectedButtonInSection == 1 && _isRomDbDownloaded) {
          _clearRomDatabase();
        }
        break;
      case 1: // Gamelists
        if (_selectedButtonInSection == 0) {
          _downloadGamelists();
        } else if (_selectedButtonInSection == 1 && _isGamelistsDownloaded) {
          _clearGamelists();
        }
        break;
      case 2: // Media Cache
        _rebuildMediaCache();
        break;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);

    final romDbDownloaded = await _romlistService.isDownloaded();
    final romDbInfo = await _romlistService.getDownloadInfo();
    final gamelistsDownloaded = await _gamelistService.isDownloaded();
    final gamelistsInfo = await _gamelistService.getDownloadInfo();

    if (mounted) {
      setState(() {
        _isRomDbDownloaded = romDbDownloaded;
        _romDbInfo = romDbInfo;
        _isGamelistsDownloaded = gamelistsDownloaded;
        _gamelistsInfo = gamelistsInfo;
        _isLoading = false;
      });
    }
  }

  // --- ROM Database actions ---

  Future<void> _downloadRomDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _RomDbDownloadConfirmDialog(isDownloaded: _isRomDbDownloaded),
    );

    if (confirm != true) return;

    setState(() {
      _isRomDbDownloading = true;
      _romDbProgress = 0.0;
    });

    try {
      final success = await _romlistService.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _romDbProgress = progress;
              _romDbReceived = received;
              _romDbTotal = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() => _isRomDbDownloading = false);

        if (success) {
          AppSnackBar.success(
            context,
            AppLocalizations.of(context)!.romDatabaseDownloaded,
          );
          await _loadStatus();
        } else {
          AppSnackBar.error(
            context,
            AppLocalizations.of(context)!.failedDownloadRomDatabase,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRomDbDownloading = false);
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.error}: $e',
        );
      }
    }
  }

  Future<void> _clearRomDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const _RomDbClearConfirmDialog(),
    );

    if (confirm != true) return;

    final success = await _romlistService.deleteRomlists();

    if (mounted) {
      if (success) {
        AppSnackBar.warning(
          context,
          AppLocalizations.of(context)!.romDatabaseCleared,
        );
        await _loadStatus();
      } else {
        AppSnackBar.error(
          context,
          AppLocalizations.of(context)!.failedClearDatabase,
        );
      }
    }
  }

  // --- Gamelists actions ---

  Future<void> _downloadGamelists() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _GamelistDownloadConfirmDialog(isDownloaded: _isGamelistsDownloaded),
    );

    if (confirm != true) return;

    setState(() {
      _isGamelistsDownloading = true;
      _gamelistsProgress = 0.0;
    });

    try {
      final success = await _gamelistService.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _gamelistsProgress = progress;
              _gamelistsReceived = received;
              _gamelistsTotal = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() => _isGamelistsDownloading = false);

        if (success) {
          AppSnackBar.success(
            context,
            AppLocalizations.of(context)!.gamelistsDownloadedSuccess,
          );
          await _loadStatus();
        } else {
          AppSnackBar.error(
            context,
            AppLocalizations.of(context)!.failedDownloadGamelists,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGamelistsDownloading = false);
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.error}: $e',
        );
      }
    }
  }

  Future<void> _clearGamelists() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const _GamelistClearConfirmDialog(),
    );

    if (confirm != true) return;

    final success = await _gamelistService.deleteGamelists();

    if (mounted) {
      if (success) {
        AppSnackBar.warning(
          context,
          AppLocalizations.of(context)!.gamelistsCleared,
        );
        await _loadStatus();
      } else {
        AppSnackBar.error(
          context,
          AppLocalizations.of(context)!.failedClearGamelists,
        );
      }
    }
  }

  // --- Media Cache actions ---

  Future<void> _rebuildMediaCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const _MediaCacheConfirmDialog(),
    );

    if (confirm != true) return;

    setState(() {
      _isRebuildingCache = true;
      _cacheProgressText = AppLocalizations.of(
        context,
      )!.rebuildMediaCacheProgress;
    });

    try {
      final service = GamelistMediaCacheService(
        onPlatformProgress: (platform, current, total) {
          if (mounted) {
            setState(() {
              _cacheProgressText = AppLocalizations.of(context)!
                  .rebuildMediaCacheProcessingPlatform(
                    platform,
                    current.toString(),
                    total.toString(),
                  );
            });
          }
        },
      );

      final result = await service.rebuildAll();

      if (mounted) {
        setState(() => _isRebuildingCache = false);

        if (result.hasError) {
          AppSnackBar.error(
            context,
            AppLocalizations.of(context)!.rebuildMediaCacheError,
          );
        } else {
          final summary = AppLocalizations.of(context)!
              .rebuildMediaCacheSummary(
                result.platformsProcessed.toString(),
                result.gamesTotal.toString(),
                result.gamesUpdated.toString(),
                result.mediaPathsAdded.toString(),
              );

          AppSnackBar.success(
            context,
            summary,
            duration: const Duration(seconds: 5),
          );

          if (result.errors > 0) {
            _debug.warning(
              '${result.errors} errors during media cache rebuild',
              tag: 'RomDatabaseScreen',
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRebuildingCache = false);
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.error}: $e',
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Horizontal navigation (buttons within section)
    if (key == LogicalKeyboardKey.arrowRight) {
      setState(() {
        final count = _buttonCountForSection(_selectedSection);
        _selectedButtonInSection = (_selectedButtonInSection + 1) % count;
      });
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      setState(() {
        final count = _buttonCountForSection(_selectedSection);
        _selectedButtonInSection =
            (_selectedButtonInSection - 1 + count) % count;
      });
      return KeyEventResult.handled;
    }

    // Vertical navigation (between sections)
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedSection = (_selectedSection + 1) % _sectionCount;
        _selectedButtonInSection = 0;
      });
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedSection =
            (_selectedSection - 1 + _sectionCount) % _sectionCount;
        _selectedButtonInSection = 0;
      });
      return KeyEventResult.handled;
    }

    // Activation
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedButton();
      return KeyEventResult.handled;
    }

    // Back
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAnyDownloading =
        _isRomDbDownloading || _isGamelistsDownloading;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.romDatabase),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isAnyDownloading
                  ? _buildDownloadingView()
                  : _isRebuildingCache
                  ? _buildRebuildingView()
                  : _buildContentView(),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.navigate,
                  keyboardKey: '↑↓←→',
                  gamepadButton: 'D-pad',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.select,
                  keyboardKey: 'Enter',
                  gamepadButton: 'A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadingView() {
    final isRomDb = _isRomDbDownloading;
    final progress = isRomDb ? _romDbProgress : _gamelistsProgress;
    final received = isRomDb ? _romDbReceived : _gamelistsReceived;
    final total = isRomDb ? _romDbTotal : _gamelistsTotal;
    final label = isRomDb
        ? AppLocalizations.of(context)!.downloadingRomDatabase
        : AppLocalizations.of(context)!.downloadingGamelists;

    final progressPercent = (progress * 100).toStringAsFixed(1);
    final receivedMB = (received / 1024 / 1024).toStringAsFixed(2);
    final totalMB = (total / 1024 / 1024).toStringAsFixed(2);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              '$progressPercent% - $receivedMB MB / $totalMB MB',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.downloadMayTakeMinutes,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRebuildingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.rebuildMediaCacheProgress,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              _cacheProgressText,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    final l10n = AppLocalizations.of(context)!;

    final romDbCard = _buildUnifiedDatabaseCard(
      section: 0,
      icon: Icons.storage_rounded,
      accentColor: const Color(0xFF0A84FF),
      title: l10n.romDatabase,
      isDownloaded: _isRomDbDownloaded,
      downloadedLabel: l10n.downloaded,
      notDownloadedLabel: l10n.notDownloaded,
      info: _romDbInfo,
      description: l10n.aboutRomDatabaseDescription,
      source: l10n.romDatabaseSource,
      onDownload: _downloadRomDatabase,
      onClear: _clearRomDatabase,
    );

    final gamelistsCard = _buildUnifiedDatabaseCard(
      section: 1,
      icon: Icons.list_alt_rounded,
      accentColor: const Color(0xFF5E5CE6),
      title: l10n.gamelistsStatus,
      isDownloaded: _isGamelistsDownloaded,
      downloadedLabel: l10n.gamelistsDownloaded,
      notDownloadedLabel: l10n.gamelistsNotDownloaded,
      info: _gamelistsInfo,
      description: l10n.aboutGamelistsDescription,
      source: l10n.gamelistsSource,
      onDownload: _downloadGamelists,
      onClear: _clearGamelists,
    );

    final mediaCacheCard = _buildMediaCacheCard(l10n);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 860) {
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: romDbCard),
                          const SizedBox(width: 20),
                          Expanded(child: gamelistsCard),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    mediaCacheCard,
                  ],
                );
              }
              return Column(
                children: [
                  romDbCard,
                  const SizedBox(height: 16),
                  gamelistsCard,
                  const SizedBox(height: 16),
                  mediaCacheCard,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedDatabaseCard({
    required int section,
    required IconData icon,
    required Color accentColor,
    required String title,
    required bool isDownloaded,
    required String downloadedLabel,
    required String notDownloadedLabel,
    required Map<String, dynamic>? info,
    required String description,
    required String source,
    required VoidCallback onDownload,
    required VoidCallback onClear,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = isDownloaded
        ? const Color(0xFF30D158)
        : const Color(0xFFFF9F0A);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.14),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDownloaded
                          ? Icons.check_circle_rounded
                          : Icons.cloud_download_outlined,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isDownloaded ? downloadedLabel : notDownloadedLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            source,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.48),
            ),
          ),
          if (isDownloaded && info != null) ...[
            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 12),
            if (info['fileCount'] != null)
              _buildInfoRow(
                AppLocalizations.of(context)!.platforms,
                '${info['fileCount']}',
              ),
            if (info['totalSizeMB'] != null)
              _buildInfoRow(
                AppLocalizations.of(context)!.totalSize,
                '${info['totalSizeMB']} MB',
              ),
          ],
          const Spacer(),
          const SizedBox(height: 18),
          _buildActionButtons(
            section: section,
            isDownloaded: isDownloaded,
            onDownload: onDownload,
            onClear: onClear,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCacheCard(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const accentColor = Color(0xFFFF9F0A);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.14),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.cached_rounded,
              size: 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rebuildMediaCache,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.rebuildMediaCacheDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildAnimatedButton(
            section: 2,
            buttonIndex: 0,
            child: OutlinedButton.icon(
              onPressed: _rebuildMediaCache,
              icon: const Icon(Icons.build_rounded, size: 18),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.rebuildMediaCache),
                  if (_isGamepadConnected &&
                      _selectedSection == 2 &&
                      _selectedButtonInSection == 0) ...[
                    const SizedBox(width: 8),
                    const GamepadButtonIndicator(
                      button: GamepadButton.a,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required int section,
    required bool isDownloaded,
    required VoidCallback onDownload,
    required VoidCallback onClear,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Download/Re-download button
        _buildAnimatedButton(
          section: section,
          buttonIndex: 0,
          child: FilledButton.icon(
            onPressed: onDownload,
            icon: Icon(
              isDownloaded ? Icons.refresh_rounded : Icons.download_rounded,
              size: 18,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isDownloaded
                      ? AppLocalizations.of(context)!.redownload
                      : AppLocalizations.of(context)!.download,
                ),
                if (_isGamepadConnected &&
                    _selectedSection == section &&
                    _selectedButtonInSection == 0) ...[
                  const SizedBox(width: 8),
                  const GamepadButtonIndicator(
                    button: GamepadButton.a,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Clear button (only if downloaded)
        if (isDownloaded) ...[
          const SizedBox(width: 8),
          _buildAnimatedButton(
            section: section,
            buttonIndex: 1,
            child: OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: Color(0xFFFF453A),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.clear,
                    style: const TextStyle(color: Color(0xFFFF453A)),
                  ),
                  if (_isGamepadConnected &&
                      _selectedSection == section &&
                      _selectedButtonInSection == 1) ...[
                    const SizedBox(width: 8),
                    const GamepadButtonIndicator(
                      button: GamepadButton.a,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnimatedButton({
    required int section,
    required int buttonIndex,
    required Widget child,
  }) {
    final isSelected =
        _selectedSection == section && _selectedButtonInSection == buttonIndex;

    return Padding(
      padding: const EdgeInsets.all(2.0),
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
            borderRadius: BorderRadius.circular(999),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// =============================================================================
// Confirmation Dialogs
// =============================================================================

/// ROM Database download confirmation dialog
class _RomDbDownloadConfirmDialog extends StatefulWidget {
  final bool isDownloaded;

  const _RomDbDownloadConfirmDialog({required this.isDownloaded});

  @override
  State<_RomDbDownloadConfirmDialog> createState() =>
      _RomDbDownloadConfirmDialogState();
}

class _RomDbDownloadConfirmDialogState
    extends State<_RomDbDownloadConfirmDialog>
    with DialogControlsMixin<_RomDbDownloadConfirmDialog> {
  late final List<DialogButton> _buttons;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: widget.isDownloaded
            ? AppLocalizations.of(context)!.redownload
            : AppLocalizations.of(context)!.download,
        onPressed: () => Navigator.pop(context, true),
        primary: true,
        gamepadButton: GamepadButton.a,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      onButtonSelected: (index) => setState(() {}),
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
      defaultIndex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.downloadRomDatabase),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.downloadRomDatabaseDescription),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.downloadRomDatabaseStats,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            if (widget.isDownloaded)
              Text(
                AppLocalizations.of(context)!.downloadWillOverwrite,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          DialogButtonBar(
            buttons: _buttons,
            selectedIndex: selectedButtonIndex,
          ),
        ],
      ),
    );
  }
}

/// ROM Database clear confirmation dialog
class _RomDbClearConfirmDialog extends StatefulWidget {
  const _RomDbClearConfirmDialog();

  @override
  State<_RomDbClearConfirmDialog> createState() =>
      _RomDbClearConfirmDialogState();
}

class _RomDbClearConfirmDialogState extends State<_RomDbClearConfirmDialog>
    with DialogControlsMixin<_RomDbClearConfirmDialog> {
  late final List<DialogButton> _buttons;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: AppLocalizations.of(context)!.delete,
        onPressed: () => Navigator.pop(context, true),
        primary: true,
        gamepadButton: GamepadButton.a,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      onButtonSelected: (index) => setState(() {}),
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
      defaultIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearRomDatabase),
        content: Text(
          AppLocalizations.of(context)!.clearRomDatabaseDescription,
        ),
        actions: [
          DialogButtonBar(
            buttons: _buttons,
            selectedIndex: selectedButtonIndex,
          ),
        ],
      ),
    );
  }
}

/// Gamelist download confirmation dialog
class _GamelistDownloadConfirmDialog extends StatefulWidget {
  final bool isDownloaded;

  const _GamelistDownloadConfirmDialog({required this.isDownloaded});

  @override
  State<_GamelistDownloadConfirmDialog> createState() =>
      _GamelistDownloadConfirmDialogState();
}

class _GamelistDownloadConfirmDialogState
    extends State<_GamelistDownloadConfirmDialog>
    with DialogControlsMixin<_GamelistDownloadConfirmDialog> {
  late final List<DialogButton> _buttons;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: widget.isDownloaded
            ? AppLocalizations.of(context)!.redownload
            : AppLocalizations.of(context)!.download,
        onPressed: () => Navigator.pop(context, true),
        primary: true,
        gamepadButton: GamepadButton.a,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      onButtonSelected: (index) => setState(() {}),
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
      defaultIndex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.downloadGamelists),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.downloadGamelistsDescription),
            const SizedBox(height: 16),
            if (widget.isDownloaded)
              Text(
                AppLocalizations.of(context)!.downloadGamelistsWillOverwrite,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          DialogButtonBar(
            buttons: _buttons,
            selectedIndex: selectedButtonIndex,
          ),
        ],
      ),
    );
  }
}

/// Gamelist clear confirmation dialog
class _GamelistClearConfirmDialog extends StatefulWidget {
  const _GamelistClearConfirmDialog();

  @override
  State<_GamelistClearConfirmDialog> createState() =>
      _GamelistClearConfirmDialogState();
}

class _GamelistClearConfirmDialogState
    extends State<_GamelistClearConfirmDialog>
    with DialogControlsMixin<_GamelistClearConfirmDialog> {
  late final List<DialogButton> _buttons;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: AppLocalizations.of(context)!.delete,
        onPressed: () => Navigator.pop(context, true),
        primary: true,
        gamepadButton: GamepadButton.a,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      onButtonSelected: (index) => setState(() {}),
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
      defaultIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearGamelists),
        content: Text(AppLocalizations.of(context)!.clearGamelistsDescription),
        actions: [
          DialogButtonBar(
            buttons: _buttons,
            selectedIndex: selectedButtonIndex,
          ),
        ],
      ),
    );
  }
}

/// Media cache rebuild confirmation dialog
class _MediaCacheConfirmDialog extends StatefulWidget {
  const _MediaCacheConfirmDialog();

  @override
  State<_MediaCacheConfirmDialog> createState() =>
      _MediaCacheConfirmDialogState();
}

class _MediaCacheConfirmDialogState extends State<_MediaCacheConfirmDialog>
    with DialogControlsMixin<_MediaCacheConfirmDialog> {
  late final List<DialogButton> _buttons;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: AppLocalizations.of(context)!.rebuildMediaCache,
        onPressed: () => Navigator.pop(context, true),
        primary: true,
        gamepadButton: GamepadButton.a,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      onButtonSelected: (index) => setState(() {}),
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
      defaultIndex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.rebuildMediaCacheConfirmTitle,
        ),
        content: Text(
          AppLocalizations.of(context)!.rebuildMediaCacheConfirmBody,
        ),
        actions: [
          DialogButtonBar(
            buttons: _buttons,
            selectedIndex: selectedButtonIndex,
          ),
        ],
      ),
    );
  }
}
