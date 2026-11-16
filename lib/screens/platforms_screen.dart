import 'dart:ui';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/emulator_platform.dart';
import '../models/platform_info.dart';
import '../models/rom.dart';
import '../services/rom_service.dart';
import '../services/media_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../services/platform_info_service.dart';
import '../services/collection_service.dart';
import '../services/screen_keyboard_handler.dart';
import '../utils/platform_icons.dart';
import '../widgets/platforms/platform_card.dart';
import '../widgets/common/theme_selector.dart';
import '../widgets/common/help_dialog.dart';
import '../widgets/common/exit_dialog.dart';
import '../widgets/common/smart_svg.dart';
import '../widgets/common/controls_bottom_bar.dart';
import '../widgets/common/app_snackbar.dart';
import '../services/debug_service.dart';
import '../l10n/generated/app_localizations.dart';
import 'roms_screen.dart';
import 'settings_screen.dart';

class PlatformsScreen extends StatefulWidget {
  final RomService romService;

  const PlatformsScreen({super.key, required this.romService});

  @override
  State<PlatformsScreen> createState() => _PlatformsScreenState();
}

class _PlatformsScreenState extends State<PlatformsScreen>
    with WidgetsBindingObserver, RouteAware {
  List<EmulatorPlatform> _platforms = [];
  bool _isLoading = true;
  String? _errorMessage;
  late MediaService _mediaService;
  late KeyboardService _keyboardService;
  late GamepadService _gamepadService;
  late PlatformInfoService _platformInfoService;
  late CollectionService _collectionService;
  late ScreenKeyboardHandler<EmulatorPlatform> _keyboardHandler;
  Timer? _gamepadPollTimer;
  final Map<String, String?> _systemImagesCache = {};
  final Map<String, String?> _systemLogosCache = {};
  final Map<String, String> _systemBackgroundsCache = {};
  final Map<String, PlatformInfo?> _platformInfoCache = {};
  late ScrollController _shelfScrollController;
  late FocusNode _screenFocusNode;
  int _selectedIndex = 0;

  static const double _shelfItemWidth = 152.0;
  static const double _shelfItemSpacing = 14.0;

  @override
  void initState() {
    super.initState();
    _mediaService = MediaService.instance;
    _keyboardService = KeyboardService.instance;
    _gamepadService = GamepadService.instance;
    _platformInfoService = PlatformInfoService.instance;
    _collectionService = CollectionService.instance;
    _shelfScrollController = ScrollController();
    _screenFocusNode = FocusNode();

    // Initialize keyboard handler
    _keyboardHandler = ScreenKeyboardHandler<EmulatorPlatform>(
      keyboardService: _keyboardService,
      config: ScreenKeyboardConfig<EmulatorPlatform>(
        getDisplayName: (platform) => platform.displayName,
        getItems: () => _platforms,
        getCurrentIndex: () => _selectedIndex,
        setCurrentIndex: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
          if (_platforms.isNotEmpty) {
            _ensurePlatformMediaAndInfo(_platforms[newIndex].name);
          }
        },
        getColumns: () => null,
        scrollToIndex: (index, {columns, centerItem = false}) {
          _scrollToShelfIndex(index, centerItem: centerItem);
        },
        onSelect: _handleSelection,
        onBack: _showExitDialog,
        onRefresh: _loadPlatforms,
        onSearch: _showGlobalSearchDialog,
        onShowHelp: _showHelpDialog,
        onCustomShortcut: (key) {
          // Handle settings shortcut (Tab key)
          if (key == LogicalKeyboardKey.tab) {
            _stopGamepadPolling();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ).then((_) {
              if (mounted) {
                _startGamepadPolling();
              }
            });
            return true;
          }
          return false;
        },
      ),
    );

    // Setup gamepad connection callback for NEW connections
    _gamepadService.onGamepadConnected = _onGamepadConnected;

    // Check if gamepad is already connected and show toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _gamepadService.isGamepadConnected) {
        _showGamepadToast('Gamepad');
      }
    });

    _loadPlatforms();
    _startGamepadPolling();
  }

  /// Show gamepad connected toast
  void _showGamepadToast(String gamepadName) {
    if (!mounted) return;

    AppSnackBar.success(
      context,
      '${AppLocalizations.of(context)!.gamepadConnected}: $gamepadName',
      icon: Icons.gamepad,
      duration: const Duration(seconds: 3),
    );
  }

  /// Called when a gamepad is connected
  void _onGamepadConnected(String gamepadName) {
    if (!mounted) return;

    DebugService.instance.info(
      'Gamepad connected: $gamepadName',
      tag: 'PlatformsScreen',
    );

    // Use post-frame callback to ensure ScaffoldMessenger is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showGamepadToast(gamepadName);
      }
    });
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _gamepadService.onGamepadConnected = null; // Clear callback
    _shelfScrollController.dispose();
    _screenFocusNode.dispose();
    super.dispose();
  }

  /// Stop polling gamepad state
  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  /// Start polling gamepad state periodically
  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(
      const Duration(
        milliseconds: 50,
      ), // Reduced from 100ms for better responsiveness
      (_) => _handleGamepadInput(),
    );
  }

  /// Handle gamepad input
  void _handleGamepadInput() {
    if (!_gamepadService.isGamepadConnected) return;
    if (_platforms.isEmpty) return;

    // Handle selection (A button or Start)
    if (_gamepadService.isSelectPressed()) {
      _handleSelection();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle back (B button or Select)
    if (_gamepadService.isBackPressed()) {
      _showExitDialog();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle help (X button for help)
    if (_gamepadService.isHelpPressed()) {
      _showHelpDialog();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle shelf navigation
    _handleGamepadShelfNavigation();

    // Update previous states after handling all inputs
    _gamepadService.updatePreviousButtonStates();
  }

  /// Handle gamepad navigation along the platform shelf
  void _handleGamepadShelfNavigation() {
    final newIndex = _gamepadService.handleCarouselNavigation(
      currentIndex: _selectedIndex,
      itemCount: _platforms.length,
      loop: true,
    );

    if (newIndex != null) {
      setState(() {
        _selectedIndex = newIndex;
      });
      _ensurePlatformMediaAndInfo(_platforms[newIndex].name);
      _scrollToShelfIndex(newIndex);
    }
  }

  Future<void> _loadPlatforms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _systemImagesCache.clear();
      _systemLogosCache.clear();
      _systemBackgroundsCache.clear();
    });

    try {
      // Load collections first
      final collections = await _collectionService.getCollections();

      // Load regular platforms
      final platforms = await widget.romService.loadPlatforms();

      // Convert collections to "virtual" platforms
      final collectionEmulatorPlatforms = collections.map((collection) {
        DebugService.instance.info(
          'Creating platform for collection: ${collection.id}',
          tag: 'PlatformsScreen',
        );
        return EmulatorPlatform(
          name: collection.id, // Use collection ID as platform name
          path: '', // Collections don't have paths
          roms: collection.roms,
          romCount: collection.romCount,
        );
      }).toList();

      DebugService.instance.info(
        'Total collections: ${collectionEmulatorPlatforms.length}',
        tag: 'PlatformsScreen',
      );
      DebugService.instance.info(
        'Total platforms: ${platforms.length}',
        tag: 'PlatformsScreen',
      );

      if (mounted) {
        setState(() {
          // Combine collections + platforms
          _platforms = [...collectionEmulatorPlatforms, ...platforms];
          _isLoading = false;
        });

        DebugService.instance.info(
          'Loaded ${_platforms.length} total platforms',
          tag: 'PlatformsScreen',
        );
        for (var p in _platforms.take(5)) {
          DebugService.instance.debug(
            '   - ${p.name} (${p.displayName})',
            tag: 'PlatformsScreen',
          );
        }

        // Preload media and info for the initial selected platform
        if (_platforms.isNotEmpty) {
          _selectedIndex = _selectedIndex.clamp(0, _platforms.length - 1);
          _ensurePlatformMediaAndInfo(_platforms[_selectedIndex].name);
        }

        // Request focus after loading platforms
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_screenFocusNode.hasFocus) {
            _screenFocusNode.requestFocus();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading platforms: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Check if a platform is actually a collection
  bool _isCollection(EmulatorPlatform platform) {
    return platform.name == 'recently_played' ||
        platform.name == 'downloaded' ||
        platform.name == 'favorites';
  }

  /// Reload only collections (recently played, downloaded, etc.)
  /// without reloading all platforms
  Future<void> _reloadCollections() async {
    try {
      // Load fresh collections
      final collections = await _collectionService.getCollections();

      if (mounted) {
        setState(() {
          // Remove old collection platforms (first items in the list)
          _platforms.removeWhere((p) => _isCollection(p));

          // Add fresh collection platforms at the beginning
          final collectionEmulatorPlatforms = collections.map((collection) {
            return EmulatorPlatform(
              name: collection.id,
              path: '',
              roms: collection.roms,
              romCount: collection.romCount,
            );
          }).toList();

          _platforms.insertAll(0, collectionEmulatorPlatforms);
        });

        DebugService.instance.info(
          'Reloaded collections: ${collections.length}',
          tag: 'PlatformsScreen',
        );
      }
    } catch (e) {
      DebugService.instance.warning(
        'Failed to reload collections: $e',
        tag: 'PlatformsScreen',
      );
    }
  }

  Future<void> _loadSystemImage(String platformName) async {
    if (_systemImagesCache.containsKey(platformName)) {
      return;
    }

    // Load system image
    DebugService.instance.debug(
      'Loading system image for: $platformName',
      tag: 'PlatformsScreen',
    );
    final imagePath = await _mediaService.getSystemImage(platformName);
    DebugService.instance.debug(
      'System image result for $platformName: $imagePath',
      tag: 'PlatformsScreen',
    );

    if (mounted) {
      setState(() {
        _systemImagesCache[platformName] = imagePath;
      });
    }
  }

  Future<void> _loadSystemLogo(String platformName) async {
    // Check if already loaded
    if (_systemLogosCache.containsKey(platformName)) {
      return;
    }

    // Load system logo
    DebugService.instance.debug(
      'Loading system logo for: $platformName',
      tag: 'PlatformsScreen',
    );
    final logoPath = await _mediaService.getSystemLogo(platformName);
    DebugService.instance.debug(
      'System logo result for $platformName: $logoPath',
      tag: 'PlatformsScreen',
    );

    if (mounted) {
      setState(() {
        _systemLogosCache[platformName] = logoPath;
      });
    }
  }

  Future<void> _loadSystemBackground(String platformName) async {
    // Check if already loaded
    if (_systemBackgroundsCache.containsKey(platformName)) {
      return;
    }
    final backgroundPath = await _mediaService.getSystemBackground(
      platformName,
    );
    if (mounted) {
      setState(() {
        _systemBackgroundsCache[platformName] = backgroundPath;
      });
    }
  }

  Future<void> _loadPlatformInfo(String platformName) async {
    if (_platformInfoCache.containsKey(platformName)) {
      return;
    }
    final info = await _platformInfoService.getPlatformInfo(platformName);
    if (mounted) {
      setState(() {
        _platformInfoCache[platformName] = info;
      });
    }
  }

  void _ensurePlatformMediaAndInfo(String platformName) {
    _loadSystemImage(platformName);
    _loadSystemLogo(platformName);
    _loadSystemBackground(platformName);
    _loadPlatformInfo(platformName);
  }

  void _scrollToShelfIndex(int index, {bool centerItem = false}) {
    if (!_shelfScrollController.hasClients) return;

    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 36.0;
    const itemExtent = _shelfItemWidth + _shelfItemSpacing;
    final itemLeft = horizontalPadding + index * itemExtent;
    final itemRight = itemLeft + _shelfItemWidth;

    final currentOffset = _shelfScrollController.offset;
    final viewportWidth = _shelfScrollController.position.viewportDimension;
    final maxScroll = _shelfScrollController.position.maxScrollExtent;
    const edgeMargin = 36.0;

    double? targetOffset;
    if (centerItem) {
      final itemCenter = itemLeft + (_shelfItemWidth / 2);
      targetOffset = (itemCenter - (viewportWidth / 2)).clamp(0.0, maxScroll);
    } else if (itemLeft < currentOffset + edgeMargin) {
      targetOffset = (itemLeft - edgeMargin).clamp(0.0, maxScroll);
    } else if (itemRight > currentOffset + viewportWidth - edgeMargin) {
      targetOffset = (itemRight - viewportWidth + edgeMargin).clamp(
        0.0,
        maxScroll,
      );
    }

    if (targetOffset != null && (targetOffset - currentOffset).abs() > 1.0) {
      _shelfScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
      );
    }
  }

  /// Centralized keyboard event handler - delegates to ScreenKeyboardHandler
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    return _keyboardHandler.handleKeyEvent(event, ScreenViewMode.carousel);
  }

  /// Show help dialog with keyboard shortcuts
  void _showHelpDialog() async {
    _stopGamepadPolling();

    await HelpDialog.show(
      context,
      showSearchShortcut: true,
      showPlatformInfoShortcut: false,
    );

    if (mounted) {
      _startGamepadPolling();
    }
  }

  /// Handle selection of the active platform
  void _handleSelection() {
    if (_platforms.isEmpty) return;
    final selectedPlatform =
        _platforms[_selectedIndex.clamp(0, _platforms.length - 1)];
    _navigateToRoms(selectedPlatform);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/icon.png', width: 24, height: 24),
            const SizedBox(width: 10),
            const Text(
              'Forsaken',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: isMobile
            ? [
                // Mobile: Only hamburger menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Menu',
                  onSelected: (value) {
                    switch (value) {
                      case 'search':
                        _showGlobalSearchDialog();
                        break;
                      case 'refresh':
                        _loadPlatforms();
                        break;
                      case 'settings':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'search',
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.search),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.refresh),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.settings),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : [
                // Desktop: Clean action bar
                const ThemeSelector(),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _showGlobalSearchDialog,
                  tooltip: AppLocalizations.of(context)!.search,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadPlatforms,
                  tooltip: AppLocalizations.of(context)!.refresh,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  tooltip: AppLocalizations.of(context)!.settings,
                ),
              ],
      ),
      body: Stack(
        children: [
          _buildDynamicBackdrop(),
          Column(
            children: [
              Expanded(child: _buildBody()),
              // Bottom bar with controls
              ControlsBottomBar(
                actions: _getBottomBarActions(),
                counterText: _platforms.isEmpty
                    ? null
                    : '${_getCurrentIndex() + 1} / ${_platforms.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicBackdrop() {
    String? bgPath;
    if (_platforms.isNotEmpty) {
      final idx = _getCurrentIndex().clamp(0, _platforms.length - 1);
      bgPath = _systemBackgroundsCache[_platforms[idx].name];
    }

    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: bgPath != null
                ? Image.asset(
                    bgPath,
                    key: ValueKey(bgPath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0B0C10).withValues(alpha: 0.48),
                    const Color(0xFF0B0C10).withValues(alpha: 0.86),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get current selected index
  int _getCurrentIndex() {
    if (_platforms.isEmpty) return 0;
    return _selectedIndex.clamp(0, _platforms.length - 1);
  }

  /// Get bottom bar actions
  List<BottomBarAction> _getBottomBarActions() {
    final l10n = AppLocalizations.of(context)!;
    return [
      BottomBarAction(
        label: l10n.select,
        keyboardKey: 'Enter',
        gamepadButton: 'A',
        icon: Icons.check,
      ),
      BottomBarAction(
        label: l10n.search,
        keyboardKey: 'S',
        gamepadButton: 'Y',
        icon: Icons.search,
      ),
      BottomBarAction(
        label: l10n.refresh,
        keyboardKey: 'R',
        gamepadButton: 'X',
        icon: Icons.refresh,
      ),
      BottomBarAction(
        label: l10n.settings,
        keyboardKey: 'Tab',
        gamepadButton: 'Start',
        icon: Icons.settings,
      ),
    ];
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlatforms,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_platforms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noPlatformsFound),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.checkRomsPath,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final selectedIdx = _getCurrentIndex();
    final selectedPlatform = _platforms[selectedIdx];

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 56),
      child: Focus(
        focusNode: _screenFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) => _handleKeyEvent(event),
        child: Column(
          children: [
            Expanded(
              child: _buildHeroShowcase(selectedPlatform, isMobile: isMobile),
            ),
            _buildPlatformShelf(isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroShowcase(
    EmulatorPlatform platform, {
    required bool isMobile,
  }) {
    // Ensure media & info are loaded for the active platform
    if (!_systemImagesCache.containsKey(platform.name)) {
      _loadSystemImage(platform.name);
    }
    if (!_systemLogosCache.containsKey(platform.name)) {
      _loadSystemLogo(platform.name);
    }
    if (!_systemBackgroundsCache.containsKey(platform.name)) {
      _loadSystemBackground(platform.name);
    }
    if (!_platformInfoCache.containsKey(platform.name)) {
      _loadPlatformInfo(platform.name);
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final imagePath = _systemImagesCache[platform.name];
    final logoPath = _systemLogosCache[platform.name];
    final info = _platformInfoCache[platform.name];

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Platform Logo or Display Name
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Align(
            key: ValueKey('logo_${platform.name}_$logoPath'),
            alignment: Alignment.centerLeft,
            child: logoPath != null
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? 260 : 340,
                      maxHeight: isMobile ? 54 : 74,
                    ),
                    child: _buildLogoImage(
                      logoPath,
                      height: isMobile ? 54 : 72,
                      color: logoPath.contains('/clogos/')
                          ? null
                          : Colors.white,
                      fallback: Text(
                        platform.displayName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Text(
                    platform.displayName,
                    style: (isMobile
                            ? theme.textTheme.headlineSmall
                            : theme.textTheme.headlineLarge)
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: Colors.white,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
        if (info != null && logoPath != null) ...[
          const SizedBox(height: 6),
          Text(
            info.fullName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),
        // Metadata badges (ROM count + manufacturer / year / generation)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildMetaPill(
              icon: Icons.sports_esports_rounded,
              label: l10n.folderRomCount(platform.romCount),
              highlighted: true,
            ),
            if (info != null) ...[
              _buildMetaPill(
                icon: Icons.business_rounded,
                label: info.manufacturer,
              ),
              _buildMetaPill(
                icon: Icons.calendar_today_rounded,
                label: info.releaseYear.toString(),
              ),
              _buildMetaPill(
                icon: Icons.layers_rounded,
                label: info.generationString,
              ),
            ],
          ],
        ),
        if (info != null) ...[
          const SizedBox(height: 14),
          Text(
            info.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.45,
            ),
            maxLines: isMobile ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isMobile) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _buildSpecChip(l10n.cpu, info.cpu),
                _buildSpecChip(l10n.resolution, info.resolution),
                _buildSpecChip(l10n.colors, info.colors),
              ],
            ),
          ],
        ],
        const SizedBox(height: 18),
        ExcludeFocus(
          child: FilledButton.icon(
            onPressed: () => _navigateToRoms(platform),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              l10n.select,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );

    final heroVisual = AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      child: KeyedSubtree(
        key: ValueKey('img_${platform.name}_$imagePath'),
        child: imagePath != null
            ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isMobile ? 130 : 280,
                    maxWidth: isMobile ? 220 : 420,
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackIcon(platform.name, isMobile ? 84 : 128),
                  ),
                ),
              )
            : Center(
                child: _buildFallbackIcon(
                  platform.name,
                  isMobile ? 76 : 116,
                ),
              ),
      ),
    );

    if (isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130, child: heroVisual),
            const SizedBox(height: 12),
            infoColumn,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 16, 36, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: SingleChildScrollView(child: infoColumn),
          ),
          const SizedBox(width: 32),
          Expanded(flex: 4, child: heroVisual),
        ],
      ),
    );
  }

  Widget _buildMetaPill({
    required IconData icon,
    required String label,
    bool highlighted = false,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? primary.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? primary.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: highlighted ? Colors.white : Colors.white.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
              color: Colors.white.withValues(alpha: highlighted ? 1.0 : 0.88),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformShelf({required bool isMobile}) {
    final horizontalPadding = isMobile ? 16.0 : 36.0;
    return SizedBox(
      height: isMobile ? 166 : 196,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent &&
              _shelfScrollController.hasClients) {
            final delta = event.scrollDelta.dy != 0
                ? event.scrollDelta.dy
                : event.scrollDelta.dx;
            final maxScroll = _shelfScrollController.position.maxScrollExtent;
            final target = (_shelfScrollController.offset + delta).clamp(
              0.0,
              maxScroll,
            );
            _shelfScrollController.jumpTo(target);
          }
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          child: ListView.separated(
            controller: _shelfScrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              8,
              horizontalPadding,
              14,
            ),
            itemCount: _platforms.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: _shelfItemSpacing),
            itemBuilder: (context, index) {
              final platform = _platforms[index];
              final isSelected = index == _selectedIndex;
              return SizedBox(
                width: _shelfItemWidth,
                child: PlatformCard(
                  platform: platform,
                  onTap: () {
                    if (!_screenFocusNode.hasFocus) {
                      _screenFocusNode.requestFocus();
                    }
                    if (_selectedIndex != index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _ensurePlatformMediaAndInfo(platform.name);
                      _scrollToShelfIndex(index);
                    } else {
                      _navigateToRoms(platform);
                    }
                  },
                  logoPath: _systemLogosCache[platform.name],
                  backgroundPath: _systemBackgroundsCache[platform.name],
                  onLoadLogo: () => _loadSystemLogo(platform.name),
                  onLoadBackground: () => _loadSystemBackground(platform.name),
                  isSelected: isSelected,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showGlobalSearchDialog() async {
    if (!mounted) return;
    _stopGamepadPolling();

    final query = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: const _GlobalSearchDialog(),
      ),
    );

    if (!mounted) return;
    if (query == null || query.isEmpty) {
      _startGamepadPolling();
      _screenFocusNode.requestFocus();
      return;
    }

    await _executeGlobalSearch(query);
  }

  Future<void> _executeGlobalSearch(String query) async {
    final l10n = AppLocalizations.of(context)!;
    final queryLower = query.toLowerCase();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final matchingRoms = <Rom>[];
    try {
      for (final platform in _platforms) {
        if (_isCollection(platform)) continue;
        final roms = platform.isJsonlPlatform
            ? await widget.romService.loadRomsForJsonlPlatform(platform.name)
            : platform.roms;
        for (final rom in roms) {
          if (rom.displayName.toLowerCase().contains(queryLower) ||
              rom.name.toLowerCase().contains(queryLower)) {
            matchingRoms.add(rom);
          }
        }
      }
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    if (!mounted) return;

    if (matchingRoms.isEmpty) {
      AppSnackBar.info(
        context,
        '${l10n.noRomsFound}: "$query"',
        icon: Icons.search_off,
      );
      _startGamepadPolling();
      _screenFocusNode.requestFocus();
      return;
    }

    final searchPlatform = EmulatorPlatform(
      name: 'search_results',
      customDisplayName: '${l10n.search}: "$query"',
      path: '',
      roms: matchingRoms,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RomsScreen(
          platform: searchPlatform,
          romService: widget.romService,
          isCollection: true,
        ),
      ),
    );

    if (mounted) {
      await _reloadCollections();
      _startGamepadPolling();
      _screenFocusNode.requestFocus();
    }
  }

  void _navigateToRoms(EmulatorPlatform platform) async {
    final isCollection = _isCollection(platform);

    // Stop gamepad polling to avoid handler overlap
    _stopGamepadPolling();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RomsScreen(
          platform: platform,
          romService: widget.romService,
          isCollection: isCollection,
        ),
      ),
    );

    // Resume gamepad polling when returning
    if (mounted) {
      _startGamepadPolling();
      if (!_screenFocusNode.hasFocus) {
        _screenFocusNode.requestFocus();
      }

      // Reload collections (recently played, downloaded) to show any new additions
      // This ensures that if a game was just played, it appears in "Recently Played"
      await _reloadCollections();
    }
  }

  Future<void> _showExitDialog() async {
    // Pause gamepad polling while dialog is open
    _stopGamepadPolling();

    final shouldExit = await ExitDialog.show(context);

    // Resume gamepad polling after dialog closes
    if (mounted) {
      _startGamepadPolling();
    }

    if (shouldExit && mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildLogoImage(
    String logoPath, {
    required double height,
    Color? color,
    Widget? fallback,
  }) {
    final isSvg =
        logoPath.toLowerCase().endsWith('.svg') ||
        logoPath.toLowerCase().endsWith('.svgz');

    if (isSvg) {
      return SmartSvg.asset(
        logoPath,
        height: height,
        fit: BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
        placeholderBuilder: fallback != null ? (context) => fallback : null,
      );
    } else {
      return Image.asset(
        logoPath,
        height: height,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
        errorBuilder: fallback != null
            ? (context, error, stackTrace) => fallback
            : null,
      );
    }
  }

  Widget _buildFallbackIcon(String platformName, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          _getEmulatorPlatformIcon(platformName),
          size: size * 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  IconData _getEmulatorPlatformIcon(String platformName) {
    return PlatformIcons.getIconForPlatform(platformName);
  }
}

class _GlobalSearchDialog extends StatefulWidget {
  const _GlobalSearchDialog();

  @override
  State<_GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends State<_GlobalSearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: const Color(0xFF161822),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      title: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 10),
          Text(l10n.search),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchGamesHint,
            prefixIcon: const Icon(Icons.videogame_asset_rounded),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          onSubmitted: (value) {
            Navigator.of(context).pop(value.trim());
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: () =>
              Navigator.of(context).pop(_controller.text.trim()),
          icon: const Icon(Icons.search, size: 18),
          label: Text(l10n.search),
        ),
      ],
    );
  }
}
