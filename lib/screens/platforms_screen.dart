import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/platform.dart';
import '../services/rom_service.dart';
import '../services/media_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../services/platform_info_service.dart';
import '../services/collection_service.dart';
import '../services/screen_keyboard_handler.dart';
import '../utils/platform_icons.dart';
import '../widgets/platforms/platform_card.dart';
import '../widgets/platforms/platform_info_dialog.dart';
import '../widgets/common/theme_selector.dart';
import '../widgets/common/help_dialog.dart';
import '../widgets/common/exit_dialog.dart';
import '../widgets/common/smart_svg.dart';
import '../widgets/common/controls_bottom_bar.dart';
import '../services/debug_service.dart';
import 'roms_screen.dart';
import 'settings_screen.dart';

enum ViewMode { grid, carousel }

class PlatformsScreen extends StatefulWidget {
  final RomService romService;

  const PlatformsScreen({super.key, required this.romService});

  @override
  State<PlatformsScreen> createState() => _PlatformsScreenState();
}

class _PlatformsScreenState extends State<PlatformsScreen>
    with WidgetsBindingObserver, RouteAware {
  List<Platform> _platforms = [];
  bool _isLoading = true;
  String? _errorMessage;
  late MediaService _mediaService;
  late KeyboardService _keyboardService;
  late GamepadService _gamepadService;
  late PlatformInfoService _platformInfoService;
  late CollectionService _collectionService;
  late ScreenKeyboardHandler<Platform> _keyboardHandler;
  Timer? _gamepadPollTimer;
  final Map<String, String?> _systemImagesCache = {};
  final Map<String, String?> _systemLogosCache = {};
  final Map<String, String> _systemBackgroundsCache = {};
  ViewMode _viewMode = ViewMode.carousel;
  late PageController _carouselController;
  late ScrollController _gridScrollController;
  late FocusNode _carouselFocusNode;
  late FocusNode _gridFocusNode;
  int _carouselCurrentIndex = 0;
  int _gridSelectedIndex = 0;
  bool _showNavigationHint = true;

  @override
  void initState() {
    super.initState();
    final mediaPath = dotenv.env['MEDIA_PATH'] ?? '';
    _mediaService = MediaService(mediaBasePath: mediaPath);
    _keyboardService = KeyboardService.instance;
    _gamepadService = GamepadService.instance;
    _platformInfoService = PlatformInfoService.instance;
    _collectionService = CollectionService.instance;
    _carouselController = PageController();
    _gridScrollController = ScrollController();
    _carouselFocusNode = FocusNode();
    _gridFocusNode = FocusNode();

    // Initialize keyboard handler
    _keyboardHandler = ScreenKeyboardHandler<Platform>(
      keyboardService: _keyboardService,
      config: ScreenKeyboardConfig<Platform>(
        getDisplayName: (platform) => platform.name,
        getItems: () => _platforms,
        getCurrentIndex: () => _viewMode == ViewMode.grid
            ? _gridSelectedIndex
            : _carouselCurrentIndex,
        setCurrentIndex: (newIndex) {
          setState(() {
            if (_viewMode == ViewMode.grid) {
              _gridSelectedIndex = newIndex;
            } else {
              _carouselCurrentIndex = newIndex;
            }
          });
        },
        getColumns: () => _viewMode == ViewMode.grid
            ? _calculateCrossAxisCount(context)
            : null,
        scrollToIndex: (index, {columns, centerItem = false}) {
          if (_viewMode == ViewMode.grid) {
            _scrollToIndex(index, columns ?? _calculateCrossAxisCount(context));
          } else {
            _carouselController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        onSelect: _handleSelection,
        onBack: _showExitDialog,
        onRefresh: _loadPlatforms,
        onToggleView: _toggleViewMode,
        onShowHelp: _showHelpDialog,
        onHideNavigationHint: _hideNavigationHint,
        onCustomShortcut: (key) {
          // Handle platform info shortcut (I key)
          if (key == LogicalKeyboardKey.keyI) {
            _showPlatformInfo();
            return true;
          }
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎮 Mando conectado: $gamepadName'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
      ),
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
    _carouselController.dispose();
    _gridScrollController.dispose();
    _carouselFocusNode.dispose();
    _gridFocusNode.dispose();
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

    // Handle view toggle (Y button)
    if (_gamepadService.isViewTogglePressed()) {
      _toggleViewMode();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle help (X button for help)
    if (_gamepadService.isHelpPressed()) {
      _showHelpDialog();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle navigation
    if (_viewMode == ViewMode.grid) {
      _handleGamepadGridNavigation();
    } else {
      _handleGamepadCarouselNavigation();
    }

    // Update previous states after handling all inputs
    _gamepadService.updatePreviousButtonStates();
  }

  /// Handle gamepad navigation in grid mode
  void _handleGamepadGridNavigation() {
    final columns = _calculateCrossAxisCount(context);
    final newIndex = _gamepadService.handleGridNavigation(
      currentIndex: _gridSelectedIndex,
      itemCount: _platforms.length,
      columns: columns,
    );

    if (newIndex != null) {
      setState(() {
        _gridSelectedIndex = newIndex;
      });
      _scrollToIndex(newIndex, columns);
    }
  }

  /// Handle gamepad navigation in carousel mode
  void _handleGamepadCarouselNavigation() {
    final newIndex = _gamepadService.handleCarouselNavigation(
      currentIndex: _carouselCurrentIndex,
      itemCount: _platforms.length,
      loop: true,
    );

    if (newIndex != null) {
      _hideNavigationHint();
      _carouselController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
      final collectionPlatforms = collections.map((collection) {
        DebugService.instance.info(
          'Creating platform for collection: ${collection.id}',
          tag: 'PlatformsScreen',
        );
        return Platform(
          name: collection.id, // Use collection ID as platform name
          path: '', // Collections don't have paths
          roms: collection.roms,
          romCount: collection.romCount,
        );
      }).toList();

      DebugService.instance.info(
        'Total collections: ${collectionPlatforms.length}',
        tag: 'PlatformsScreen',
      );
      DebugService.instance.info(
        'Total platforms: ${platforms.length}',
        tag: 'PlatformsScreen',
      );

      if (mounted) {
        setState(() {
          // Combine collections + platforms
          _platforms = [...collectionPlatforms, ...platforms];
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

        // Request focus after loading platforms
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _requestFocusForCurrentViewMode();
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
  bool _isCollection(Platform platform) {
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
          final collectionPlatforms = collections.map((collection) {
            return Platform(
              name: collection.id,
              path: '',
              roms: collection.roms,
              romCount: collection.romCount,
            );
          }).toList();

          _platforms.insertAll(0, collectionPlatforms);
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

    // Load system background (always returns a path, default if not found)
    DebugService.instance.debug(
      'Loading system background for: $platformName',
      tag: 'PlatformsScreen',
    );
    final backgroundPath = await _mediaService.getSystemBackground(
      platformName,
    );
    DebugService.instance.debug(
      'System background result for $platformName: $backgroundPath',
      tag: 'PlatformsScreen',
    );

    if (mounted) {
      setState(() {
        _systemBackgroundsCache[platformName] = backgroundPath;
      });
    }
  }

  void _scrollToIndex(int index, int columns) {
    if (!_gridScrollController.hasClients) return;

    // Calculate item dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 16 * 2 - 16 * (columns - 1)) / columns;
    final itemHeight = itemWidth / 0.8; // Based on childAspectRatio

    // Calculate row
    final row = index ~/ columns;
    final rowOffset = row * (itemHeight + 16); // item height + spacing

    // Get viewport height
    final viewportHeight = _gridScrollController.position.viewportDimension;
    final currentScroll = _gridScrollController.offset;
    final maxScroll = _gridScrollController.position.maxScrollExtent;

    // Calculate item position in viewport
    final itemTop = rowOffset;
    final itemBottom = rowOffset + itemHeight;

    // Check if item is outside viewport
    if (itemTop < currentScroll) {
      // Item is above viewport, scroll up
      _gridScrollController.animateTo(
        itemTop - 16, // Add some padding
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (itemBottom > currentScroll + viewportHeight) {
      // Item is below viewport, scroll down
      final targetScroll = itemBottom - viewportHeight + 16;
      _gridScrollController.animateTo(
        targetScroll.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleViewMode() {
    setState(() {
      if (_viewMode == ViewMode.grid) {
        _viewMode = ViewMode.carousel;
        _carouselCurrentIndex = 0;
        _carouselController = PageController();
      } else {
        _viewMode = ViewMode.grid;
      }
    });

    // Request focus for the new view mode after the widget rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _requestFocusForCurrentViewMode();
      }
    });
  }

  /// Request focus for the current view mode's FocusNode
  void _requestFocusForCurrentViewMode() {
    switch (_viewMode) {
      case ViewMode.grid:
        if (!_gridFocusNode.hasFocus) {
          _gridFocusNode.requestFocus();
        }
        break;
      case ViewMode.carousel:
        if (!_carouselFocusNode.hasFocus) {
          _carouselFocusNode.requestFocus();
        }
        break;
    }
  }

  /// Centralized keyboard event handler - delegates to ScreenKeyboardHandler
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    final viewMode = _viewMode == ViewMode.grid
        ? ScreenViewMode.grid
        : ScreenViewMode.carousel;
    return _keyboardHandler.handleKeyEvent(event, viewMode);
  }

  /// Show help dialog with keyboard shortcuts
  void _showHelpDialog() async {
    // Pause gamepad polling while dialog is open
    _stopGamepadPolling();

    await HelpDialog.show(
      context,
      showSearchShortcut: false,
      showPlatformInfoShortcut: true,
    );

    // Resume gamepad polling after dialog closes
    if (mounted) {
      _startGamepadPolling();
    }
  }

  /// Show platform information dialog
  Future<void> _showPlatformInfo() async {
    final selectedPlatform = _viewMode == ViewMode.grid
        ? _platforms[_gridSelectedIndex]
        : _platforms[_carouselCurrentIndex];

    final platformInfo = await _platformInfoService.getPlatformInfo(
      selectedPlatform.name,
    );

    if (platformInfo != null && mounted) {
      PlatformInfoDialog.show(context, selectedPlatform.name, platformInfo);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No hay información disponible para ${selectedPlatform.displayName}',
          ),
        ),
      );
    }
  }

  /// Handle selection based on current view mode
  void _handleSelection() {
    final selectedPlatform = _viewMode == ViewMode.grid
        ? _platforms[_gridSelectedIndex]
        : _platforms[_carouselCurrentIndex];
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
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),
        ),
        title: Image.asset('assets/images/icon.png', width: 24, height: 24),
        actions: isMobile
            ? [
                // Mobile: Only hamburger menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Menu',
                  onSelected: (value) {
                    switch (value) {
                      case 'platform_info':
                        _showPlatformInfo();
                        break;
                      case 'toggle_view':
                        _toggleViewMode();
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
                    if (_platforms.isNotEmpty)
                      const PopupMenuItem(
                        value: 'platform_info',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline),
                            SizedBox(width: 12),
                            Text('Platform Info'),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'toggle_view',
                      child: Row(
                        children: [
                          Icon(
                            _viewMode == ViewMode.grid
                                ? Icons.view_carousel
                                : Icons.grid_view,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _viewMode == ViewMode.grid
                                ? 'Carousel View'
                                : 'Grid View',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 12),
                          Text('Refresh'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : [
                // Desktop: Show all actions as icon buttons
                const ThemeSelector(),
                if (_platforms.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: _showPlatformInfo,
                    tooltip: 'Platform Info (I)',
                  ),
                IconButton(
                  icon: Icon(
                    _viewMode == ViewMode.grid
                        ? Icons.view_carousel
                        : Icons.grid_view,
                  ),
                  onPressed: _toggleViewMode,
                  tooltip: _viewMode == ViewMode.grid
                      ? 'Carousel View'
                      : 'Grid View',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadPlatforms,
                  tooltip: 'Refresh',
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
                  tooltip: 'Settings',
                ),
              ],
      ),
      body: Column(
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
    );
  }

  /// Get current selected index based on view mode
  int _getCurrentIndex() {
    return _viewMode == ViewMode.carousel
        ? _carouselCurrentIndex
        : _gridSelectedIndex;
  }

  /// Get bottom bar actions based on current view mode
  List<BottomBarAction> _getBottomBarActions() {
    return [
      const BottomBarAction(
        label: 'Select',
        keyboardKey: 'Enter',
        gamepadButton: 'A',
        icon: Icons.check,
      ),
      const BottomBarAction(
        label: 'Info',
        keyboardKey: 'I',
        gamepadButton: 'Y',
        icon: Icons.info_outline,
      ),
      const BottomBarAction(
        label: 'View',
        keyboardKey: 'V',
        gamepadButton: 'R3',
        icon: Icons.view_carousel,
      ),
      const BottomBarAction(
        label: 'Refresh',
        keyboardKey: 'R',
        gamepadButton: 'X',
        icon: Icons.refresh,
      ),
      const BottomBarAction(
        label: 'Settings',
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
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_platforms.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No platforms found'),
            SizedBox(height: 8),
            Text(
              'Check your ROMS_PATH environment variable',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_viewMode == ViewMode.carousel) {
      return _buildCarouselView();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Focus(
        focusNode: _gridFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) => _handleKeyEvent(event),
        child: GridView.builder(
          controller: _gridScrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _platforms.length,
          itemBuilder: (context, index) {
            final platform = _platforms[index];
            return PlatformCard(
              platform: platform,
              onTap: () => _navigateToRoms(platform),
              logoPath: _systemLogosCache[platform.name],
              backgroundPath: _systemBackgroundsCache[platform.name],
              onLoadLogo: () => _loadSystemLogo(platform.name),
              onLoadBackground: () => _loadSystemBackground(platform.name),
              isSelected: index == _gridSelectedIndex,
            );
          },
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
  }

  void _navigateToRoms(Platform platform) async {
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

  Widget _buildCarouselView() {
    return Focus(
      focusNode: _carouselFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Stack(
        children: [
          PageView.builder(
            controller: _carouselController,
            itemCount: _platforms.length,
            onPageChanged: (index) {
              setState(() {
                _carouselCurrentIndex = index;
                _hideNavigationHint();
              });
            },
            itemBuilder: (context, index) {
              final platform = _platforms[index];
              return _buildCarouselItem(platform);
            },
          ),
          // Navigation hint (only show initially)
          if (_showNavigationHint)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Use arrow keys or swipe to navigate',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _hideNavigationHint() {
    if (_showNavigationHint) {
      setState(() {
        _showNavigationHint = false;
      });
    }
  }

  Widget _buildCarouselItem(Platform platform) {
    // Trigger lazy loading of image and logo
    if (!_systemImagesCache.containsKey(platform.name)) {
      _loadSystemImage(platform.name);
    }
    if (!_systemLogosCache.containsKey(platform.name)) {
      _loadSystemLogo(platform.name);
    }
    if (!_systemBackgroundsCache.containsKey(platform.name)) {
      _loadSystemBackground(platform.name);
    }

    final imagePath = _systemImagesCache[platform.name];
    final logoPath = _systemLogosCache[platform.name];
    final backgroundPath = _systemBackgroundsCache[platform.name];

    return Stack(
      children: [
        // Background image
        if (backgroundPath != null)
          Positioned.fill(
            child: Image.asset(
              backgroundPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large system image
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: imagePath != null
                      ? Image.asset(
                          imagePath,
                          width: MediaQuery.of(context).size.width * 0.40,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildFallbackIcon(platform.name, 200);
                          },
                        )
                      : _buildFallbackIcon(platform.name, 200),
                ),
              ),
              // Platform info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Column(
                  children: [
                    // Platform name/logo
                    _buildPlatformNameOrLogo(platform, logoPath),
                    const SizedBox(height: 16),
                    // ROM count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${platform.romCount} ROMs',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformNameOrLogo(Platform platform, String? logoPath) {
    if (logoPath != null) {
      final isColorLogo = logoPath.contains('/clogos/');
      Color? logoColor;
      if (!isColorLogo) {
        final brightness = Theme.of(context).brightness;
        logoColor = brightness == Brightness.light
            ? Colors.black
            : Colors.white;
      }

      return _buildLogoImage(
        logoPath,
        height: 80,
        color: logoColor,
        fallback: _buildPlatformNameText(platform),
      );
    } else {
      // No logo found, use text
      return _buildPlatformNameText(platform);
    }
  }

  Widget _buildPlatformNameText(Platform platform) {
    return Text(
      platform.displayName,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
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
          _getPlatformIcon(platformName),
          size: size * 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platformName) {
    return PlatformIcons.getIconForPlatform(platformName);
  }
}
