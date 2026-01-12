import 'dart:async';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/services/media_service.dart';
import 'package:forsaken/services/gamelist_service.dart';
import 'package:forsaken/services/debug_service.dart';

/// Controller for ROM screen state and business logic
class RomsScreenController {
  final MediaService _mediaService;
  final GamelistService _gamelistService;
  final _debug = DebugService.instance;

  // Media loading control with debouncing
  Timer? _mediaLoadTimer;
  bool _isNavigating = false;
  final Set<int> _preloadedThumbnailIndices = {};

  // Caches
  final Map<String, RomMedia> _mediaCache = {};
  final Map<String, GameInfo> _gameInfoCache = {};

  RomsScreenController({
    required MediaService mediaService,
    required GamelistService gamelistService,
  }) : _mediaService = mediaService,
       _gamelistService = gamelistService;

  /// Get media cache
  Map<String, RomMedia> get mediaCache => _mediaCache;

  /// Get game info cache
  Map<String, GameInfo> get gameInfoCache => _gameInfoCache;

  /// Check if currently navigating
  bool get isNavigating => _isNavigating;

  /// Dispose resources
  void dispose() {
    _mediaLoadTimer?.cancel();
  }

  /// Clear all caches
  void clearCaches() {
    _mediaCache.clear();
    _gameInfoCache.clear();
    _preloadedThumbnailIndices.clear();
  }

  /// Load media for a specific ROM item
  Future<void> loadMediaForItem(
    RomItem item,
    String platformName,
    Function() onUpdate,
    bool Function() isMounted,
  ) async {
    if (_mediaCache.containsKey(item.name)) {
      return;
    }
    final media = await _mediaService.getMediaForRomItem(item, platformName);

    if (isMounted()) {
      _mediaCache[item.name] = media;
      onUpdate();
    }
  }

  /// Load game info for a specific ROM item
  Future<void> loadGameInfoForItem(
    RomItem item,
    String platformName,
    Function() onUpdate,
    bool Function() isMounted,
  ) async {
    // Check if already loaded
    if (_gameInfoCache.containsKey(item.name)) {
      return;
    }

    try {
      // Load game info from gamelist.xml
      final gameInfo = await _gamelistService.getGameInfo(
        platformName,
        item.path,
      );

      if (isMounted() && gameInfo != null) {
        _gameInfoCache[item.name] = gameInfo;
        onUpdate();
        _debug.info(
          'Loaded game info for ${item.name}: ${gameInfo.name}',
          tag: 'RomsScreenController',
        );
      }
    } catch (e) {
      _debug.error(
        'Failed to load game info for ${item.name}: $e',
        tag: 'RomsScreenController',
      );
    }
  }

  /// Schedule media loading after debounce delay (500ms)
  /// Loads full media for selected item and neighbors, thumbnails for wider range
  void scheduleMediaLoad({
    required List<RomItem> filteredItems,
    required int selectedIndex,
    required String platformName,
    required Function() onUpdate,
    required bool Function() isMounted,
  }) {
    // Cancel any pending load
    _mediaLoadTimer?.cancel();

    // Mark as navigating
    _isNavigating = true;
    onUpdate();

    // Schedule load after 500ms debounce delay
    _mediaLoadTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!isMounted()) return;

      // Reset navigation flag
      _isNavigating = false;
      onUpdate();

      // Validate index
      if (filteredItems.isEmpty || selectedIndex >= filteredItems.length) {
        return;
      }

      // Load media for selected item and immediate neighbors (±1)
      await _loadMediaForSelectedAndNeighbors(
        filteredItems: filteredItems,
        selectedIndex: selectedIndex,
        platformName: platformName,
        onUpdate: onUpdate,
        isMounted: isMounted,
      );

      // Schedule thumbnail preloading for wider range (±100)
      _scheduleThumbnailPreload(
        filteredItems: filteredItems,
        selectedIndex: selectedIndex,
        platformName: platformName,
        onUpdate: onUpdate,
        isMounted: isMounted,
      );
    });
  }

  /// Load full media for selected item and immediate neighbors (±1)
  Future<void> _loadMediaForSelectedAndNeighbors({
    required List<RomItem> filteredItems,
    required int selectedIndex,
    required String platformName,
    required Function() onUpdate,
    required bool Function() isMounted,
  }) async {
    if (filteredItems.isEmpty) return;

    // Selected item
    final selectedItem = filteredItems[selectedIndex];
    if (selectedItem.isRom) {
      await loadMediaForItem(selectedItem, platformName, onUpdate, isMounted);
      await loadGameInfoForItem(
        selectedItem,
        platformName,
        onUpdate,
        isMounted,
      );
    }

    // Previous item
    if (selectedIndex > 0) {
      final prevItem = filteredItems[selectedIndex - 1];
      if (prevItem.isRom) {
        await loadMediaForItem(prevItem, platformName, onUpdate, isMounted);
      }
    }

    // Next item
    if (selectedIndex < filteredItems.length - 1) {
      final nextItem = filteredItems[selectedIndex + 1];
      if (nextItem.isRom) {
        await loadMediaForItem(nextItem, platformName, onUpdate, isMounted);
      }
    }
  }

  /// Preload thumbnails for items in range ±20/100 (background, low priority)
  void _scheduleThumbnailPreload({
    required List<RomItem> filteredItems,
    required int selectedIndex,
    required String platformName,
    required Function() onUpdate,
    required bool Function() isMounted,
  }) {
    // For very large lists (>5000 items), reduce preload range to avoid performance issues
    final preloadRange = filteredItems.length > 5000 ? 20 : 100;

    // Wait additional 100ms before starting background preload
    Timer(const Duration(milliseconds: 100), () async {
      if (!isMounted() || _isNavigating) return;

      final startIndex = (selectedIndex - preloadRange).clamp(
        0,
        filteredItems.length - 1,
      );
      final endIndex = (selectedIndex + preloadRange).clamp(
        0,
        filteredItems.length - 1,
      );

      // Load thumbnails for items not already loaded
      for (int i = startIndex; i <= endIndex; i++) {
        // Skip if navigating started again
        if (_isNavigating) break;

        // Skip if already preloaded
        if (_preloadedThumbnailIndices.contains(i)) continue;

        final item = filteredItems[i];
        if (item.isRom && !_mediaCache.containsKey(item.name)) {
          await loadMediaForItem(item, platformName, onUpdate, isMounted);
          _preloadedThumbnailIndices.add(i);

          // Larger delay for very large lists to avoid I/O saturation
          final delayMs = filteredItems.length > 5000 ? 100 : 50;
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }
    });
  }
}
