import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../models/rom_item.dart';
import '../../../models/media.dart';
import '../../../models/game_info.dart';
import '../../../models/emulator_platform.dart';
import '../../../services/media_service.dart';
import '../../../services/gamelist_service.dart';
import '../../../services/rom_service.dart';
import '../../../services/debug_service.dart';

/// Controller for ROM screen state and business logic
class RomsScreenController extends ChangeNotifier {
  final MediaService _mediaService;
  final GamelistService _gamelistService;
  final RomService _romService;
  final _debug = DebugService.instance;

  // State
  List<RomItem> _items = [];
  List<RomItem> _filteredItems = [];
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _searchQuery = '';

  // Media loading control with debouncing
  Timer? _mediaLoadTimer;
  Timer? _preloadTimer;
  bool _isNavigating = false;
  bool _isDisposed = false;
  final Set<int> _preloadedThumbnailIndices = {};

  // Caches
  final Map<String, RomMedia> _mediaCache = {};
  final Map<String, GameInfo> _gameInfoCache = {};

  RomsScreenController({
    required MediaService mediaService,
    required GamelistService gamelistService,
    required RomService romService,
  }) : _mediaService = mediaService,
       _gamelistService = gamelistService,
       _romService = romService;

  // Getters
  List<RomItem> get items => _items;
  List<RomItem> get filteredItems => _filteredItems;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Map<String, RomMedia> get mediaCache => _mediaCache;
  Map<String, GameInfo> get gameInfoCache => _gameInfoCache;
  bool get isNavigating => _isNavigating;

  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      notifyListeners();
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _isDisposed = true;
    _mediaLoadTimer?.cancel();
    _preloadTimer?.cancel();
    super.dispose();
  }

  /// Load items for a platform and path
  Future<void> loadItems({
    required EmulatorPlatform platform,
    required String currentPath,
    String? currentSubdirectory,
    bool isCollection = false,
  }) async {
    _isLoading = true;
    _selectedIndex = 0;
    _items = [];
    _filteredItems = [];
    clearCaches();
    notifyListeners();

    try {
      if (isCollection) {
        _items = platform.roms.map((rom) {
          return RomItem(
            name: rom.name,
            path: rom.localPath ?? rom.urlFilePath,
            type: RomItemType.rom,
            downloadUrl: rom.downloadUrl,
            platform: rom.platform,
          );
        }).toList();
      } else if (platform.isJsonlPlatform) {
        final roms = await _romService.loadRomsForJsonlPlatform(platform.name);
        _items = await _romService.loadItemsFromRoms(
          roms,
          currentSubdirectory,
          platform.name,
        );
      } else {
        _items = await _romService.loadItemsInDirectory(
          currentPath,
          platform.name,
        );
      }

      await _updateDisplayNames(platform.name);
      _sortItems();
      _updateFilteredItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _debug.error('Error loading ROM items: $e', tag: 'RomsScreenController');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateDisplayNames(String platformName) async {
    for (var item in _items) {
      if (item.isRom) {
        final actualPlatform = item.platform ?? platformName;
        final gameInfo = await _gamelistService.getGameInfo(
          actualPlatform,
          item.path,
        );
        if (gameInfo != null && gameInfo.name.isNotEmpty) {
          item.setGameInfo(gameInfo);
          _gameInfoCache[item.name] = gameInfo;
        }
      }
    }
  }

  /// Re-sort items: folders first, then alphabetically by displayName
  void _sortItems() {
    _items.sort((a, b) {
      if (a.isFolder && !b.isFolder) return -1;
      if (!a.isFolder && b.isFolder) return 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
  }

  /// Update search query and filter items
  void setSearchQuery(String query) {
    _searchQuery = query;
    _updateFilteredItems();
    _selectedIndex = 0;
    notifyListeners();
  }

  void _updateFilteredItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredItems = _items.where((item) {
        return item.displayName.toLowerCase().contains(query);
      }).toList();
    }
  }

  /// Clear all caches
  void clearCaches() {
    _mediaCache.clear();
    _gameInfoCache.clear();
    _preloadedThumbnailIndices.clear();
  }

  /// Load media for a specific ROM item
  Future<void> loadMediaForItem(RomItem item, String platformName) async {
    if (_isDisposed || _mediaCache.containsKey(item.name)) {
      return;
    }

    final actualPlatform = item.platform ?? platformName;

    // Pass GameInfo to MediaService for fast cached-path lookup
    final gameInfo = item.gameInfo ?? _gameInfoCache[item.name];
    final media = await _mediaService.getMediaForRomItem(
      item,
      actualPlatform,
      gameInfo: gameInfo,
    );

    if (_isDisposed) return;
    _mediaCache[item.name] = media;
    notifyListeners();
  }

  /// Load game info for a specific ROM item
  Future<void> loadGameInfoForItem(RomItem item, String platformName) async {
    if (_isDisposed || _gameInfoCache.containsKey(item.name)) {
      return;
    }

    try {
      final actualPlatform = item.platform ?? platformName;
      final gameInfo = await _gamelistService.getGameInfo(
        actualPlatform,
        item.path,
      );

      if (_isDisposed) return;
      if (gameInfo != null) {
        _gameInfoCache[item.name] = gameInfo;
        notifyListeners();
      }
    } catch (e) {
      _debug.error(
        'Failed to load game info for ${item.name}: $e',
        tag: 'RomsScreenController',
      );
    }
  }

  /// Schedule media loading after debounce delay
  void scheduleMediaLoad({
    required String platformName,
    required bool Function() isMounted,
  }) {
    _mediaLoadTimer?.cancel();
    _isNavigating = true;
    notifyListeners();

    _mediaLoadTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_isDisposed || !isMounted()) return;

      _isNavigating = false;
      notifyListeners();

      if (_filteredItems.isEmpty || _selectedIndex >= _filteredItems.length) {
        return;
      }

      await _loadMediaForSelectedAndNeighbors(platformName, isMounted);
      _scheduleThumbnailPreload(platformName, isMounted);
    });
  }

  Future<void> _loadMediaForSelectedAndNeighbors(
    String platformName,
    bool Function() isMounted,
  ) async {
    if (_filteredItems.isEmpty) return;

    final selectedItem = _filteredItems[_selectedIndex];
    if (selectedItem.isRom) {
      await loadMediaForItem(selectedItem, platformName);
      await loadGameInfoForItem(selectedItem, platformName);
    }

    if (_selectedIndex > 0) {
      final prevItem = _filteredItems[_selectedIndex - 1];
      if (prevItem.isRom) await loadMediaForItem(prevItem, platformName);
    }

    if (_selectedIndex < _filteredItems.length - 1) {
      final nextItem = _filteredItems[_selectedIndex + 1];
      if (nextItem.isRom) await loadMediaForItem(nextItem, platformName);
    }
  }

  void _scheduleThumbnailPreload(
    String platformName,
    bool Function() isMounted,
  ) {
    final preloadRange = _filteredItems.length > 5000 ? 20 : 100;

    _preloadTimer?.cancel();
    _preloadTimer = Timer(const Duration(milliseconds: 100), () async {
      if (_isDisposed || !isMounted() || _isNavigating) return;

      final startIndex = (_selectedIndex - preloadRange).clamp(
        0,
        _filteredItems.length - 1,
      );
      final endIndex = (_selectedIndex + preloadRange).clamp(
        0,
        _filteredItems.length - 1,
      );

      for (int i = startIndex; i <= endIndex; i++) {
        if (_isDisposed || _isNavigating) break;
        if (_preloadedThumbnailIndices.contains(i)) continue;

        final item = _filteredItems[i];
        if (item.isRom && !_mediaCache.containsKey(item.name) && isMounted()) {
          await loadMediaForItem(item, platformName);
          if (_isDisposed) break;
          _preloadedThumbnailIndices.add(i);
          await Future.delayed(
            Duration(milliseconds: _filteredItems.length > 5000 ? 100 : 50),
          );
        }
      }
    });
  }
}
