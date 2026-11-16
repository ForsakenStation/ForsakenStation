import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'roms/roms_carousel_view.dart';
import 'roms/roms_grid_view.dart';
import 'roms/roms_list_view.dart';
import 'roms/utils/scroll_utils.dart';
import 'roms/utils/bottom_bar_actions.dart';
import 'roms/controllers/roms_screen_controller.dart';
import 'roms/handlers/rom_launcher.dart';
import 'roms/handlers/rom_save_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/emulator_platform.dart';
import '../models/rom_item.dart';
import '../services/debug_service.dart';
import '../services/rom_service.dart';
import '../services/media_service.dart';
import '../services/emulator_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../services/gamelist_service.dart';
import '../services/screen_keyboard_handler.dart';
import '../services/config_service.dart';
import '../widgets/common/help_dialog.dart';
import '../widgets/common/controls_bottom_bar.dart';
import '../widgets/common/app_snackbar.dart';
import '../widgets/common/smart_svg.dart';
import '../widgets/roms/fullscreen_image_viewer.dart';
import '../widgets/roms/rom_detail_dialog.dart';
import '../l10n/generated/app_localizations.dart';
import 'settings_screen.dart';

import 'roms/widgets/roms_header.dart';
import 'roms/widgets/roms_search_overlay.dart';
import 'roms/widgets/roms_empty_state.dart';

class RomsScreen extends StatefulWidget {
  final EmulatorPlatform platform;
  final RomService romService;
  final bool isCollection; // True if this is a collection view

  const RomsScreen({
    super.key,
    required this.platform,
    required this.romService,
    this.isCollection = false,
  });

  @override
  State<RomsScreen> createState() => _RomsScreenState();
}

class _RomsScreenState extends State<RomsScreen> {
  String _currentPath = '';
  String? _currentSubdirectory; // For JSONL platforms: current subdirectory
  final List<String> _pathHistory = [];
  ScreenViewMode _viewMode = ScreenViewMode.list;
  late MediaService _mediaService;
  late EmulatorService _emulatorService;
  late KeyboardService _keyboardService;
  late GamepadService _gamepadService;
  late GamelistService _gamelistService;
  late RomsScreenController _controller;
  late RomLauncher _romLauncher;
  late RomSaveHandler _romSaveHandler;
  late ScreenKeyboardHandler<RomItem> _keyboardHandler;
  late ScrollController _carouselController;
  late ScrollController _gridScrollController;
  late ScrollController _listScrollController;
  late FocusNode _carouselFocusNode;
  late FocusNode _gridFocusNode;
  late FocusNode _listFocusNode;
  String? _platformBackgroundPath;
  Widget? _cachedLogoWidget; // Cache del logo para evitar rebuilds
  Timer? _gamepadPollTimer;
  final _debug = DebugService.instance;

  // EmulatorPlatform navigation support
  List<EmulatorPlatform>? _allEmulatorPlatforms;
  int? _currentEmulatorPlatformIndex;

  // Search/filter functionality
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchMode = false;
  bool _showVirtualKeyboard = false;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.platform.path;
    _currentSubdirectory = null; // Start at root for JSONL platforms

    // Initialize services synchronously
    _mediaService = MediaService.instance;
    _emulatorService = EmulatorService.instance;
    _keyboardService = KeyboardService.instance;
    _gamepadService = GamepadService.instance;

    // Initialize gamelist service with empty path temporarily
    _gamelistService = GamelistService(gamelistBasePath: '');

    _controller = RomsScreenController(
      mediaService: _mediaService,
      gamelistService: _gamelistService,
      romService: widget.romService,
    );
    _controller.addListener(_onControllerUpdate);

    _romLauncher = RomLauncher(
      emulatorService: _emulatorService,
      mediaService: _mediaService,
      platformName: widget.platform.name,
      platformDisplayName: widget.platform.displayName,
      mediaCache: _controller.mediaCache,
      requestFocus: _requestFocusForCurrentViewMode,
      isCollection: widget.isCollection,
    );
    _romSaveHandler = RomSaveHandler(
      platformName: widget.platform.name,
      requestFocus: _requestFocusForCurrentViewMode,
      isCollection: widget.isCollection,
      mediaService: _mediaService,
      mediaCache: _controller.mediaCache,
    );

    // Update gamelist service with correct path asynchronously
    _initializeGamelistService();

    _carouselController = ScrollController();
    _gridScrollController = ScrollController();
    _listScrollController = ScrollController();
    _carouselFocusNode = FocusNode();
    _gridFocusNode = FocusNode();
    _listFocusNode = FocusNode();

    // Initialize keyboard handler
    _keyboardHandler = ScreenKeyboardHandler<RomItem>(
      keyboardService: _keyboardService,
      config: ScreenKeyboardConfig<RomItem>(
        getDisplayName: (item) => item.displayName,
        getItems: () => _controller.filteredItems,
        getCurrentIndex: () => _controller.selectedIndex,
        setCurrentIndex: (index) {
          _controller.selectedIndex = index;
        },
        getColumns: () => _calculateCrossAxisCount(context),
        scrollToIndex: (index, {columns, centerItem = false}) {
          if (_viewMode == ScreenViewMode.grid) {
            _scrollToIndexInGrid(index, columns!, centerItem: centerItem);
          } else if (_viewMode == ScreenViewMode.list) {
            _scrollToIndexInList(index, centerItem: centerItem);
          } else {
            _scrollToCarouselIndex(index, centerItem: centerItem);
          }
        },
        onSelect: () {
          if (_controller.filteredItems.isNotEmpty) {
            _handleSelection(
              _controller.filteredItems[_controller.selectedIndex],
            );
          }
        },
        onBack: () {
          if (_isSearchMode) {
            _clearSearch();
          } else {
            _navigateBack();
          }
        },
        onRefresh: _loadItems,
        onToggleView: _toggleScreenViewMode,
        onSearch: _activateSearchMode,
        onShowHelp: _showHelpDialog,
        onScheduleMediaLoad: _scheduleMediaLoad,
        onHideNavigationHint: () {},
        isInSearchMode: () => _isSearchMode,
        onCustomShortcut: (key) {
          // M = Show media
          if (key == LogicalKeyboardKey.keyM) {
            _showMediaDialog();
            return true;
          }
          // Tab = Settings
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
          // EmulatorPlatform navigation (only in list mode at root)
          if (_viewMode == ScreenViewMode.list &&
              _pathHistory.isEmpty &&
              _currentSubdirectory == null) {
            if (key == LogicalKeyboardKey.arrowLeft ||
                key == LogicalKeyboardKey.keyQ) {
              _navigateToPreviousEmulatorPlatform();
              return true;
            }
            if (key == LogicalKeyboardKey.arrowRight ||
                key == LogicalKeyboardKey.keyE) {
              _navigateToNextEmulatorPlatform();
              return true;
            }
          }
          return false;
        },
      ),
    );

    // Restore saved view mode or set default based on screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final savedMode = ConfigService.instance.romsViewMode;
        final width = MediaQuery.of(context).size.width;
        setState(() {
          if (savedMode != null) {
            _viewMode = ScreenViewMode.values.firstWhere(
              (m) => m.name == savedMode,
              orElse: () => width < 600
                  ? ScreenViewMode.carousel
                  : ScreenViewMode.list,
            );
          } else {
            _viewMode = width < 600
                ? ScreenViewMode.carousel
                : ScreenViewMode.list;
          }
        });
      }
    });

    // Setup gamepad connection callback for NEW connections
    GamepadService.instance.onGamepadConnected = _onGamepadConnected;

    // Check if gamepad is already connected and show toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && GamepadService.instance.isGamepadConnected) {
        _showGamepadToast('Gamepad');
      }
    });

    _loadPlatformsList();
    _loadItems();
    _startGamepadPolling();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  /// Initialize gamelist service with correct path asynchronously
  Future<void> _initializeGamelistService() async {
    final gamelistPath = await ConfigService.instance.gamelistPath;

    if (!mounted) return;

    // Update gamelist service with correct path
    _gamelistService = GamelistService(gamelistBasePath: gamelistPath);

    // Update controller with new gamelist service
    _controller.removeListener(_onControllerUpdate);
    _controller = RomsScreenController(
      mediaService: _mediaService,
      gamelistService: _gamelistService,
      romService: widget.romService,
    );
    _controller.addListener(_onControllerUpdate);

    // Update rom launcher with new controller
    _romLauncher = RomLauncher(
      emulatorService: _emulatorService,
      mediaService: _mediaService,
      platformName: widget.platform.name,
      platformDisplayName: widget.platform.displayName,
      mediaCache: _controller.mediaCache,
      requestFocus: _requestFocusForCurrentViewMode,
      isCollection: widget.isCollection,
    );
    _romSaveHandler = RomSaveHandler(
      platformName: widget.platform.name,
      requestFocus: _requestFocusForCurrentViewMode,
      isCollection: widget.isCollection,
      mediaService: _mediaService,
      mediaCache: _controller.mediaCache,
    );

    _debug.info(
      'GamelistService initialized with path: $gamelistPath',
      tag: 'RomsScreen',
    );
  }

  /// Start polling gamepad state periodically
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

  /// Handle gamepad input
  void _handleGamepadInput() {
    if (!_gamepadService.isGamepadConnected) return;
    if (_controller.filteredItems.isEmpty) return;

    // Handle search activation with button X
    if (_gamepadService.isSearchPressed()) {
      _activateSearchMode();
    }

    // Handle navigation
    int? newIndex;
    if (_viewMode == ScreenViewMode.grid) {
      newIndex = _gamepadService.handleGridNavigation(
        currentIndex: _controller.selectedIndex,
        itemCount: _controller.filteredItems.length,
        columns: _calculateCrossAxisCount(context),
      );
    } else if (_viewMode == ScreenViewMode.list) {
      newIndex = _gamepadService.handleListNavigation(
        currentIndex: _controller.selectedIndex,
        itemCount: _controller.filteredItems.length,
      );
    } else {
      newIndex = _gamepadService.handleCarouselNavigation(
        currentIndex: _controller.selectedIndex,
        itemCount: _controller.filteredItems.length,
      );
    }

    if (newIndex != null) {
      _controller.selectedIndex = newIndex;
      _scrollToSelectedIndex();
      _scheduleMediaLoad();
    }

    // Handle select (A button)
    if (_gamepadService.isSelectPressed()) {
      _handleSelection(_controller.filteredItems[_controller.selectedIndex]);
    }

    // Handle back (B button)
    if (_gamepadService.isBackPressed()) {
      if (_isSearchMode) {
        _clearSearch();
      } else {
        _navigateBack();
      }
    }

    // Handle help (Y button)
    if (_gamepadService.isHelpPressed()) {
      _showHelpDialog();
    }

    // Handle view toggle (RS button)
    if (_gamepadService.isViewTogglePressed()) {
      _toggleScreenViewMode();
    }

    // Handle media (M key / L1)
    if (_gamepadService.isPageDownPressed()) {
      _showMediaDialog();
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showGamepadToast(gamepadName);
      }
    });
  }

  /// Load list of all platforms for lateral navigation
  Future<void> _loadPlatformsList() async {
    try {
      final platforms = await widget.romService.loadPlatforms();
      if (!mounted) return;
      setState(() {
        _allEmulatorPlatforms = platforms;
        _currentEmulatorPlatformIndex = platforms.indexWhere(
          (p) => p.name == widget.platform.name,
        );
      });
    } catch (e) {
      _debug.error('Failed to load platforms list', error: e);
    }
  }

  /// Navigate to previous platform
  void _navigateToPreviousEmulatorPlatform() {
    if (_allEmulatorPlatforms == null ||
        _currentEmulatorPlatformIndex == null) {
      return;
    }
    if (_currentEmulatorPlatformIndex! <= 0) {
      return;
    }

    final previousPlatform =
        _allEmulatorPlatforms![_currentEmulatorPlatformIndex! - 1];
    _navigateToEmulatorPlatform(previousPlatform);
  }

  /// Navigate to next platform
  void _navigateToNextEmulatorPlatform() {
    if (_allEmulatorPlatforms == null ||
        _currentEmulatorPlatformIndex == null) {
      return;
    }
    if (_currentEmulatorPlatformIndex! >= _allEmulatorPlatforms!.length - 1) {
      return;
    }

    final nextPlatform =
        _allEmulatorPlatforms![_currentEmulatorPlatformIndex! + 1];
    _navigateToEmulatorPlatform(nextPlatform);
  }

  /// Navigate to a specific platform
  void _navigateToEmulatorPlatform(EmulatorPlatform platform) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RomsScreen(
          platform: platform,
          romService: widget.romService,
          isCollection: widget.isCollection,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _carouselController.dispose();
    _gridScrollController.dispose();
    _listScrollController.dispose();
    _carouselFocusNode.dispose();
    _gridFocusNode.dispose();
    _listFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    if (!mounted) return;

    final platformIdentifier = widget.isCollection
        ? widget.platform.name
        : widget.platform.code;

    final platformLogoPath = await _mediaService.getSystemLogo(
      platformIdentifier,
    );
    final platformBackgroundPath = await _mediaService.getSystemBackground(
      platformIdentifier,
    );

    if (mounted) {
      setState(() {
        _platformBackgroundPath = platformBackgroundPath;
        _cachedLogoWidget = platformLogoPath != null
            ? SmartSvg.asset(
                platformLogoPath,
                height: 24,
                fit: BoxFit.contain,
                placeholderBuilder: (context) =>
                    Text(widget.platform.displayName),
              )
            : Text(widget.platform.displayName);
      });
    }

    await _controller.loadItems(
      platform: widget.platform,
      currentPath: _currentPath,
      currentSubdirectory: _currentSubdirectory,
      isCollection: widget.isCollection,
    );

    if (mounted) {
      setState(() {
        _searchController.clear();
        _isSearchMode = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _requestFocusForCurrentViewMode();
        if (_controller.filteredItems.isNotEmpty) {
          _controller.scheduleMediaLoad(
            platformName: widget.platform.name,
            isMounted: () => mounted,
          );
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    _controller.setSearchQuery(query);
    if (_controller.filteredItems.isNotEmpty) {
      _scheduleMediaLoad();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _controller.setSearchQuery('');
    setState(() {
      _isSearchMode = false;
    });
    if (_controller.filteredItems.isNotEmpty) {
      _scheduleMediaLoad();
    }
  }

  void _activateSearchMode() {
    setState(() {
      _isSearchMode = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _scrollToIndexInGrid(int index, int columns, {bool centerItem = false}) {
    ScrollUtils.scrollToIndexInGrid(
      _gridScrollController,
      context,
      index,
      columns,
      centerItem: centerItem,
    );
  }

  void _scrollToIndexInList(int index, {bool centerItem = false}) {
    var headersBefore = 0;
    var hasHeader = false;
    if (widget.isCollection) {
      final items = _controller.filteredItems;
      for (var i = 0; i <= index && i < items.length; i++) {
        final isGroupStart = i == 0 || items[i].platform != items[i - 1].platform;
        if (isGroupStart) {
          if (i < index) {
            headersBefore++;
          } else {
            hasHeader = true;
          }
        }
      }
    }
    ScrollUtils.scrollToIndexInList(
      _listScrollController,
      index,
      centerItem: centerItem,
      headersBefore: headersBefore,
      hasHeader: hasHeader,
    );
  }

  void _scrollToCarouselIndex(int index, {bool centerItem = false}) {
    // Optional implementation
  }

  void _scrollToSelectedIndex() {
    if (_controller.filteredItems.isEmpty) return;
    switch (_viewMode) {
      case ScreenViewMode.grid:
        _scrollToIndexInGrid(
          _controller.selectedIndex,
          _calculateCrossAxisCount(context),
        );
        break;
      case ScreenViewMode.list:
        _scrollToIndexInList(_controller.selectedIndex);
        break;
      case ScreenViewMode.carousel:
        _scrollToCarouselIndex(_controller.selectedIndex);
        break;
    }
  }

  void _scheduleMediaLoad() {
    _controller.scheduleMediaLoad(
      platformName: widget.platform.name,
      isMounted: () => mounted,
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  void _toggleScreenViewMode() {
    setState(() {
      switch (_viewMode) {
        case ScreenViewMode.grid:
          _viewMode = ScreenViewMode.list;
          break;
        case ScreenViewMode.list:
          _viewMode = ScreenViewMode.carousel;
          break;
        case ScreenViewMode.carousel:
          _viewMode = ScreenViewMode.grid;
          break;
      }
    });
    ConfigService.instance.setRomsViewMode(_viewMode.name);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestFocusForCurrentViewMode();
      _scrollToSelectedIndex();
      if (_controller.filteredItems.isNotEmpty) {
        _scheduleMediaLoad();
      }
    });
  }

  void _requestFocusForCurrentViewMode() {
    switch (_viewMode) {
      case ScreenViewMode.grid:
        _gridFocusNode.requestFocus();
        break;
      case ScreenViewMode.list:
        _listFocusNode.requestFocus();
        break;
      case ScreenViewMode.carousel:
        _carouselFocusNode.requestFocus();
        break;
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    return _keyboardHandler.handleKeyEvent(event, _viewMode);
  }

  void _showHelpDialog() async {
    _stopGamepadPolling();
    await HelpDialog.show(context, showSearchShortcut: true);
    if (mounted) _startGamepadPolling();
  }

  void _handleSelection(RomItem item) {
    if (item.isFolder) {
      _navigateToFolder(item);
    } else {
      if (_viewMode == ScreenViewMode.grid) {
        _showRomDetailDialog(item);
      } else {
        _handleRomLaunch(item);
      }
    }
  }

  void _navigateToFolder(RomItem folder) {
    if (widget.platform.isJsonlPlatform) {
      _pathHistory.add(_currentSubdirectory ?? "");
      setState(() {
        _currentSubdirectory = folder.path;
      });
    } else {
      _pathHistory.add(_currentPath);
      setState(() {
        _currentPath = folder.path;
      });
    }
    _loadItems();
  }

  void _navigateBack() {
    if (_pathHistory.isNotEmpty) {
      if (widget.platform.isJsonlPlatform) {
        final previous = _pathHistory.removeLast();
        setState(() {
          _currentSubdirectory = previous.isEmpty ? null : previous;
        });
      } else {
        _currentPath = _pathHistory.removeLast();
        setState(() {});
      }
      _loadItems();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _handleRomLaunch(RomItem item) async {
    final success = await _romLauncher.launchRom(context, item);
    if (success && mounted) {
      sleep(Duration(seconds: 2));
      await _romSaveHandler.handleRomSave(context, item);
    }
  }

  void _showRomDetailDialog(RomItem item) {
    showDialog(
      context: context,
      builder: (context) => RomDetailDialog(
        item: item,
        media: _controller.mediaCache[item.name],
        gameInfo: _controller.gameInfoCache[item.name],
        onPlay: () => _handleRomLaunch(item),
      ),
    );
  }

  void _showMediaDialog() {
    if (_controller.filteredItems.isEmpty) return;
    final item = _controller.filteredItems[_controller.selectedIndex];
    final media = _controller.mediaCache[item.name];
    if (media != null && media.allMedia.isNotEmpty) {
      final firstImage = media.allMedia.firstWhere(
        (m) => m.isImage,
        orElse: () => media.allMedia.first,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(
            imagePath: firstImage.path,
            allMedia: media.allMedia,
            initialIndex: media.allMedia.indexOf(firstImage),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _pathHistory.isEmpty && !_isSearchMode,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        if (_isSearchMode) {
          _clearSearch();
        } else if (_pathHistory.isNotEmpty) {
          _navigateBack();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background
            if (_platformBackgroundPath != null)
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_platformBackgroundPath!),
                      fit: BoxFit.cover,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0B0C10).withValues(alpha: 0.45),
                              const Color(0xFF0B0C10).withValues(alpha: 0.84),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Column(
              children: [
                RomsHeader(
                  platform: widget.platform,
                  itemCount: _controller.filteredItems.length,
                  logoWidget: _cachedLogoWidget,
                  onBack: _navigateBack,
                ),

                Expanded(
                  child: _controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _controller.filteredItems.isEmpty
                      ? RomsEmptyState(
                          isSearchMode: _isSearchMode,
                          onClearSearch: _clearSearch,
                        )
                      : _buildMainContent(),
                ),

                ControlsBottomBar(
                  actions: RomsScreenBottomBarActions.getActions(
                    context: context,
                    isListView: _viewMode == ScreenViewMode.list,
                    isAtRoot:
                        _pathHistory.isEmpty && _currentSubdirectory == null,
                  ),
                ),
              ],
            ),

            RomsSearchOverlay(
              isSearchMode: _isSearchMode,
              showVirtualKeyboard: _showVirtualKeyboard,
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchChanged: _onSearchChanged,
              onCancelSearch: _clearSearch,
              onToggleVirtualKeyboard: () =>
                  setState(() => _showVirtualKeyboard = !_showVirtualKeyboard),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_viewMode) {
      case ScreenViewMode.grid:
        return RomsGridView(
          items: _controller.filteredItems,
          selectedIndex: _controller.selectedIndex,
          scrollController: _gridScrollController,
          focusNode: _gridFocusNode,
          onItemTap: (index, item) {
            _controller.selectedIndex = index;
            _handleSelection(item);
          },
          onKeyEvent: _handleKeyEvent,
          mediaCache: _controller.mediaCache,
          mediaService: _mediaService,
          loadMediaForItem: (item) =>
              _controller.loadMediaForItem(item, widget.platform.name),
          platformName: widget.platform.name,
          isCollection: widget.isCollection,
        );
      case ScreenViewMode.list:
        return RomsListView(
          items: _controller.filteredItems,
          selectedIndex: _controller.selectedIndex,
          scrollController: _listScrollController,
          focusNode: _listFocusNode,
          onItemTap: (index, item) {
            _controller.selectedIndex = index;
            _handleSelection(item);
          },
          onKeyEvent: _handleKeyEvent,
          mediaCache: _controller.mediaCache,
          mediaService: _mediaService,
          loadMediaForItem: (item) =>
              _controller.loadMediaForItem(item, widget.platform.name),
          onRomLaunch: _handleRomLaunch,
          onFolderTap: _navigateToFolder,
          showRomDetailDialog: _showRomDetailDialog,
          loadGameInfoForItem: (item) =>
              _controller.loadGameInfoForItem(item, widget.platform.name),
          gameInfoCache: _controller.gameInfoCache,
          isCollection: widget.isCollection,
          platformName: widget.platform.name,
          showNavigationHint: false,
        );
      case ScreenViewMode.carousel:
        return RomsCarouselView(
          items: _controller.filteredItems,
          selectedIndex: _controller.selectedIndex,
          scrollController: _carouselController,
          focusNode: _carouselFocusNode,
          onItemTap: (index, item) {
            _controller.selectedIndex = index;
            _handleSelection(item);
          },
          onKeyEvent: _handleKeyEvent,
          mediaCache: _controller.mediaCache,
          mediaService: _mediaService,
          loadMediaForItem: (item) =>
              _controller.loadMediaForItem(item, widget.platform.name),
          onFolderTap: _navigateToFolder,
          onRomLaunch: _handleRomLaunch,
          loadGameInfoForItem: (item) =>
              _controller.loadGameInfoForItem(item, widget.platform.name),
          gameInfoCache: _controller.gameInfoCache,
          isCollection: widget.isCollection,
          platformName: widget.platform.name,
          showNavigationHint: false,
        );
    }
  }
}
