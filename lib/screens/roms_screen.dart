import 'dart:ui';
import 'dart:async';

import 'package:forsaken/screens/roms/roms_carousel_view.dart';
import 'package:forsaken/screens/roms/roms_grid_view.dart';
import 'package:forsaken/screens/roms/roms_list_view.dart';
import 'package:forsaken/screens/roms/utils/scroll_utils.dart';
import 'package:forsaken/screens/roms/utils/bottom_bar_actions.dart';
import 'package:forsaken/screens/roms/controllers/roms_screen_controller.dart';
import 'package:forsaken/screens/roms/handlers/rom_launcher.dart';
import 'package:forsaken/screens/roms/handlers/rom_save_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:forsaken/models/emulator_platform.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/rom_service.dart';
import 'package:forsaken/services/media_service.dart';
import 'package:forsaken/services/emulator_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/services/gamepad_service.dart';
import 'package:forsaken/services/gamelist_service.dart';
import 'package:forsaken/services/rom_storage_service.dart';
import 'package:forsaken/services/screen_keyboard_handler.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:forsaken/widgets/common/theme_selector.dart';
import 'package:forsaken/widgets/common/help_dialog.dart';
import 'package:forsaken/widgets/common/virtual_keyboard.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:forsaken/widgets/common/smart_svg.dart';
import 'package:forsaken/widgets/roms/fullscreen_image_viewer.dart';
import 'package:forsaken/widgets/roms/rom_detail_dialog.dart';
import 'package:forsaken/screens/settings_screen.dart';

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
  List<RomItem> _items = [];
  List<RomItem> _filteredItems = [];
  String _currentPath = '';
  String? _currentSubdirectory; // For JSONL platforms: current subdirectory
  final List<String> _pathHistory = [];
  bool _isLoading = true;
  List<Rom>? _platformRoms; // Cached ROMs for JSONL platform
  ScreenViewMode _viewMode = ScreenViewMode.list;
  int _selectedIndex = 0;
  final Map<String, bool> _downloadedRomsCache =
      {}; // Cache for downloaded ROM status
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
  bool _showNavigationHint = true;
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

    // Set default view mode based on screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final width = MediaQuery.of(context).size.width;
        setState(() {
          _viewMode = width < 600
              ? ScreenViewMode.carousel
              : ScreenViewMode.list;
        });
      }
    });

    // Initialize services synchronously
    _mediaService = MediaService.instance;
    _emulatorService = EmulatorService.instance;
    _keyboardService = KeyboardService.instance;
    _gamepadService = GamepadService.instance;

    // Initialize gamelist service with empty path temporarily
    // Will be updated with correct path asynchronously
    _gamelistService = GamelistService(gamelistBasePath: '');
    _controller = RomsScreenController(
      mediaService: _mediaService,
      gamelistService: _gamelistService,
    );
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
        getItems: () => _filteredItems,
        getCurrentIndex: () => _selectedIndex,
        setCurrentIndex: (index) {
          setState(() {
            _selectedIndex = index;
            _showNavigationHint = false;
          });
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
        onSelect: _handleSelection,
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
        onHideNavigationHint: () {
          if (mounted) {
            setState(() {
              _showNavigationHint = false;
            });
          }
        },
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

  /// Initialize gamelist service with correct path asynchronously
  Future<void> _initializeGamelistService() async {
    final gamelistPath = await ConfigService.instance.gamelistPath;

    if (!mounted) return;

    // Update gamelist service with correct path
    _gamelistService = GamelistService(gamelistBasePath: gamelistPath);

    // Update controller with new gamelist service
    _controller = RomsScreenController(
      mediaService: _mediaService,
      gamelistService: _gamelistService,
    );

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
    );

    _debug.info(
      'GamelistService initialized with path: $gamelistPath',
      tag: 'RomsScreen',
    );
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
    if (_filteredItems.isEmpty) return;

    // In search mode, only allow B button to exit
    if (_isSearchMode) {
      if (_gamepadService.isBackPressed()) {
        _clearSearch();
        _gamepadService.updatePreviousButtonStates();
      }
      return;
    }

    // Handle selection (A button)
    if (_gamepadService.isSelectPressed()) {
      _handleSelection();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle back (B button)
    if (_gamepadService.isBackPressed()) {
      _navigateBack();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle search (X button)
    if (_gamepadService.isSearchPressed()) {
      _activateSearchMode();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle help (Y button)
    if (_gamepadService.isHelpPressed()) {
      _showHelpDialog();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle view media (RT - Right Trigger)
    if (_gamepadService.isRightTriggerPressed()) {
      _showMediaDialog();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle view toggle (Right stick click)
    if (_gamepadService.isViewTogglePressed()) {
      _toggleScreenViewMode();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Handle navigation based on view mode
    if (_viewMode == ScreenViewMode.grid) {
      _handleGamepadGridNavigation();
    } else if (_viewMode == ScreenViewMode.list) {
      _handleGamepadListNavigation();
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
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
      columns: columns,
    );

    if (newIndex != null && newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _showNavigationHint = false;
      });
      _scrollToIndexInGrid(newIndex, columns);
      _scheduleMediaLoad();
    }
  }

  /// Handle gamepad navigation in list mode
  void _handleGamepadListNavigation() {
    final newIndex = _gamepadService.handleListNavigation(
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
    );

    if (newIndex != null && newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _showNavigationHint = false;
      });
      _scrollToIndexInList(newIndex);
      _scheduleMediaLoad();
    }
  }

  /// Handle gamepad navigation in carousel mode
  void _handleGamepadCarouselNavigation() {
    final newIndex = _gamepadService.handleCarouselNavigation(
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
      loop: true,
    );

    if (newIndex != null && newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _showNavigationHint = false;
      });
      _scrollToCarouselIndex(newIndex);
      _scheduleMediaLoad();
    }
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
      if (!mounted) return; // Check mounted before setState
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
    if (_currentEmulatorPlatformIndex! <= 0) return;

    final previousEmulatorPlatform =
        _allEmulatorPlatforms![_currentEmulatorPlatformIndex! - 1];
    _navigateToEmulatorPlatform(previousEmulatorPlatform);
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

    final nextEmulatorPlatform =
        _allEmulatorPlatforms![_currentEmulatorPlatformIndex! + 1];
    _navigateToEmulatorPlatform(nextEmulatorPlatform);
  }

  /// Navigate to a specific platform
  void _navigateToEmulatorPlatform(EmulatorPlatform platform) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RomsScreen(platform: platform, romService: widget.romService),
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
    // Cancel timers
    _stopGamepadPolling();
    _controller.dispose();

    // Clear gamepad callback
    GamepadService.instance.onGamepadConnected = null;

    // Clear platform cache when leaving the screen to free up memory
    if (widget.platform.isJsonlPlatform) {
      widget.romService.clearPlatformCache(widget.platform.name);
    }

    _carouselController.dispose();
    _gridScrollController.dispose();
    _listScrollController.dispose();
    _carouselFocusNode.dispose();
    _gridFocusNode.dispose();
    _listFocusNode.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Stop polling gamepad state
  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  Future<void> _loadItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    // For collections, use platform.name (the collection ID)
    // For regular platforms, use platform.code (basename of path)
    final platformIdentifier = widget.isCollection
        ? widget.platform.name
        : widget.platform.code;

    final platformLogoPath = await _mediaService.getSystemLogo(
      platformIdentifier,
    );
    final platformBackgroundPath = await _mediaService.getSystemBackground(
      platformIdentifier,
    );

    List<RomItem> items;

    // Check if this is a collection view
    if (widget.isCollection) {
      // Convert ROMs from collection to RomItems
      items = widget.platform.roms.map((rom) {
        return RomItem(
          name: rom.name,
          path: rom.localPath ?? rom.urlFilePath,
          type: RomItemType.rom,
          downloadUrl: rom.downloadUrl,
          platform: rom.platform, // Include platform info for collection views
        );
      }).toList();
    }
    // Check if this is a JSONL platform (lazy-loaded)
    else if (widget.platform.isJsonlPlatform) {
      // Load ROMs from JSONL file if not already loaded
      _platformRoms ??= await widget.romService.loadRomsForJsonlPlatform(
        widget.platform.name,
      );

      // Convert ROMs to RomItems based on current subdirectory
      items = await widget.romService.loadItemsFromRoms(
        _platformRoms!,
        _currentSubdirectory,
        widget.platform.name, // Add platform name
      );
    } else {
      // File-based platform: load from filesystem
      items = await widget.romService.loadItemsInDirectory(
        _currentPath,
        widget.platform.name, // Add platform name
      );
    }

    // Update display names with GameList data if available
    await _updateDisplayNames(items);

    if (mounted) {
      setState(() {
        _items = items;
        _platformBackgroundPath = platformBackgroundPath;

        // Cache logo widget to avoid rebuilds
        _cachedLogoWidget = platformLogoPath != null
            ? SmartSvg.asset(
                platformLogoPath,
                height: 24,
                fit: BoxFit.contain,
                placeholderBuilder: (context) =>
                    Text(widget.platform.displayName),
              )
            : Text(widget.platform.displayName);

        _searchController.clear();
        _isSearchMode = false;
        _filteredItems = items;
        _isLoading = false;
        _selectedIndex = 0;
        _controller.clearCaches();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _requestFocusForCurrentViewMode();
        // Load initial media for visible items
        if (_filteredItems.isNotEmpty) {
          _controller.scheduleMediaLoad(
            filteredItems: _filteredItems,
            selectedIndex: _selectedIndex,
            platformName: widget.platform.name,
            onUpdate: () {
              if (mounted) setState(() {});
            },
            isMounted: () => mounted,
          );
        }
      });
    }
  }

  List<RomItem> _filterItems(List<RomItem> items, String query) {
    if (query.isEmpty) {
      return items;
    }

    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      return item.displayName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = _filterItems(_items, query);
      _selectedIndex = 0;
    });
    // Load media for newly filtered items
    if (_filteredItems.isNotEmpty) {
      _scheduleMediaLoad();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredItems = _items;
      _isSearchMode = false;
      _selectedIndex = 0;
    });
    // Load media after clearing search
    if (_filteredItems.isNotEmpty) {
      _scheduleMediaLoad();
    }
  }

  void _activateSearchMode() {
    setState(() {
      _isSearchMode = true;
    });
    // Request focus after the widget rebuilds
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
    ScrollUtils.scrollToIndexInList(
      _listScrollController,
      index,
      centerItem: centerItem,
    );
  }

  /// Wrapper methods to simplify controller calls
  void _scheduleMediaLoad() {
    _controller.scheduleMediaLoad(
      filteredItems: _filteredItems,
      selectedIndex: _selectedIndex,
      platformName: widget.platform.name,
      onUpdate: () {
        if (mounted) setState(() {});
      },
      isMounted: () => mounted,
    );
  }

  Future<void> _loadMediaForItem(RomItem item) async {
    await _controller.loadMediaForItem(item, widget.platform.name, () {
      if (mounted) setState(() {});
    }, () => mounted);
  }

  Future<void> _loadGameInfoForItem(RomItem item) async {
    await _controller.loadGameInfoForItem(item, widget.platform.name, () {
      if (mounted) setState(() {});
    }, () => mounted);
  }

  void _navigateToFolder(RomItem folder) {
    if (widget.platform.isJsonlPlatform) {
      // For JSONL platforms, navigate by subdirectory name
      _pathHistory.add(_currentSubdirectory ?? '');
      setState(() {
        _currentSubdirectory = folder.path; // folder.path is subdirectory name
      });
    } else {
      // For file-based platforms, navigate by filesystem path
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
        // For JSONL platforms, restore subdirectory
        final previous = _pathHistory.removeLast();
        setState(() {
          _currentSubdirectory = previous.isEmpty ? null : previous;
        });
      } else {
        // For file-based platforms, restore filesystem path
        setState(() {
          _currentPath = _pathHistory.removeLast();
        });
      }
      _loadItems();
    } else {
      Navigator.pop(context);
    }
  }

  String? _getCurrentFolderName() {
    if (widget.platform.isJsonlPlatform) {
      // For JSONL platforms, return current subdirectory name
      return _currentSubdirectory;
    } else {
      // For file-based platforms, return folder name if not at root
      if (_currentPath != widget.platform.path) {
        return path.basename(_currentPath);
      }
      return null;
    }
  }

  IconData _getScreenViewModeIcon() {
    switch (_viewMode) {
      case ScreenViewMode.grid:
        return Icons.view_list;
      case ScreenViewMode.list:
        return Icons.view_carousel;
      case ScreenViewMode.carousel:
        return Icons.grid_view;
    }
  }

  String _getScreenViewModeTooltip() {
    switch (_viewMode) {
      case ScreenViewMode.grid:
        return 'List View';
      case ScreenViewMode.list:
        return 'Carousel View';
      case ScreenViewMode.carousel:
        return 'Grid View';
    }
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

    // Request focus for the new view mode after the widget rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestFocusForCurrentViewMode();
      _requestScrollToIndexCurrentScreenViewMode();
      // Load media for the new view
      if (_filteredItems.isNotEmpty) {
        _scheduleMediaLoad();
      }
    });
  }

  /// Request focus for the current view mode's FocusNode
  void _requestFocusForCurrentViewMode() {
    switch (_viewMode) {
      case ScreenViewMode.grid:
        if (!_gridFocusNode.hasFocus) {
          _gridFocusNode.requestFocus();
        }
        break;
      case ScreenViewMode.list:
        if (!_listFocusNode.hasFocus) {
          _listFocusNode.requestFocus();
        }
        break;
      case ScreenViewMode.carousel:
        if (!_carouselFocusNode.hasFocus) {
          _carouselFocusNode.requestFocus();
        }
        break;
    }
  }

  /// Main keyboard event handler - delegates to ScreenKeyboardHandler
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    return _keyboardHandler.handleKeyEvent(event, _viewMode);
  }

  /// Show help dialog with keyboard shortcuts
  void _showHelpDialog() async {
    // Pause gamepad polling while dialog is open
    _stopGamepadPolling();

    await HelpDialog.show(context, showSearchShortcut: true);

    // Resume gamepad polling after dialog closes
    if (mounted) {
      _startGamepadPolling();
    }
  }

  void _handleSelection() {
    final item = _filteredItems[_selectedIndex];

    if (item.isFolder) {
      _navigateToFolder(item);
    } else {
      // Carousel and List: launch directly
      // Grid: show detail dialog
      if (_viewMode == ScreenViewMode.grid) {
        _showRomDetailDialog(item);
      } else {
        _handleRomLaunch(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _pathHistory.isEmpty,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && _pathHistory.isNotEmpty) {
          _navigateBack();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background image (very attenuated)
            if (_platformBackgroundPath != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15, // Very attenuated (15% opacity)
                  child: Image.asset(
                    _platformBackgroundPath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            // Main content
            Column(
              children: [
                // AppBar
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _navigateBack,
                  ),
                  title: _isSearchMode
                      ? Focus(
                          onKeyEvent: (node, event) {
                            // Exit search mode on ESC key
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.escape) {
                              _clearSearch();
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search ROMs... (ESC to exit)',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.keyboard,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showVirtualKeyboard =
                                        !_showVirtualKeyboard;
                                  });
                                },
                                tooltip: 'Toggle virtual keyboard',
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: _onSearchChanged,
                            onSubmitted: (_) {
                              // Close search on submit
                              _clearSearch();
                            },
                          ),
                        )
                      : _buildTitle(),
                  actions: _buildAppBarActions(context),
                ),
                // Body
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBody(),
                ),
                // Virtual keyboard
                if (_showVirtualKeyboard && _isSearchMode)
                  VirtualKeyboard(
                    controller: _searchController,
                    onClose: () {
                      setState(() {
                        _showVirtualKeyboard = false;
                      });
                    },
                  ),
                // Bottom bar with controls
                if (!_showVirtualKeyboard)
                  ControlsBottomBar(
                    actions: _getBottomBarActions(),
                    counterText: _filteredItems.isEmpty
                        ? null
                        : '${_selectedIndex + 1} / ${_filteredItems.length}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    String? subFolder = _getCurrentFolderName();
    return Container(
      margin: const EdgeInsets.only(right: 1),
      child: Row(
        children: [
          Image.asset('assets/images/icon.png', width: 24, height: 24),
          Icon(Icons.chevron_right),
          _cachedLogoWidget ?? Text(widget.platform.displayName),
          if (subFolder != null) Icon(Icons.chevron_right),
          if (subFolder != null) Text(subFolder),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // Mobile: Only search button + hamburger menu
      return [
        if (!_isSearchMode)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _activateSearchMode,
            tooltip: 'Search',
          )
        else
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSearch,
            tooltip: 'Clear search',
          ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Menu',
          onSelected: (value) {
            switch (value) {
              case 'toggle_view':
                _toggleScreenViewMode();
                break;
              case 'refresh':
                _loadItems();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle_view',
              child: Row(
                children: [
                  Icon(_getScreenViewModeIcon()),
                  const SizedBox(width: 12),
                  Text(_getScreenViewModeTooltip()),
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
          ],
        ),
      ];
    } else {
      // Desktop: Show all actions as icon buttons
      return [
        if (!_isSearchMode)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _activateSearchMode,
            tooltip: 'Search',
          )
        else
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSearch,
            tooltip: 'Clear search',
          ),
        const ThemeSelector(),
        IconButton(
          icon: Icon(_getScreenViewModeIcon()),
          onPressed: _toggleScreenViewMode,
          tooltip: _getScreenViewModeTooltip(),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadItems,
          tooltip: 'Refresh',
        ),
      ];
    }
  }

  Widget _buildBody() {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSearchMode ? Icons.search_off : Icons.folder_open,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearchMode
                  ? 'No ROMs match "${_searchController.text}"'
                  : 'No items found in this folder',
            ),
            if (_isSearchMode) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _clearSearch,
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      );
    }

    if (_viewMode == ScreenViewMode.carousel) {
      return _buildCarouselView();
    } else if (_viewMode == ScreenViewMode.list) {
      return _buildListView();
    } else {
      return _buildGridView();
    }
  }

  Widget _buildListView() {
    return RomsListView(
      items: _filteredItems,
      selectedIndex: _selectedIndex,
      scrollController: _listScrollController,
      focusNode: _listFocusNode,
      onItemTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        _scrollToIndexInList(index);
        _scheduleMediaLoad();
      },
      onKeyEvent: _handleKeyEvent,
      mediaCache: _controller.mediaCache,
      mediaService: _mediaService,
      loadMediaForItem: _loadMediaForItem,
      onRomLaunch: _handleRomLaunch,
      onFolderTap: _navigateToFolder,
      showRomDetailDialog: _showRomDetailDialog,
      loadGameInfoForItem: _loadGameInfoForItem,
      gameInfoCache: _controller.gameInfoCache,
      isRomDownloaded: _isRomDownloaded,
      isCollection: widget.isCollection,
    );
  }

  Widget _buildGridView() {
    return RomsGridView(
      items: _filteredItems,
      selectedIndex: _selectedIndex,
      scrollController: _gridScrollController,
      focusNode: _gridFocusNode,
      onItemTap: (index, item) {
        setState(() {
          _selectedIndex = index;
        });
        final columns = _calculateCrossAxisCount(context);
        _scrollToIndexInGrid(index, columns);
        _scheduleMediaLoad();
      },
      onKeyEvent: _handleKeyEvent,
      mediaCache: _controller.mediaCache,
      mediaService: _mediaService,
      loadMediaForItem: _loadMediaForItem,
      isRomDownloaded: _isRomDownloaded,
      platformName: widget.platform.name,
      isCollection: widget.isCollection,
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    return ScrollUtils.calculateCrossAxisCount(context);
  }

  Widget _buildCarouselView() {
    return RomsCarouselView(
      items: _filteredItems,
      selectedIndex: _selectedIndex,
      scrollController: _carouselController,
      focusNode: _carouselFocusNode,
      onFolderTap: _navigateToFolder,
      onRomLaunch: _handleRomLaunch,
      onKeyEvent: _handleKeyEvent,
      mediaCache: _controller.mediaCache,
      mediaService: _mediaService,
      loadMediaForItem: _loadMediaForItem,
      onCardTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        _scrollToCarouselIndex(index);
        _scheduleMediaLoad();
      },
      showNavigationHint: _showNavigationHint,
      loadGameInfoForItem: _loadGameInfoForItem,
      gameInfoCache: _controller.gameInfoCache,
      isRomDownloaded: _isRomDownloaded,
      isCollection: widget.isCollection,
    );
  }

  void _scrollToCarouselIndex(int index, {bool centerItem = false}) {
    ScrollUtils.scrollToCarouselIndex(
      _carouselController,
      index,
      centerItem: centerItem,
    );
  }

  void _showRomDetailDialog(RomItem item) async {
    if (item.isFolder) {
      _navigateToFolder(item);
      return;
    }

    // Don't show dialog in desktop mode (wide screen) - detail panel is already visible
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    if (isWideScreen) {
      // In desktop mode, just update selection (panel updates automatically)
      // Media and game info are already loaded by the panel
      return;
    }

    _loadMediaForItem(item);
    _loadGameInfoForItem(item);

    // Pause gamepad polling while dialog is open
    _stopGamepadPolling();

    await RomDetailDialog.show(
      context: context,
      item: item,
      media: _controller.mediaCache[item.name],
      gameInfo: _controller.gameInfoCache[item.name],
      onPlay: () => _handleRomLaunch(item),
      onClose: _requestFocusForCurrentViewMode,
    );

    // Resume gamepad polling after dialog closes
    if (mounted) {
      _startGamepadPolling();
    }
  }

  /// Show media in fullscreen dialog
  Future<void> _showMediaDialog() async {
    if (_filteredItems.isEmpty) return;

    final item = _filteredItems[_selectedIndex];
    if (item.isFolder) return;

    // Load media if not cached
    if (!_controller.mediaCache.containsKey(item.name)) {
      await _loadMediaForItem(item);
    }

    final media = _controller.mediaCache[item.name];

    // Only show if media exists
    if (media == null || !media.hasAnyMedia) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No media available for this ROM'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Get all media items and find first image to start with
    final allMediaItems = media.allMedia;
    final firstImageIndex = allMediaItems.indexWhere((m) => m.isImage);

    if (firstImageIndex == -1) {
      // No images, only video - show message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Only videos available. Click on media in detail view to play.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Pause gamepad polling before navigation
    _stopGamepadPolling();

    // Navigate to fullscreen image viewer
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenImageViewer(
          imagePath: allMediaItems[firstImageIndex].path,
          allMedia: allMediaItems,
          initialIndex: firstImageIndex,
        ),
      ),
    );

    // Resume gamepad polling after navigation
    if (mounted) {
      _startGamepadPolling();
      _requestFocusForCurrentViewMode();
    }
  }

  Future<void> _handleRomLaunch(RomItem item) async {
    final isDownloading =
        item.downloadUrl != null && item.downloadUrl!.isNotEmpty;
    final media = _controller.mediaCache[item.name];
    final imagePath = media != null
        ? _mediaService.getLaunchImagePath(media)
        : null;

    // Launch ROM using handler
    final success = await _romLauncher.launchRom(context, item);

    // If launch was successful and ROM was downloaded, ask to save
    if (success && isDownloading && mounted) {
      await _romSaveHandler.handleRomSave(context, item, imagePath);
    }
  }

  /// Check if a ROM is already downloaded (in temp or forever storage)
  Future<bool> _isRomDownloaded(RomItem item) async {
    // Check cache first
    if (_downloadedRomsCache.containsKey(item.name)) {
      return _downloadedRomsCache[item.name]!;
    }

    // Check if ROM is in storage
    final storageService = RomStorageService.instance;

    // Check forever storage first (preferred)
    final foreverPath = await storageService.findRomInForeverStorage(
      widget.platform.name,
      item.name,
    );

    if (foreverPath != null) {
      _downloadedRomsCache[item.name] = true;
      return true;
    }

    // Check temp storage
    final tempPath = await storageService.findRomInTempStorage(
      widget.platform.name,
      item.name,
    );

    final isDownloaded = tempPath != null;
    _downloadedRomsCache[item.name] = isDownloaded;
    return isDownloaded;
  }

  void _requestScrollToIndexCurrentScreenViewMode() {
    switch (_viewMode) {
      case ScreenViewMode.list:
        _scrollToIndexInList(_selectedIndex);
        break;
      case ScreenViewMode.carousel:
        _scrollToCarouselIndex(_selectedIndex);
        break;
      case ScreenViewMode.grid:
        _scrollToIndexInGrid(_selectedIndex, _calculateCrossAxisCount(context));
        break;
    }
  }

  /// Updates display names for ROMs using GameList data if available
  Future<void> _updateDisplayNames(List<RomItem> items) async {
    try {
      // Filter only ROMs (not folders) and limit concurrent GameList lookups
      final romItems = items.where((item) => item.isRom).toList();
      if (romItems.isEmpty) return;

      // Process in smaller batches to avoid overwhelming the system
      const batchSize = 10;
      for (int i = 0; i < romItems.length; i += batchSize) {
        final end = (i + batchSize < romItems.length)
            ? i + batchSize
            : romItems.length;
        final batch = romItems.sublist(i, end);

        // Process batch in parallel
        final futures = batch.map((item) async {
          await item.getDisplayNameAsync(_gamelistService);
        });

        await Future.wait(futures);

        // Update UI after each batch if still mounted
        if (mounted) {
          setState(() {
            // Trigger rebuild to show updated names
          });
        }
      }
    } catch (e) {
      DebugService.instance.warning(
        'Failed to update display names from GameList: $e',
        tag: 'RomsScreen',
      );
    }
  }

  /// Get bottom bar actions based on current view mode and context
  List<BottomBarAction> _getBottomBarActions() {
    return RomsScreenBottomBarActions.getActions(
      isListView: _viewMode == ScreenViewMode.list,
      isAtRoot: _pathHistory.isEmpty && _currentSubdirectory == null,
    );
  }
}
