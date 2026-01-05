import 'package:flutter/material.dart';

/// Help dialog that shows keyboard shortcuts for the application
/// Can be configured for different screens (Platforms or ROMs)
class HelpDialog extends StatelessWidget {
  final bool showSearchShortcut;

  const HelpDialog({super.key, this.showSearchShortcut = false});

  @override
  Widget build(BuildContext context) {
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
                    'Keyboard Shortcuts',
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
                      _ShortcutItem(
                        'Page Up / Page Down',
                        'Quick navigation (jump multiple items)',
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
                      _ShortcutItem(
                        'Escape',
                        showSearchShortcut
                            ? 'Go back / Close dialogs'
                            : 'Exit application',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, 'View Controls', Icons.view_module, [
                      _ShortcutItem(
                        'V',
                        'Toggle view mode (Grid/List/Carousel)',
                      ),
                      _ShortcutItem('R', 'Refresh current view'),
                      if (showSearchShortcut)
                        _ShortcutItem('S', 'Activate search'),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Help', Icons.info_outline, [
                      _ShortcutItem('?', 'Show this help dialog'),
                    ]),
                    const SizedBox(height: 24),
                    // Tips section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                          _buildTip('Use keyboard for faster navigation'),
                          _buildTip(
                            'Alphabetical jump works in all view modes',
                          ),
                          _buildTip('Press ? anytime to see this help'),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Got it!'),
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

  /// Show help dialog
  static void show(BuildContext context, {bool showSearchShortcut = false}) {
    showDialog(
      context: context,
      builder: (context) => HelpDialog(showSearchShortcut: showSearchShortcut),
    );
  }
}

class _ShortcutItem {
  final String key;
  final String description;

  _ShortcutItem(this.key, this.description);
}
