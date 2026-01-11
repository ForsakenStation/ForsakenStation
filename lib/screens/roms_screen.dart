import 'dart:async';
import 'dart:ui';

import 'package:forsaken/screens/roms/roms_carousel_view.dart';
import 'package:forsaken/screens/roms/roms_grid_view.dart';
import 'package:forsaken/screens/roms/roms_list_view.dart';
import 'package:forsaken/screens/roms/utils/scroll_utils.dart';
import 'package:forsaken/screens/roms/utils/bottom_bar_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:forsaken/models/platform.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/emulator_config.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/rom_service.dart';
import 'package:forsaken/services/media_service.dart';
import 'package:forsaken/services/emulator_service.dart';
import 'package:forsaken/services/download_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/services/gamelist_service.dart';
import 'package:forsaken/widgets/common/theme_selector.dart';
import 'package:forsaken/widgets/common/help_dialog.dart';
import 'package:forsaken/widgets/common/virtual_keyboard.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:forsaken/widgets/common/smart_svg.dart';
import 'package:forsaken/widgets/common/error_dialog.dart';
import 'package:forsaken/widgets/roms/launch_progress_dialog.dart';
import 'package:forsaken/widgets/roms/save_rom_dialog.dart';
import 'package:forsaken/widgets/roms/fullscreen_image_viewer.dart';
import 'package:forsaken/widgets/roms/rom_detail_dialog.dart';
import 'package:forsaken/widgets/roms/emulator_selection_dialog.dart';
import 'package:forsaken/services/rom_storage_service.dart';
import 'package:forsaken/screens/settings_screen.dart';

enum ViewMode { list, grid, carousel }

class RomsScreen extends StatefulWidget {
  final Platform platform;
  final RomService romService;

  const RomsScreen({
    super.key,
    required this.platform,
    required this.romService,
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
  ViewMode _viewMode = ViewMode.list;
  int _selectedIndex = 0;
  final Map<String, RomMedia> _mediaCache = {};
  final Map<String, GameInfo> _gameInfoCache = {};
  final Map<String, bool> _downloadedRomsCache =
      {}; // Cache for downloaded ROM status
  late MediaService _mediaService;
  late EmulatorService _emulatorService;
  late DownloadService _downloadService;
  late KeyboardService _keyboardService;
  late GamelistService _gamelistService;
  late ScrollController _carouselController;
  late ScrollController _gridScrollController;
  late ScrollController _listScrollController;
  late FocusNode _carouselFocusNode;
  late FocusNode _gridFocusNode;
  late FocusNode _listFocusNode;
  bool _showNavigationHint = true;
  String? _platformLogoPath;
  String? _platformBackgroundPath;
  final _debug = DebugService.instance;

  // Platform navigation support
  List<Platform>? _allPlatforms;
  int? _currentPlatformIndex;

  // Search/filter functionality
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchMode = false;
  bool _showVirtualKeyboard = false;

  // Media loading control with debouncing
  Timer? _mediaLoadTimer;
  bool _isNavigating = false;
  int? _lastLoadedMediaIndex;
  final Set<int> _preloadedThumbnailIndices = {};

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
          _viewMode = width < 600 ? ViewMode.carousel : ViewMode.list;
        });
      }
    });

    final mediaPath = dotenv.env['MEDIA_PATH'] ?? '';
    final gamelistPath = dotenv.env['GAMELIST_PATH'] ?? '';

    _mediaService = MediaService(mediaBasePath: mediaPath);
    _downloadService = DownloadService.instance;
    _emulatorService = EmulatorService.instance;
    _gamelistService = GamelistService(gamelistBasePath: gamelistPath);
    _keyboardService = KeyboardService.instance;
    _carouselController = ScrollController();
    _gridScrollController = ScrollController();
    _listScrollController = ScrollController();
    _carouselFocusNode = FocusNode();
    _gridFocusNode = FocusNode();
    _listFocusNode = FocusNode();
    _loadPlatformsList();
    _loadItems();
  }

  /// Load list of all platforms for lateral navigation
  Future<void> _loadPlatformsList() async {
    try {
      final platforms = await widget.romService.loadPlatforms();
      setState(() {
        _allPlatforms = platforms;
        _currentPlatformIndex = platforms.indexWhere(
          (p) => p.name == widget.platform.name,
        );
      });
    } catch (e) {
      _debug.error('Failed to load platforms list', error: e);
    }
  }

  /// Navigate to previous platform
  void _navigateToPreviousPlatform() {
    if (_allPlatforms == null || _currentPlatformIndex == null) return;
    if (_currentPlatformIndex! <= 0) return;

    final previousPlatform = _allPlatforms![_currentPlatformIndex! - 1];
    _navigateToPlatform(previousPlatform);
  }

  /// Navigate to next platform
  void _navigateToNextPlatform() {
    if (_allPlatforms == null || _currentPlatformIndex == null) return;
    if (_currentPlatformIndex! >= _allPlatforms!.length - 1) return;

    final nextPlatform = _allPlatforms![_currentPlatformIndex! + 1];
    _navigateToPlatform(nextPlatform);
  }

  /// Navigate to a specific platform
  void _navigateToPlatform(Platform platform) {
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
    // Cancel media load timer
    _mediaLoadTimer?.cancel();

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

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    final platformLogoPath = await _mediaService.getSystemLogo(
      widget.platform.code,
    );
    final platformBackgroundPath = await _mediaService.getSystemBackground(
      widget.platform.code,
    );

    List<RomItem> items;
    // Check if this is a JSONL platform (lazy-loaded)
    if (widget.platform.isJsonlPlatform) {
      // Load ROMs from JSONL file if not already loaded
      _platformRoms ??= await widget.romService.loadRomsForJsonlPlatform(
        widget.platform.name,
      );

      // Convert ROMs to RomItems based on current subdirectory
      items = await widget.romService.loadItemsFromRoms(
        _platformRoms!,
        _currentSubdirectory,
      );
    } else {
      // File-based platform: load from filesystem
      items = await widget.romService.loadItemsInDirectory(_currentPath);
    }

    if (mounted) {
      setState(() {
        _items = items;
        _platformLogoPath = platformLogoPath;
        _platformBackgroundPath = platformBackgroundPath;
        _searchController.clear();
        _isSearchMode = false;
        _filteredItems = items;
        _isLoading = false;
        _selectedIndex = 0;
        _mediaCache.clear();
        _preloadedThumbnailIndices.clear();
        _lastLoadedMediaIndex = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestFocusForCurrentViewMode();
        // Load initial media for visible items
        if (_filteredItems.isNotEmpty) {
          _scheduleMediaLoad();
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
      _filteredItems = _items;
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
      _searchFocusNode.requestFocus();
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

  Future<void> _loadMediaForItem(RomItem item) async {
    if (_mediaCache.containsKey(item.name)) {
      return;
    }
    final media = await _mediaService.getMediaForRomItem(
      item,
      widget.platform.name,
    );

    if (mounted) {
      setState(() {
        _mediaCache[item.name] = media;
      });
    }
  }

  Future<void> _loadGameInfoForItem(RomItem item) async {
    // Check if already loaded
    if (_gameInfoCache.containsKey(item.name)) {
      return;
    }

    try {
      // Load game info from gamelist.xml
      final gameInfo = await _gamelistService.getGameInfo(
        widget.platform.name,
        item.path,
      );

      if (mounted && gameInfo != null) {
        setState(() {
          _gameInfoCache[item.name] = gameInfo;
        });
        _debug.info(
          'Loaded game info for ${item.name}: ${gameInfo.name}',
          tag: 'RomsScreen',
        );
      }
    } catch (e) {
      _debug.error(
        'Failed to load game info for ${item.name}: $e',
        tag: 'RomsScreen',
      );
    }
  }

  /// Schedule media loading after debounce delay (500ms)
  /// Loads full media for selected item and neighbors, thumbnails for wider range
  void _scheduleMediaLoad() {
    // Cancel any pending load
    _mediaLoadTimer?.cancel();

    // Mark as navigating
    if (!_isNavigating) {
      setState(() {
        _isNavigating = true;
      });
    }

    // Schedule load after 500ms debounce delay
    _mediaLoadTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      // Reset navigation flag
      setState(() {
        _isNavigating = false;
      });

      // Validate index
      if (_filteredItems.isEmpty || _selectedIndex >= _filteredItems.length) {
        return;
      }

      // Load media for selected item and immediate neighbors (±1)
      await _loadMediaForSelectedAndNeighbors();

      // Schedule thumbnail preloading for wider range (±10)
      _scheduleThumbnailPreload();
    });
  }

  /// Load full media for selected item and immediate neighbors (±1)
  Future<void> _loadMediaForSelectedAndNeighbors() async {
    if (_filteredItems.isEmpty) return;

    // Selected item
    final selectedItem = _filteredItems[_selectedIndex];
    if (selectedItem.isRom) {
      _loadMediaForItem(selectedItem);
      _loadGameInfoForItem(selectedItem);
      _lastLoadedMediaIndex = _selectedIndex;
    }

    // Previous item
    if (_selectedIndex > 0) {
      final prevItem = _filteredItems[_selectedIndex - 1];
      if (prevItem.isRom) {
        _loadMediaForItem(prevItem);
      }
    }

    // Next item
    if (_selectedIndex < _filteredItems.length - 1) {
      final nextItem = _filteredItems[_selectedIndex + 1];
      if (nextItem.isRom) {
        _loadMediaForItem(nextItem);
      }
    }
  }

  /// Preload thumbnails for items in range ±10 (background, low priority)
  void _scheduleThumbnailPreload() {
    // For very large lists (>5000 items), reduce preload range to avoid performance issues
    final preloadRange = _filteredItems.length > 5000 ? 20 : 100;

    // Wait additional 500ms before starting background preload
    Timer(const Duration(milliseconds: 100), () async {
      if (!mounted || _isNavigating) return;

      final startIndex = (_selectedIndex - preloadRange).clamp(
        0,
        _filteredItems.length - 1,
      );
      final endIndex = (_selectedIndex + preloadRange).clamp(
        0,
        _filteredItems.length - 1,
      );

      // Load thumbnails for items not already loaded
      for (int i = startIndex; i <= endIndex; i++) {
        // Skip if navigating started again
        if (_isNavigating) break;

        // Skip if already preloaded
        if (_preloadedThumbnailIndices.contains(i)) continue;

        final item = _filteredItems[i];
        if (item.isRom && !_mediaCache.containsKey(item.name)) {
          await _loadMediaForItem(item);
          _preloadedThumbnailIndices.add(i);

          // Larger delay for very large lists to avoid I/O saturation
          final delayMs = _filteredItems.length > 5000 ? 100 : 50;
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }
    });
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

  IconData _getViewModeIcon() {
    switch (_viewMode) {
      case ViewMode.grid:
        return Icons.view_list;
      case ViewMode.list:
        return Icons.view_carousel;
      case ViewMode.carousel:
        return Icons.grid_view;
    }
  }

  String _getViewModeTooltip() {
    switch (_viewMode) {
      case ViewMode.grid:
        return 'List View';
      case ViewMode.list:
        return 'Carousel View';
      case ViewMode.carousel:
        return 'Grid View';
    }
  }

  void _toggleViewMode() {
    setState(() {
      switch (_viewMode) {
        case ViewMode.grid:
          _viewMode = ViewMode.list;
          break;
        case ViewMode.list:
          _viewMode = ViewMode.carousel;
          break;
        case ViewMode.carousel:
          _viewMode = ViewMode.grid;
          break;
      }
    });

    // Request focus for the new view mode after the widget rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocusForCurrentViewMode();
      _requestScrollToIndexCurrentViewMode();
      // Load media for the new view
      if (_filteredItems.isNotEmpty) {
        _scheduleMediaLoad();
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
      case ViewMode.list:
        if (!_listFocusNode.hasFocus) {
          _listFocusNode.requestFocus();
        }
        break;
      case ViewMode.carousel:
        if (!_carouselFocusNode.hasFocus) {
          _carouselFocusNode.requestFocus();
        }
        break;
    }
  }

  /// Handles common keyboard shortcuts (R, V, S, M, Tab) that work across all view modes
  /// Returns true if the key was handled, false otherwise
  bool _handleCommonShortcuts(LogicalKeyboardKey key) {
    if (key == KeyboardService.keyRefresh) {
      _loadItems();
      return true;
    }
    if (key == KeyboardService.keyToggleView) {
      _toggleViewMode();
      return true;
    }
    if (key == KeyboardService.keySearch) {
      _activateSearchMode();
      return true;
    }
    if (key == LogicalKeyboardKey.keyM) {
      _showMediaDialog();
      return true;
    }
    if (key == LogicalKeyboardKey.tab) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
      return true;
    }
    return false;
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // 1. Handle help shortcut (Shift + ?)
    if (_keyboardService.isHelpKey(event)) {
      _showHelpDialog();
      return KeyEventResult.handled;
    }

    // 2. Handle alphabetical jump (Shift + Letter)
    if (_keyboardService.isAlphabeticalJump(event)) {
      return _handleAlphabeticalJump(event);
    }

    // 3. Handle common shortcuts (R, V, S)
    if (_handleCommonShortcuts(key)) {
      return KeyEventResult.handled;
    }

    // 4. Handle back navigation
    if (_keyboardService.isBackKey(key)) {
      if (_isSearchMode) {
        _clearSearch();
      } else {
        _navigateBack();
      }
      return KeyEventResult.handled;
    }

    // 5. Handle selection
    if (_keyboardService.isSelectKey(key)) {
      _handleSelection();
      return KeyEventResult.handled;
    }

    // 6. Handle directional navigation (depends on view mode)
    return _handleDirectionalNavigation(key);
  }

  /// Show help dialog with keyboard shortcuts
  void _showHelpDialog() {
    HelpDialog.show(context, showSearchShortcut: true);
  }

  /// Handle alphabetical jump based on current view mode
  KeyEventResult _handleAlphabeticalJump(KeyEvent event) {
    final letter = _keyboardService.getAlphabeticalJumpLetter(event);
    if (letter == null) return KeyEventResult.ignored;

    final newIndex = _keyboardService.findIndexByLetter(
      letter: letter,
      items: _filteredItems,
      getDisplayName: (item) => item.displayName,
    );

    if (newIndex == null) return KeyEventResult.ignored;
    setState(() {
      _selectedIndex = newIndex;
      _showNavigationHint = false;
    });
    if (_viewMode == ViewMode.grid) {
      final columns = _calculateCrossAxisCount(context);
      _scrollToIndexInGrid(newIndex, columns, centerItem: true);
    } else if (_viewMode == ViewMode.list) {
      _scrollToIndexInList(newIndex, centerItem: true);
    } else {
      _scrollToCarouselIndex(newIndex, centerItem: true);
    }

    _scheduleMediaLoad();

    return KeyEventResult.handled;
  }

  void _handleSelection() {
    final item = _filteredItems[_selectedIndex];

    if (item.isFolder) {
      _navigateToFolder(item);
    } else {
      if (_viewMode == ViewMode.carousel) {
        _handleRomLaunch(item);
      } else {
        _showRomDetailDialog(item);
      }
    }
  }

  /// Handle directional navigation based on current view mode
  KeyEventResult _handleDirectionalNavigation(LogicalKeyboardKey key) {
    if (_viewMode == ViewMode.grid) {
      return _handleGridNavigation(key);
    } else if (_viewMode == ViewMode.list) {
      return _handleListNavigation(key);
    } else {
      return _handleCarouselNavigationKeys(key);
    }
  }

  /// Handle grid-specific navigation
  KeyEventResult _handleGridNavigation(LogicalKeyboardKey key) {
    final columns = _calculateCrossAxisCount(context);
    final newIndex = _keyboardService.handleGridNavigation(
      key: key,
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
      columns: columns,
    );

    if (newIndex != null) {
      setState(() {
        _selectedIndex = newIndex;
      });
      _scrollToIndexInGrid(newIndex, columns);
      _scheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle list-specific navigation
  KeyEventResult _handleListNavigation(LogicalKeyboardKey key) {
    // Check for lateral platform navigation first (only in root, not in subdirectories)
    if (_currentSubdirectory == null && _pathHistory.isEmpty) {
      if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.keyQ) {
        _navigateToPreviousPlatform();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.keyE) {
        _navigateToNextPlatform();
        return KeyEventResult.handled;
      }
    }

    final newIndex = _keyboardService.handleListNavigation(
      key: key,
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
    );

    if (newIndex != null) {
      setState(() {
        _selectedIndex = newIndex;
      });
      _scrollToIndexInList(newIndex);
      _scheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle carousel-specific navigation
  KeyEventResult _handleCarouselNavigationKeys(LogicalKeyboardKey key) {
    final newIndex = _keyboardService.handleCarouselNavigation(
      key: key,
      currentIndex: _selectedIndex,
      itemCount: _filteredItems.length,
      loop: true,
    );

    if (newIndex != null) {
      if (_showNavigationHint) {
        setState(() {
          _showNavigationHint = false;
        });
      }
      setState(() {
        _selectedIndex = newIndex;
      });
      _scrollToCarouselIndex(_selectedIndex);
      _scheduleMediaLoad();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
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
                      ? TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search ROMs...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.keyboard,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showVirtualKeyboard = !_showVirtualKeyboard;
                                });
                              },
                              tooltip: 'Toggle virtual keyboard',
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: _onSearchChanged,
                        )
                      : _buildTitile(),
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

  Widget _buildTitile() {
    String? subFolder = _getCurrentFolderName();
    return Container(
      margin: const EdgeInsets.only(right: 1),
      child: Row(
        children: [
          Image.asset('assets/images/icon.png', width: 24, height: 24),
          Icon(Icons.chevron_right),
          _platformLogoPath != null
              ? SmartSvg.asset(
                  _platformLogoPath!,
                  height: 24,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) =>
                      Text(widget.platform.displayName),
                )
              : Text(widget.platform.displayName),
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
                _toggleViewMode();
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
                  Icon(_getViewModeIcon()),
                  const SizedBox(width: 12),
                  Text(_getViewModeTooltip()),
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
          icon: Icon(_getViewModeIcon()),
          onPressed: _toggleViewMode,
          tooltip: _getViewModeTooltip(),
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

    if (_viewMode == ViewMode.carousel) {
      return _buildCarouselView();
    } else if (_viewMode == ViewMode.list) {
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
      mediaCache: _mediaCache,
      mediaService: _mediaService,
      loadMediaForItem: _loadMediaForItem,
      onRomLaunch: _handleRomLaunch,
      showRomDetailDialog: _showRomDetailDialog,
      loadGameInfoForItem: _loadGameInfoForItem,
      gameInfoCache: _gameInfoCache,
      isRomDownloaded: _isRomDownloaded,
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
        _showRomDetailDialog(item);
        _scheduleMediaLoad();
      },
      onKeyEvent: _handleKeyEvent,
      mediaCache: _mediaCache,
      mediaService: _mediaService,
      loadMediaForItem: _loadMediaForItem,
      isRomDownloaded: _isRomDownloaded,
      platformName: widget.platform.name,
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
      mediaCache: _mediaCache,
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
      gameInfoCache: _gameInfoCache,
      isRomDownloaded: _isRomDownloaded,
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

    _loadMediaForItem(item);
    _loadGameInfoForItem(item);

    await RomDetailDialog.show(
      context: context,
      item: item,
      media: _mediaCache[item.name],
      gameInfo: _gameInfoCache[item.name],
      onPlay: () => _handleRomLaunch(item),
      onClose: _requestFocusForCurrentViewMode,
    );
  }

  /// Show media in fullscreen dialog
  Future<void> _showMediaDialog() async {
    if (_filteredItems.isEmpty) return;

    final item = _filteredItems[_selectedIndex];
    if (item.isFolder) return;

    // Load media if not cached
    if (!_mediaCache.containsKey(item.name)) {
      await _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];

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

    // Navigate to fullscreen image viewer
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => FullScreenImageViewer(
              imagePath: allMediaItems[firstImageIndex].path,
              allMedia: allMediaItems,
              initialIndex: firstImageIndex,
            ),
          ),
        )
        .then((_) {
          _requestFocusForCurrentViewMode();
        });
  }

  Future<void> _handleRomLaunch(RomItem item) async {
    final config = await _emulatorService.loadPlatformConfig(
      widget.platform.name,
    );

    if (config == null || config.commands.isEmpty) {
      _showErrorDialog(
        'No emulator configured for ${widget.platform.displayName}.\n\n'
        'Please add configuration for "${widget.platform.name}" in:\n'
        '${dotenv.env['EMULATORS_CONFIG_PATH']}',
      );
      return;
    }

    // If multiple commands, show selection dialog
    if (config.hasMultipleCommands) {
      final selectedCommand = await _showEmulatorSelectionDialog(config);
      if (selectedCommand == null) {
        return; // User cancelled
      }
      await _launchWithCommand(item, selectedCommand);
    } else {
      // Use default command
      await _launchWithCommand(item, config.defaultCommand!);
    }
  }

  Future<EmulatorCommand?> _showEmulatorSelectionDialog(
    EmulatorConfig config,
  ) async {
    return await EmulatorSelectionDialog.show(
      context: context,
      config: config,
      onClose: _requestFocusForCurrentViewMode,
    );
  }

  Future<void> _launchWithCommand(RomItem item, EmulatorCommand command) async {
    // Get media for this ROM to show marquee/boxart
    final media = _mediaCache[item.name];
    final imagePath = media != null
        ? _mediaService.getLaunchImagePath(media)
        : null;

    final isDownloading =
        item.downloadUrl != null && item.downloadUrl!.isNotEmpty;

    // Create dialog key to access state
    final GlobalKey<LaunchProgressDialogState> dialogKey = GlobalKey();
    bool wasCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LaunchProgressDialog(
        key: dialogKey,
        item: item,
        command: command,
        imagePath: imagePath,
        isDownloading: isDownloading,
        onCancel: isDownloading
            ? () {
                // Cancel the download
                _emulatorService.cancelDownload();
                wasCancelled = true;
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download cancelled'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              }
            : null,
      ),
    );

    try {
      final success = await _emulatorService.launchRom(
        romItem: item,
        platform: widget.platform.name,
        selectedCommand: command,
        onDownloadProgress: (progress, received, total) {
          // Update dialog progress
          dialogKey.currentState?.updateProgress(progress, received, total);
        },
      );

      if (!mounted) return;

      // Only close dialog if not already closed by cancel
      if (!wasCancelled) {
        Navigator.pop(context);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Launched: ${item.displayName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // If ROM was downloaded, ask if user wants to save it permanently
        if (isDownloading && !wasCancelled) {
          // Check if ROM is already in forever storage
          final storageService = RomStorageService.instance;
          final foreverPath = await storageService.findRomInForeverStorage(
            widget.platform.name,
            item.name,
          );

          // Only ask to save if not already in forever storage
          if (foreverPath == null) {
            await _askToSaveRomPermanently(item, imagePath);
          }
        }
      } else if (!wasCancelled) {
        _showErrorDialog(
          'Failed to launch ROM.\n\n'
          'Check that:\n'
          '• Emulator is installed correctly\n'
          '• ROM file is valid\n'
          '• Configuration is correct',
        );
      }
      _requestFocusForCurrentViewMode();
    } catch (e) {
      if (!mounted) return;
      if (!wasCancelled) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Error launching ROM: $e');
      }
      _requestFocusForCurrentViewMode();
    }
  }

  /// Ask user if they want to save ROM permanently after playing
  Future<void> _askToSaveRomPermanently(RomItem item, String? imagePath) async {
    // Show dialog asking if user wants to save ROM permanently
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaveRomDialog(item: item, imagePath: imagePath),
    );

    if (!mounted) return;

    // If user chose to save permanently
    if (result == true) {
      try {
        final storageService = RomStorageService.instance;

        // Move ROM from temp to forever storage
        final newPath = await storageService.moveToForeverStorage(
          widget.platform.name,
          item.name,
        );

        if (newPath != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.displayName} saved permanently'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () async {
                  // Move back to temp storage
                  await storageService.deleteFromForeverStorage(
                    widget.platform.name,
                    item.name,
                  );
                },
              ),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save ROM permanently'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving ROM: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      // User chose "Not Now" - ROM stays in temp storage for now
      // It will be cleaned up when downloading another ROM for this platform
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.displayName} kept in temporary storage'),
            backgroundColor: Colors.grey[700],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    _requestFocusForCurrentViewMode();
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

  void _showErrorDialog(String message) {
    ErrorDialog.show(
      context: context,
      message: message,
      onClose: _requestFocusForCurrentViewMode,
    );
  }

  void _requestScrollToIndexCurrentViewMode() {
    switch (_viewMode) {
      case ViewMode.list:
        _scrollToIndexInList(_selectedIndex);
        break;
      case ViewMode.carousel:
        _scrollToCarouselIndex(_selectedIndex);
        break;
      case ViewMode.grid:
        _scrollToIndexInGrid(_selectedIndex, _calculateCrossAxisCount(context));
        break;
    }
  }

  /// Get bottom bar actions based on current view mode and context
  List<BottomBarAction> _getBottomBarActions() {
    return RomsScreenBottomBarActions.getActions(
      isListView: _viewMode == ViewMode.list,
      isAtRoot: _pathHistory.isEmpty && _currentSubdirectory == null,
    );
  }
}
