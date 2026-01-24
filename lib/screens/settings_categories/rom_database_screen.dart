import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/romlist_download_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/dialog_button_bar.dart';
import '../../widgets/common/gamepad_button_indicator.dart';

/// Screen for managing ROM database (romLists JSONL lists)
///
/// Allows users to:
/// - View database status
/// - Re-download ROM lists
/// - Clear database
class RomDatabaseScreen extends StatefulWidget {
  const RomDatabaseScreen({super.key});

  @override
  State<RomDatabaseScreen> createState() => _RomDatabaseScreenState();
}

class _RomDatabaseScreenState extends State<RomDatabaseScreen>
    with GamepadPollingMixin<RomDatabaseScreen> {
  final _romlistService = RomlistDownloadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();

  bool _isLoading = true;
  bool _isDownloaded = false;
  Map<String, dynamic>? _downloadInfo;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  int _downloadReceived = 0;
  int _downloadTotal = 0;

  // Navigation state
  int _selectedButtonIndex = 0;
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

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

    // Update gamepad connection status
    final connected = gamepad.isGamepadConnected;
    if (connected != _isGamepadConnected) {
      setState(() => _isGamepadConnected = connected);
    }

    if (!connected) {
      gamepad.updatePreviousButtonStates();
      return;
    }

    // Navigation (horizontal: left/right)
    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      setState(() {
        final totalButtons = _isDownloaded ? 2 : 1;
        if (direction == 'left') {
          _selectedButtonIndex = (_selectedButtonIndex - 1) % totalButtons;
          if (_selectedButtonIndex < 0) _selectedButtonIndex = totalButtons - 1;
        } else if (direction == 'right') {
          _selectedButtonIndex = (_selectedButtonIndex + 1) % totalButtons;
        }
      });
    }

    // Actions
    if (gamepad.isSelectPressed()) {
      _activateSelectedButton();
    } else if (gamepad.isBackPressed()) {
      Navigator.of(context).pop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedButton() {
    if (_selectedButtonIndex == 0) {
      _downloadDatabase();
    } else if (_selectedButtonIndex == 1 && _isDownloaded) {
      _clearDatabase();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);

    final isDownloaded = await _romlistService.isDownloaded();
    final info = await _romlistService.getDownloadInfo();

    if (mounted) {
      setState(() {
        _isDownloaded = isDownloaded;
        _downloadInfo = info;
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _DownloadConfirmDialog(isDownloaded: _isDownloaded),
    );

    if (confirm != true) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final success = await _romlistService.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
              _downloadReceived = received;
              _downloadTotal = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() => _isDownloading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ROM database downloaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _loadStatus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to download ROM database'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clearDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const _ClearConfirmDialog(),
    );

    if (confirm != true) return;

    final success = await _romlistService.deleteRomlists();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ROM database cleared'),
            backgroundColor: Colors.orange,
          ),
        );
        await _loadStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to clear database'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle navigation (horizontal: left/right arrow keys)
    if (key == LogicalKeyboardKey.arrowRight) {
      setState(() {
        final totalButtons = _isDownloaded ? 2 : 1;
        _selectedButtonIndex = (_selectedButtonIndex + 1) % totalButtons;
      });
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      setState(() {
        final totalButtons = _isDownloaded ? 2 : 1;
        _selectedButtonIndex = (_selectedButtonIndex - 1) % totalButtons;
        if (_selectedButtonIndex < 0) _selectedButtonIndex = totalButtons - 1;
      });
      return KeyEventResult.handled;
    }

    // Handle activation (Enter/Space)
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedButton();
      return KeyEventResult.handled;
    }

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(title: const Text('ROM Database'), centerTitle: true),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isDownloading
                  ? _buildDownloadingView()
                  : _buildContentView(),
            ),
            ControlsBottomBar(
              actions: const [
                BottomBarAction(
                  label: 'Back',
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: 'Navigate',
                  keyboardKey: '←→',
                  gamepadButton: 'D-pad',
                ),
                BottomBarAction(
                  label: 'Select',
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
    final progressPercent = (_downloadProgress * 100).toStringAsFixed(1);
    final receivedMB = (_downloadReceived / 1024 / 1024).toStringAsFixed(2);
    final totalMB = (_downloadTotal / 1024 / 1024).toStringAsFixed(2);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Downloading ROM Database...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _downloadProgress),
            const SizedBox(height: 8),
            Text(
              '$progressPercent% - $receivedMB MB / $totalMB MB',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Text(
              'This may take a few minutes depending on your connection...',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isDownloaded ? Icons.check_circle : Icons.cloud_download,
                      color: _isDownloaded ? Colors.green : Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Database Status',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            _isDownloaded ? 'Downloaded' : 'Not Downloaded',
                            style: TextStyle(
                              color: _isDownloaded
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isDownloaded && _downloadInfo != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow('Platforms', '${_downloadInfo!['fileCount']}'),
                  _buildInfoRow(
                    'Total Size',
                    '${_downloadInfo!['totalSizeMB']} MB',
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About ROM Database',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'The ROM database contains lists of available ROMs organized by platform. '
                  'This data is sourced from the Forsaken romList repository on GitHub.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Source: github.com/ForsakenStation/romList',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Actions - styled like DialogButtonBar
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Download/Re-download button
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: AnimatedScale(
                scale: _selectedButtonIndex == 0 ? 1.02 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    border: _selectedButtonIndex == 0
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : Border.all(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _downloadDatabase,
                    icon: Icon(_isDownloaded ? Icons.refresh : Icons.download),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_isDownloaded ? 'Re-download' : 'Download'),
                        if (_isGamepadConnected &&
                            _selectedButtonIndex == 0) ...[
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
              ),
            ),

            // Clear button (only if downloaded)
            if (_isDownloaded) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: AnimatedScale(
                  scale: _selectedButtonIndex == 1 ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      border: _selectedButtonIndex == 1
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : Border.all(color: Colors.transparent, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton.icon(
                      onPressed: _clearDatabase,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                          if (_isGamepadConnected &&
                              _selectedButtonIndex == 1) ...[
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
                ),
              ),
            ],
          ],
        ),
      ],
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

/// Download confirmation dialog with gamepad/keyboard navigation
class _DownloadConfirmDialog extends StatefulWidget {
  final bool isDownloaded;

  const _DownloadConfirmDialog({required this.isDownloaded});

  @override
  State<_DownloadConfirmDialog> createState() => _DownloadConfirmDialogState();
}

class _DownloadConfirmDialogState extends State<_DownloadConfirmDialog>
    with DialogControlsMixin<_DownloadConfirmDialog> {
  late final List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    _buttons = [
      DialogButton(
        label: 'Cancel',
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: widget.isDownloaded ? 'Re-download' : 'Download',
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
      defaultIndex: 1, // Default to Download button
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: const Text('Download ROM Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will download ROM lists from the Forsaken romList repository on GitHub.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Size: ~7 MB\nPlatforms: 138\nTotal ROMs: ~240,000',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            if (widget.isDownloaded)
              const Text(
                'Note: This will overwrite existing data.',
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

/// Clear confirmation dialog with gamepad/keyboard navigation
class _ClearConfirmDialog extends StatefulWidget {
  const _ClearConfirmDialog();

  @override
  State<_ClearConfirmDialog> createState() => _ClearConfirmDialogState();
}

class _ClearConfirmDialogState extends State<_ClearConfirmDialog>
    with DialogControlsMixin<_ClearConfirmDialog> {
  late final List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    _buttons = [
      DialogButton(
        label: 'Cancel',
        onPressed: () => Navigator.pop(context, false),
        gamepadButton: GamepadButton.b,
      ),
      DialogButton(
        label: 'Delete',
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
      defaultIndex: 0, // Default to Cancel
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
      child: AlertDialog(
        title: const Text('Clear ROM Database'),
        content: const Text(
          'This will delete all downloaded ROM lists. '
          'You will need to download them again to browse ROMs.',
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
