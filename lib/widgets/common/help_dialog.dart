import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/services/gamepad_service.dart';

/// Help dialog that shows keyboard and gamepad controls for the application
/// Can be configured for different screens (Platforms or ROMs)
class HelpDialog extends StatefulWidget {
  final bool showSearchShortcut;
  final bool showPlatformInfoShortcut;

  const HelpDialog({
    super.key,
    this.showSearchShortcut = false,
    this.showPlatformInfoShortcut = false,
  });

  @override
  State<HelpDialog> createState() => _HelpDialogState();

  /// Show help dialog
  static Future<void> show(
    BuildContext context, {
    bool showSearchShortcut = false,
    bool showPlatformInfoShortcut = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) => HelpDialog(
        showSearchShortcut: showSearchShortcut,
        showPlatformInfoShortcut: showPlatformInfoShortcut,
      ),
    );
  }
}

class _HelpDialogState extends State<HelpDialog> {
  final _gamepadService = GamepadService.instance;
  final _closeButtonFocusNode = FocusNode();
  Timer? _gamepadPollTimer;

  @override
  void initState() {
    super.initState();
    // Request focus on close button after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _closeButtonFocusNode.requestFocus();
      }
    });
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _closeButtonFocusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _handleGamepadInput(),
    );
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  void _handleGamepadInput() {
    if (!_gamepadService.isGamepadConnected) return;

    // B button = Close dialog
    if (_gamepadService.isBackPressed()) {
      Navigator.pop(context);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // A button = Close dialog (same as "Got it!")
    if (_gamepadService.isSelectPressed()) {
      Navigator.pop(context);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    _gamepadService.updatePreviousButtonStates();
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = _gamepadService.isGamepadConnected;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Keyboard & Gamepad Controls',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(context, 'Navigation', Icons.navigation, [
                      _ShortcutItem('Arrow Keys', 'Navigate through items'),
                      _ShortcutItem('D-Pad / Left Stick', 'Gamepad navigation'),
                      _ShortcutItem(
                        'Page Up / Page Down',
                        'Quick navigation (jump multiple items)',
                      ),
                      _ShortcutItem(
                        'LB / RB Buttons',
                        'Gamepad page navigation',
                      ),
                      _ShortcutItem('Home', 'Go to first item'),
                      _ShortcutItem('End', 'Go to last item'),
                      _ShortcutItem(
                        'Shift + Letter',
                        'Jump to item starting with that letter',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Actions', Icons.touch_app, [
                      _ShortcutItem('Enter / Space', 'Select item'),
                      _ShortcutItem('A Button', 'Gamepad select'),
                      _ShortcutItem(
                        'Escape',
                        widget.showSearchShortcut
                            ? 'Go back / Close dialogs'
                            : 'Exit application',
                      ),
                      _ShortcutItem('B Button', 'Gamepad back / Close dialogs'),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, 'View Controls', Icons.view_module, [
                      _ShortcutItem(
                        'V',
                        'Toggle view mode (Grid/List/Carousel)',
                      ),
                      _ShortcutItem('Right Stick Click', 'Gamepad view toggle'),
                      _ShortcutItem('R', 'Refresh current view'),
                      if (widget.showPlatformInfoShortcut)
                        _ShortcutItem('I', 'Show platform information'),
                      if (widget.showSearchShortcut)
                        _ShortcutItem('S', 'Activate search'),
                      if (widget.showSearchShortcut)
                        _ShortcutItem('X Button', 'Gamepad search'),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Help', Icons.info_outline, [
                      _ShortcutItem('?', 'Show this help dialog'),
                      _ShortcutItem('Y Button', 'Gamepad help'),
                    ]),
                    const SizedBox(height: 24),
                    // Tips section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tips',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildTip('Use keyboard or gamepad for navigation'),
                          _buildTip(
                            'Alphabetical jump works in all view modes',
                          ),
                          _buildTip('Press ? anytime to see this help'),
                          _buildTip(
                            'Gamepad works alongside keyboard controls',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Focus(
                  focusNode: _closeButtonFocusNode,
                  onKeyEvent: (node, event) {
                    // Handle Enter and Space keys
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.enter ||
                            event.logicalKey == LogicalKeyboardKey.space ||
                            event.logicalKey == LogicalKeyboardKey.escape)) {
                      Navigator.of(context).pop();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasGamepad) ...[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              'B',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        const Text('Got it!'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<_ShortcutItem> shortcuts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...shortcuts.map((shortcut) => _buildShortcutRow(context, shortcut)),
      ],
    );
  }

  Widget _buildShortcutRow(BuildContext context, _ShortcutItem shortcut) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              shortcut.key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              shortcut.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _ShortcutItem {
  final String key;
  final String description;

  _ShortcutItem(this.key, this.description);
}
