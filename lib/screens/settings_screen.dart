import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'settings_categories/emulator_management_screen.dart';
import 'settings_categories/system_paths_screen.dart';
import 'settings_categories/rom_database_screen.dart';
import 'settings_categories/rom_storage_management_screen.dart';
import 'settings_categories/system_check_screen.dart';
import 'settings_categories/gamepad_test_screen.dart';
import 'settings_categories/bios_help_screen.dart';
import 'settings_categories/archive_org_settings_screen.dart';
import 'settings_categories/web_settings_screen.dart';
import 'settings_categories/language_settings_screen.dart';
import 'setup_wizard_screen.dart';
import '../services/debug_service.dart';
import '../services/config_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../l10n/generated/app_localizations.dart';

// Web-specific import (conditional for web platform)
import '../platforms/web/web_emulator_service.dart'
    if (dart.library.io) 'package:forsaken/services/empty_stub.dart';
import '../constants/legal.dart';
import '../widgets/common/dialog_button_bar.dart';
import '../widgets/common/gamepad_button_indicator.dart';

/// Main settings screen with categorized configuration options
/// Replaces bash scripts with native Flutter UI
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  Timer? _gamepadPollTimer;
  int _selectedIndex = 0;
  final int _categoryCount = kIsWeb ? 12 : 11;
  bool _isGamepadNavigating = false;

  // Height of each card + spacing (approximate)
  static const double _itemHeight = 88.0 + 12.0; // Card height + SizedBox
  static const double _headerHeight = 200.0; // Approximate header card height

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;

      // Navigation
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        setState(() {
          _isGamepadNavigating = true;
          if (direction == 'up') {
            _selectedIndex = (_selectedIndex - 1) % _categoryCount;
            if (_selectedIndex < 0) _selectedIndex = _categoryCount - 1;
          } else if (direction == 'down') {
            _selectedIndex = (_selectedIndex + 1) % _categoryCount;
          }
          _scrollToSelected();
        });
      }

      // Buttons
      if (gamepad.isSelectPressed()) {
        _navigateToCategory(_selectedIndex);
      } else if (gamepad.isBackPressed()) {
        Navigator.pop(context);
      }

      gamepad.updatePreviousButtonStates();
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;

    // Calculate target scroll position
    // Header height + (item height * selected index)
    final targetOffset = _headerHeight + (_itemHeight * _selectedIndex);

    // Get viewport height
    final viewportHeight = _scrollController.position.viewportDimension;

    // Calculate the offset to center the item, but clamp to valid range
    final centeredOffset =
        targetOffset - (viewportHeight / 2) + (_itemHeight / 2);

    // Ensure we don't scroll beyond bounds
    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;
    final clampedOffset = centeredOffset.clamp(minScroll, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _navigateToCategory(int index) {
    _stopGamepadPolling();

    // "About & Debug" is the last item (index depends on platform)
    final aboutIndex = kIsWeb ? 12 : 11;
    if (index == aboutIndex) {
      _showAboutDialog(context);
      if (mounted) _startGamepadPolling();
      return;
    }

    // "Setup Wizard"
    final wizardIndex = kIsWeb ? 10 : 9;
    if (index == wizardIndex) {
      _rerunSetupWizard();
      return;
    }

    // "Language Settings"
    final languageIndex = kIsWeb ? 11 : 10;
    if (index == languageIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSettingsScreen()),
      ).then((_) {
        if (mounted) _startGamepadPolling();
      });
      return;
    }

    late final Widget screen;
    switch (index) {
      case 0:
        screen = const EmulatorManagementScreen();
        break;
      case 1:
        screen = const SystemPathsScreen();
        break;
      case 2:
        screen = const RomDatabaseScreen();
        break;
      case 3:
        screen = const RomStorageManagementScreen();
        break;
      case 4:
        screen = const SystemCheckScreen();
        break;
      case 5:
        screen = const GamepadTestScreen();
        break;
      case 6:
        screen = const BiosHelpScreen();
        break;
      case 7:
        screen = const ArchiveOrgSettingsScreen();
        break;
      case 8:
        // Web Settings (only reachable on web since wizardIndex is 10 on web)
        screen = const WebSettingsScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) async {
      // After returning from Web Settings, reload the proxy URL
      // into the running WebEmulatorService instance
      if (kIsWeb && index == 8) {
        await _reloadCorsProxy();
      }
      if (mounted) _startGamepadPolling();
    });
  }

  /// Reload CORS proxy URL from settings into WebEmulatorService
  Future<void> _reloadCorsProxy() async {
    if (!kIsWeb) return;
    try {
      final corsProxy = await ConfigService.instance.getCorsProxyUrl();
      WebEmulatorService.instance.corsProxyUrl =
          (corsProxy != null && corsProxy.isNotEmpty) ? corsProxy : null;
    } catch (e) {
      DebugService.instance.error(
        'Error reloading CORS proxy: $e',
        tag: 'Settings',
      );
    }
  }

  /// Re-run the setup wizard
  void _rerunSetupWizard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupWizardScreen(
          onComplete: () {
            // Pop back to settings after wizard finishes
            Navigator.pop(context);
          },
        ),
      ),
    ).then((_) {
      if (mounted) _startGamepadPolling();
    });
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
      return KeyEventResult.handled;
    }

    // Handle arrow keys
    if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex - 1) % _categoryCount;
        if (_selectedIndex < 0) _selectedIndex = _categoryCount - 1;
        _scrollToSelected();
      });
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex + 1) % _categoryCount;
        _scrollToSelected();
      });
      return KeyEventResult.handled;
    }

    // Handle Enter/Space to select
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _navigateToCategory(_selectedIndex);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settingsAndConfiguration),
          centerTitle: true,
        ),
        body: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.settingsHeaderTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsHeaderSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Configuration Categories
            _buildCategoryCard(
              context,
              index: 0,
              icon: Icons.videogame_asset,
              title: l10n.emulatorManagement,
              description: l10n.emulatorManagementDesc,
              onTap: () => _navigateToCategory(0),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 1,
              icon: Icons.folder,
              title: l10n.systemPaths,
              description: l10n.systemPathsDesc,
              onTap: () => _navigateToCategory(1),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 2,
              icon: Icons.storage,
              title: l10n.romDatabase,
              description: l10n.romDatabaseDesc,
              onTap: () => _navigateToCategory(2),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 3,
              icon: Icons.folder_special,
              title: l10n.romStorage,
              description: l10n.romStorageDesc,
              onTap: () => _navigateToCategory(3),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 4,
              icon: Icons.check_circle_outline,
              title: l10n.systemRequirements,
              description: l10n.systemRequirementsDesc,
              onTap: () => _navigateToCategory(4),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 5,
              icon: Icons.gamepad,
              title: l10n.gamepadTestDebug,
              description: l10n.gamepadTestDebugDesc,
              onTap: () => _navigateToCategory(5),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 6,
              icon: Icons.memory,
              title: l10n.biosFirmwareHelp,
              description: l10n.biosFirmwareHelpDesc,
              onTap: () => _navigateToCategory(6),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 7,
              icon: Icons.cloud_outlined,
              title: l10n.archiveOrgSettings,
              description: l10n.archiveOrgSettingsDesc,
              onTap: () => _navigateToCategory(7),
            ),
            const SizedBox(height: 12),

            // Web Settings (only shown on web platform)
            if (kIsWeb) ...[
              _buildCategoryCard(
                context,
                index: 8,
                icon: Icons.language,
                title: l10n.webSettings,
                description: l10n.webSettingsDesc,
                onTap: () => _navigateToCategory(8),
              ),
              const SizedBox(height: 12),
            ],

            _buildCategoryCard(
              context,
              index: kIsWeb ? 10 : 9,
              icon: Icons.auto_fix_high,
              title: l10n.setupWizard,
              description: l10n.setupWizardDesc,
              onTap: () => _navigateToCategory(kIsWeb ? 10 : 9),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: kIsWeb ? 11 : 10,
              icon: Icons.language,
              title: l10n.language,
              description: l10n.languageDesc,
              onTap: () => _navigateToCategory(kIsWeb ? 11 : 10),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: kIsWeb ? 12 : 11,
              icon: Icons.info_outline,
              title: l10n.aboutDebug,
              description: l10n.aboutDebugDesc,
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final isSelected = _isGamepadNavigating && _selectedIndex == index;

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          setState(() => _isGamepadNavigating = false);
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aboutForsakenEmulator),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.version} $kAppVersion',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(l10n.appDescription),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    l10n.legalDisclaimer,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        kLegalDisclaimer,
                        style: TextStyle(fontSize: 12, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                l10n.romDatabase,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.romDatabaseCredits,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                'https://github.com/Arley4d/AndroidRoms',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.romDatabaseThanks,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                l10n.biosFilesSection,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.biosFilesCredits, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              const SelectableText(
                'https://github.com/Abdess/retroarch_system',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.biosFilesThanks,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.amigaCopyProtection,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                'https://github.com/rsn8887/capsimg',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.amigaCopyProtectionThanks,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.additionalBiosFiles,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                'https://github.com/PIBSAS/RetroPieBios',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.additionalBiosThanks,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(l10n.debugMode),
                  Text(
                    DebugService.instance.isDebugEnabled
                        ? l10n.enabled
                        : l10n.disabled,
                    style: TextStyle(
                      color: DebugService.instance.isDebugEnabled
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  DebugService.instance.toggleDebug();
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
                child: Text(l10n.toggleDebugMode),
              ),
            ],
          ),
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: l10n.close,
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
}
