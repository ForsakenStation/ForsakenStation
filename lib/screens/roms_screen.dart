import 'dart:ui';

import 'package:forsaken/screens/roms/roms_carousel_view.dart';
import 'package:forsaken/screens/roms/roms_grid_view.dart';
import 'package:forsaken/screens/roms/roms_list_view.dart';
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
import 'package:forsaken/widgets/common/info_row.dart';
import 'package:forsaken/widgets/roms/media_carousel.dart';
import 'package:forsaken/widgets/common/theme_selector.dart';
import 'package:forsaken/widgets/common/help_dialog.dart';
import 'package:forsaken/widgets/common/placeholder_image.dart';
import 'package:forsaken/widgets/common/virtual_keyboard.dart';
import 'package:forsaken/widgets/common/navigation_overlay.dart';
import 'package:forsaken/widgets/common/smart_svg.dart';
import 'package:forsaken/widgets/roms/launch_progress_dialog.dart';
import 'package:forsaken/widgets/roms/save_rom_dialog.dart';
import 'package:forsaken/services/rom_storage_service.dart';

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
  Map<String, RomMedia> _mediaCache = {};
  Map<String, GameInfo> _gameInfoCache = {};
  Map<String, bool> _downloadedRomsCache =
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

  @override
  void initState() {
    super.initState();
    _currentPath = widget.platform.path;
    _currentSubdirectory = null; // Start at root for JSONL platforms
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
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestFocusForCurrentViewMode();
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
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredItems = _items;
      _isSearchMode = false;
      _filteredItems = _items;
      _selectedIndex = 0;
    });
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

  void _scrollToIndexInGrid(int index, int columns) {
    if (!_gridScrollController.hasClients) return;

    // Calculate item dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 16 * 2 - 16 * (columns - 1)) / columns;
    final itemHeight = itemWidth / 0.7; // Based on childAspectRatio

    // Calculate row
    final row = index ~/ columns;
    final rowOffset = row * (itemHeight + 16);

    // Get viewport height
    final viewportHeight = _gridScrollController.position.viewportDimension;
    final currentScroll = _gridScrollController.offset;
    final maxScroll = _gridScrollController.position.maxScrollExtent;

    // Calculate item position
    final itemTop = rowOffset;
    final itemBottom = rowOffset + itemHeight;

    // Scroll if needed
    if (itemTop < currentScroll) {
      _gridScrollController.animateTo(
        itemTop - 16,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (itemBottom > currentScroll + viewportHeight) {
      final targetScroll = itemBottom - viewportHeight + 16;
      _gridScrollController.animateTo(
        targetScroll.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToIndexInList(int index) {
    if (!_listScrollController.hasClients) return;

    // Approximate item height (card height)
    const itemHeight = 56.0 + 8.0; // ListTile height + margin

    final itemOffset = index * itemHeight;
    final viewportHeight = _listScrollController.position.viewportDimension;
    final currentScroll = _listScrollController.offset;
    final maxScroll = _listScrollController.position.maxScrollExtent;

    // Calculate item bounds
    final itemTop = itemOffset;
    final itemBottom = itemOffset + itemHeight;

    // Scroll if needed
    if (itemTop < currentScroll) {
      _listScrollController.animateTo(
        itemTop - 8,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (itemBottom > currentScroll + viewportHeight) {
      final targetScroll = itemBottom - viewportHeight + 8;
      _listScrollController.animateTo(
        targetScroll.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
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

  /// Handles common keyboard shortcuts (R, V, S) that work across all view modes
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
      _scrollToIndexInGrid(newIndex, columns);
    } else if (_viewMode == ViewMode.list) {
      _scrollToIndexInList(newIndex);
    } else {
      _scrollToCarouselIndex(newIndex);
    }

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
              ],
            ),

            // Navigation overlay
            NavigationOverlay(
              screenName:
                  '${widget.platform.displayName} - ${_viewMode.name.toUpperCase()} View',
              keyboardControls: _getKeyboardControls(),
              gamepadControls: _getGamepadControls(),
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
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
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
      },
      showNavigationHint: _showNavigationHint,
      loadGameInfoForItem: _loadGameInfoForItem,
      gameInfoCache: _gameInfoCache,
      isRomDownloaded: _isRomDownloaded,
    );
  }

  void _scrollToCarouselIndex(int index) {
    if (!_carouselController.hasClients) return;

    const cardWidth = 180.0 + 16.0; // Card width + padding
    final itemOffset = index * cardWidth;
    final viewportWidth = _carouselController.position.viewportDimension;
    final currentScroll = _carouselController.offset;
    final maxScroll = _carouselController.position.maxScrollExtent;

    // Calculate item bounds
    final itemLeft = itemOffset;
    final itemRight = itemOffset + cardWidth;

    // Scroll if needed
    if (itemLeft < currentScroll) {
      _carouselController.animateTo(
        itemLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (itemRight > currentScroll + viewportWidth) {
      final targetScroll = itemRight - viewportWidth;
      _carouselController.animateTo(
        targetScroll.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showRomDetailDialog(RomItem item) async {
    if (item.isFolder) {
      _navigateToFolder(item);
      return;
    }

    // Load media if not cached
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    // Load game info if not cached (lazy loading)
    if (!_gameInfoCache.containsKey(item.name)) {
      _loadGameInfoForItem(item);
    }

    final media = _mediaCache[item.name];
    final gameInfo = _gameInfoCache[item.name];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
          child: Column(
            children: [
              // Header
              AppBar(
                title: Text(gameInfo?.name ?? item.displayName),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                automaticallyImplyLeading: false,
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (media != null)
                        MediaCarousel(media: media, height: 400)
                      else
                        Center(child: PlaceholderImage(size: 300)),
                      const SizedBox(height: 16),
                      InfoRow(
                        label: 'Description',
                        value:
                            gameInfo?.desc ??
                            'No description available for this ROM.',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Release Date',
                              value:
                                  gameInfo?.releaseDate?.toString().split(
                                    ' ',
                                  )[0] ??
                                  '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Developer',
                              value: gameInfo?.developer ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Publisher',
                              value: gameInfo?.publisher ?? '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Genre',
                              value: gameInfo?.genre ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Players',
                              value: gameInfo?.playersText ?? '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Rating',
                              value: gameInfo?.ratingPercentage ?? '--',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleRomLaunch(item);
                      },
                      icon: Icon(Icons.gamepad),
                      label: Text('Play'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
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
    final result = await showDialog<EmulatorCommand>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Emulator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: config.commands.map((command) {
            return ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: Text(command.name),
              subtitle: Text(command.command),
              onTap: () => Navigator.pop(context, command),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    // Request focus back after dialog closes
    _requestFocusForCurrentViewMode();

    return result;
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {
      _requestFocusForCurrentViewMode();
    });
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

  /// Get keyboard controls for navigation overlay
  Map<String, String> _getKeyboardControls() {
    final baseControls = {
      '↑↓': 'Navigate ROMs',
      'Enter': 'Select ROM',
      'Backspace': 'Go back / Clear search',
      'R': 'Random ROM',
      'V': 'Change view mode',
      'S': 'Search',
      'Shift+Letter': 'Jump to letter',
      'Shift+?': 'Show help',
    };

    if (_viewMode == ViewMode.list &&
        _pathHistory.isEmpty &&
        _currentSubdirectory == null) {
      baseControls['←→ / Q E'] = 'Change platform';
    }

    if (_viewMode == ViewMode.grid) {
      baseControls['←→'] = 'Navigate horizontally';
      baseControls['↑↓'] = 'Navigate vertically';
    }

    return baseControls;
  }

  /// Get gamepad controls for navigation overlay
  Map<String, String> _getGamepadControls() {
    final baseControls = {
      'D-Pad': 'Navigate',
      'A / X': 'Select ROM',
      'B / Circle': 'Go back',
      'Y / Square': 'Random ROM',
      'Start': 'Search',
      'Select': 'Change view',
    };

    if (_viewMode == ViewMode.list &&
        _pathHistory.isEmpty &&
        _currentSubdirectory == null) {
      baseControls['L1 / R1'] = 'Change platform';
    }

    if (_viewMode == ViewMode.grid) {
      baseControls['D-Pad'] = 'Navigate grid';
    }

    return baseControls;
  }
}
