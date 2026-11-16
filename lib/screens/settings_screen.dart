import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'settings_categories/emulator_management_screen.dart';
import 'settings_categories/system_paths_screen.dart';
import 'settings_categories/rom_database_screen.dart';
import 'settings_categories/rom_storage_management_screen.dart';
import 'settings_categories/system_check_screen.dart';
import 'settings_categories/system_utilities_screen.dart';
import 'settings_categories/gamepad_test_screen.dart';
import 'settings_categories/bios_help_screen.dart';
import 'settings_categories/archive_org_settings_screen.dart';
import 'settings_categories/web_settings_screen.dart';
import 'settings_categories/language_settings_screen.dart';
import 'settings_categories/about_screen.dart';
import 'settings_categories/debug_settings_screen.dart';
import 'setup_wizard_screen.dart';
import '../services/debug_service.dart';
import '../services/config_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../l10n/generated/app_localizations.dart';

// Web-specific import (conditional for web platform)
import '../platforms/web/web_emulator_service.dart'
    if (dart.library.io) 'package:forsaken/services/empty_stub.dart';
import '../widgets/common/animated_lucide_icon.dart';
import '../widgets/common/controls_bottom_bar.dart';

class _SettingsSectionData {
  const _SettingsSectionData({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_SettingsItemData> items;
}

class _SettingsItemData {
  const _SettingsItemData({
    required this.iconType,
    required this.accentColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final AnimatedLucideIconType iconType;
  final Color accentColor;
  final String title;
  final String description;
  final VoidCallback onTap;
}

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
  final List<GlobalKey> _itemKeys = [];
  Timer? _gamepadPollTimer;
  int _selectedIndex = 0;
  int? _hoveredIndex;
  bool _isGamepadNavigating = false;

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

  List<_SettingsSectionData> _buildSections(AppLocalizations l10n) {
    return [
      _SettingsSectionData(
        title: l10n.emulators,
        items: [
          _SettingsItemData(
            iconType: AnimatedLucideIconType.gamepad,
            accentColor: const Color(0xFF0A84FF),
            title: l10n.emulatorManagement,
            description: l10n.emulatorManagementDesc,
            onTap: () => _pushScreen(const EmulatorManagementScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.database,
            accentColor: const Color(0xFF0A84FF),
            title: l10n.romDatabase,
            description: l10n.romDatabaseDesc,
            onTap: () => _pushScreen(const RomDatabaseScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.cpu,
            accentColor: const Color(0xFF5E5CE6),
            title: l10n.biosFirmwareHelp,
            description: l10n.biosFirmwareHelpDesc,
            onTap: () => _pushScreen(const BiosHelpScreen()),
          ),
        ],
      ),
      _SettingsSectionData(
        title: l10n.storage,
        items: [
          _SettingsItemData(
            iconType: AnimatedLucideIconType.folder,
            accentColor: const Color(0xFF30D158),
            title: l10n.systemPaths,
            description: l10n.systemPathsDesc,
            onTap: () => _pushScreen(const SystemPathsScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.folderCheck,
            accentColor: const Color(0xFF30D158),
            title: l10n.romStorage,
            description: l10n.romStorageDesc,
            onTap: () => _pushScreen(const RomStorageManagementScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.cloudDownload,
            accentColor: const Color(0xFF64D2FF),
            title: l10n.archiveOrgSettings,
            description: l10n.archiveOrgSettingsDesc,
            onTap: () => _pushScreen(const ArchiveOrgSettingsScreen()),
          ),
          if (kIsWeb)
            _SettingsItemData(
              iconType: AnimatedLucideIconType.globe,
              accentColor: const Color(0xFF64D2FF),
              title: l10n.webSettings,
              description: l10n.webSettingsDesc,
              onTap: () => _pushScreen(
                const WebSettingsScreen(),
                onReturn: _reloadCorsProxy,
              ),
            ),
        ],
      ),
      _SettingsSectionData(
        title: l10n.system,
        items: [
          _SettingsItemData(
            iconType: AnimatedLucideIconType.shieldCheck,
            accentColor: const Color(0xFFFF9F0A),
            title: l10n.systemRequirements,
            description: l10n.systemRequirementsDesc,
            onTap: () => _pushScreen(const SystemCheckScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.wrench,
            accentColor: const Color(0xFFFF9F0A),
            title: l10n.systemUtilities,
            description: l10n.maintenanceTools,
            onTap: () => _pushScreen(const SystemUtilitiesScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.gamepad,
            accentColor: const Color(0xFFFF9F0A),
            title: l10n.gamepadTestDebug,
            description: l10n.gamepadTestDebugDesc,
            onTap: () => _pushScreen(const GamepadTestScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.bug,
            accentColor: const Color(0xFFFF9F0A),
            title: l10n.debugMode.replaceAll(':', '').trim(),
            description: l10n.toggleDebugMode,
            onTap: () => _pushScreen(const DebugSettingsScreen()),
          ),
        ],
      ),
      _SettingsSectionData(
        title: l10n.generalInformation,
        items: [
          _SettingsItemData(
            iconType: AnimatedLucideIconType.languages,
            accentColor: const Color(0xFFBF5AF2),
            title: l10n.language,
            description: l10n.languageDesc,
            onTap: () => _pushScreen(const LanguageSettingsScreen()),
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.wandSparkles,
            accentColor: const Color(0xFFBF5AF2),
            title: l10n.setupWizard,
            description: l10n.setupWizardDesc,
            onTap: _rerunSetupWizard,
          ),
          _SettingsItemData(
            iconType: AnimatedLucideIconType.info,
            accentColor: const Color(0xFF8E8E93),
            title: l10n.aboutForsakenEmulator,
            description: l10n.appDescription,
            onTap: () => _pushScreen(const AboutScreen()),
          ),
        ],
      ),
    ];
  }

  void _pushScreen(Widget screen, {Future<void> Function()? onReturn}) {
    _stopGamepadPolling();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) async {
      if (onReturn != null) {
        await onReturn();
      }
      if (mounted) _startGamepadPolling();
    });
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      final items = _buildSections(l10n).expand((s) => s.items).toList();
      final count = items.length;
      if (count == 0) return;

      // Navigation
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        setState(() {
          _isGamepadNavigating = true;
          if (direction == 'up') {
            _selectedIndex = (_selectedIndex - 1 + count) % count;
          } else if (direction == 'down') {
            _selectedIndex = (_selectedIndex + 1) % count;
          }
        });
        _scrollToSelected();
      }

      // Buttons
      if (gamepad.isSelectPressed()) {
        items[_selectedIndex.clamp(0, count - 1)].onTap();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedIndex < 0 || _selectedIndex >= _itemKeys.length) {
        return;
      }
      final ctx = _itemKeys[_selectedIndex].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.5,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
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
    _pushScreen(
      SetupWizardScreen(
        onComplete: () {
          // Pop back to settings after wizard finishes
          Navigator.pop(context);
        },
      ),
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, List<_SettingsItemData> items) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
      return KeyEventResult.handled;
    }

    if (items.isEmpty) return KeyEventResult.ignored;

    // Handle arrow keys
    if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex - 1 + items.length) % items.length;
      });
      _scrollToSelected();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex + 1) % items.length;
      });
      _scrollToSelected();
      return KeyEventResult.handled;
    }

    // Handle Enter/Space to select
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      items[_selectedIndex.clamp(0, items.length - 1)].onTap();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = _buildSections(l10n);
    final allItems = sections.expand((s) => s.items).toList();
    while (_itemKeys.length < allItems.length) {
      _itemKeys.add(GlobalKey());
    }
    if (_selectedIndex >= allItems.length) {
      _selectedIndex = 0;
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event, allItems),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settingsAndConfiguration),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 900 && sections.length == 4) {
                    return _buildWideTwoByTwo(context, sections);
                  }
                  return _buildNarrowList(context, sections);
                },
              ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: l10n.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: l10n.select,
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

  Widget _buildWideTwoByTwo(
    BuildContext context,
    List<_SettingsSectionData> sections,
  ) {
    final s0Start = 0;
    final s1Start = sections[0].items.length;
    final s2Start = s1Start + sections[1].items.length;
    final s3Start = s2Start + sections[2].items.length;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionGroup(
                      context,
                      section: sections[0],
                      startIndex: s0Start,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildSectionGroup(
                      context,
                      section: sections[1],
                      startIndex: s1Start,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionGroup(
                      context,
                      section: sections[2],
                      startIndex: s2Start,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildSectionGroup(
                      context,
                      section: sections[3],
                      startIndex: s3Start,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowList(
    BuildContext context,
    List<_SettingsSectionData> sections,
  ) {
    int runningIndex = 0;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: sections.length,
          separatorBuilder: (_, _) => const SizedBox(height: 20),
          itemBuilder: (context, sectionIdx) {
            final section = sections[sectionIdx];
            final startIndex = runningIndex;
            runningIndex += section.items.length;
            return _buildSectionGroup(
              context,
              section: section,
              startIndex: startIndex,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionGroup(
    BuildContext context, {
    required _SettingsSectionData section,
    required int startIndex,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 8),
          child: Text(
            section.title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.9,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.14),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < section.items.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 66,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                _buildCategoryRow(
                  context,
                  index: startIndex + i,
                  item: section.items[i],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    BuildContext context, {
    required int index,
    required _SettingsItemData item,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _isGamepadNavigating && _selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    final shouldAnimate = isSelected || isHovered;

    return Material(
      key: _itemKeys[index],
      color: isSelected
          ? colorScheme.primary.withValues(alpha: 0.14)
          : Colors.transparent,
      child: InkWell(
        onHover: (hovering) {
          setState(() {
            if (hovering) {
              _hoveredIndex = index;
            } else if (_hoveredIndex == index) {
              _hoveredIndex = null;
            }
          });
        },
        onTap: () {
          setState(() => _isGamepadNavigating = false);
          item.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.accentColor
                      : item.accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AnimatedLucideIcon(
                    type: item.iconType,
                    size: 20,
                    color: isSelected ? Colors.white : item.accentColor,
                    animate: shouldAnimate,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
