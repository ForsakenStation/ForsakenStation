import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/platform.dart';
import '../models/rom_item.dart';
import '../models/media.dart';
import '../models/emulator_config.dart';
import '../services/rom_service.dart';
import '../services/media_service.dart';
import '../services/emulator_service.dart';
import '../services/download_service.dart';
import '../services/keyboard_service.dart';
import '../widgets/roms/media_carousel.dart';
import '../widgets/common/theme_selector.dart';

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
  final List<String> _pathHistory = [];
  bool _isLoading = true;
  ViewMode _viewMode = ViewMode.grid;
  RomItem? _selectedRom;
  int _selectedIndex = 0;
  Map<String, RomMedia> _mediaCache = {};
  late MediaService _mediaService;
  late EmulatorService _emulatorService;
  late DownloadService _downloadService;
  late KeyboardService _keyboardService;
  late ScrollController _carouselController;
  late ScrollController _gridScrollController;
  late ScrollController _listScrollController;
  late FocusNode _carouselFocusNode;
  late FocusNode _gridFocusNode;
  late FocusNode _listFocusNode;
  int _carouselCurrentIndex = 0;
  bool _showNavigationHint = true; // Show hint initially

  // Search/filter functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchMode = false;
  String folderImagePath = '';

  @override
  void initState() {
    super.initState();
    _currentPath = widget.platform.path;
    final mediaPath = dotenv.env['MEDIA_PATH'] ?? '';
    final romsPath = dotenv.env['ROMS_PATH'] ?? '';
    final emulatorsPath = dotenv.env['EMULATORS_PATH'] ?? '';
    final configPath = dotenv.env['EMULATORS_CONFIG_PATH'] ?? '';
    folderImagePath = path.join(mediaPath, '_system', '_default.png');

    _mediaService = MediaService(mediaBasePath: mediaPath);
    _downloadService = DownloadService(romsBasePath: romsPath);
    _emulatorService = EmulatorService(
      emulatorsBasePath: emulatorsPath,
      configFilePath: configPath,
      downloadService: _downloadService,
    );
    _keyboardService = KeyboardService.instance;
    _carouselController = ScrollController();
    _gridScrollController = ScrollController();
    _listScrollController = ScrollController();
    _carouselFocusNode = FocusNode();
    _gridFocusNode = FocusNode();
    _listFocusNode = FocusNode();
    _loadItems();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _gridScrollController.dispose();
    _listScrollController.dispose();
    _carouselFocusNode.dispose();
    _gridFocusNode.dispose();
    _listFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    final items = await widget.romService.loadItemsInDirectory(_currentPath);

    if (mounted) {
      setState(() {
        _items = items;
        // Reset search when loading new directory
        _searchController.clear();
        _searchQuery = '';
        _isSearchMode = false;
        _filteredItems = items;
        _isLoading = false;
        _selectedRom = null;
        _selectedIndex = 0;
        // Clear media cache to force reload for new directory
        _mediaCache.clear();
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
      _searchQuery = query;
      _filteredItems = _filterItems(_items, query);
      _selectedRom = null;
      _selectedIndex = 0;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearchMode = false;
      _filteredItems = _items;
      _selectedRom = null;
      _selectedIndex = 0;
    });
  }

  void _activateSearchMode() {
    setState(() {
      _isSearchMode = true;
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
    const itemHeight = 72.0 + 8.0; // ListTile height + margin

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
    // Check if already loaded
    if (_mediaCache.containsKey(item.name)) {
      return;
    }

    // Load media
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

  void _navigateToFolder(RomItem folder) {
    _pathHistory.add(_currentPath);
    setState(() {
      _currentPath = folder.path;
    });
    _loadItems();
  }

  void _navigateBack() {
    if (_pathHistory.isNotEmpty) {
      setState(() {
        _currentPath = _pathHistory.removeLast();
      });
      _loadItems();
    } else {
      Navigator.pop(context);
    }
  }

  String _getCurrentFolderName() {
    if (_currentPath == widget.platform.path) {
      return "Forsaken Roms: ${widget.platform.displayName}";
    }
    return path.basename(_currentPath);
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
          _carouselCurrentIndex = 0;
          _carouselController = ScrollController();
          break;
        case ViewMode.carousel:
          _viewMode = ViewMode.grid;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return WillPopScope(
      onWillPop: () async {
        if (_pathHistory.isNotEmpty) {
          _navigateBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateBack,
          ),
          title: _isSearchMode
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search ROMs...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.6),
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onChanged: _onSearchChanged,
                )
              : Text(_getCurrentFolderName()),
          actions: [
            const ThemeSelector(),
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
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(isWideScreen),
      ),
    );
  }

  Widget _buildBody(bool isWideScreen) {
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
    } else if (_viewMode == ViewMode.list && isWideScreen) {
      return _buildListWithDetail();
    } else if (_viewMode == ViewMode.list) {
      return _buildListView();
    } else {
      return _buildGridView();
    }
  }

  Widget _buildListWithDetail() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildListView()),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: _selectedRom != null
              ? _buildDetailPanel(_selectedRom!)
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Select a ROM to view details',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDetailPanel(RomItem item) {
    // Trigger media loading if not loaded
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    return SingleChildScrollView(
      key: ValueKey(item.path), // Force rebuild when ROM changes
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media carousel
          if (media != null)
            MediaCarousel(
              key: ValueKey('${item.path}_carousel'),
              media: media,
              height: 300,
            )
          else
            Center(child: _buildPlaceholderImage(200)),
          const SizedBox(height: 24),
          // ROM Name
          Text(
            item.displayName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Type
          _buildInfoRow('Type', isLocalFile ? 'Local File' : 'Download URL'),
          const SizedBox(height: 8),
          // Path/URL
          _buildInfoRow(
            isLocalFile ? 'Path' : 'Download URL',
            isLocalFile ? item.path : item.downloadUrl!,
          ),
          const SizedBox(height: 24),
          // Launch button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleRomLaunch(item),
              icon: Icon(isLocalFile ? Icons.play_arrow : Icons.download),
              label: Text(isLocalFile ? 'Launch' : 'Download & Launch'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildListView() {
    return Focus(
      focusNode: _listFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        final key = event.logicalKey;

        // Handle back navigation
        if (_keyboardService.isBackKey(key)) {
          _navigateBack();
          return KeyEventResult.handled;
        }

        // Handle selection
        if (_keyboardService.isSelectKey(key)) {
          final item = _filteredItems[_selectedIndex];
          if (item.isFolder) {
            _navigateToFolder(item);
          } else {
            _showRomDetailDialog(item);
          }
          return KeyEventResult.handled;
        }

        // Handle navigation
        final newIndex = _keyboardService.handleListNavigation(
          key: key,
          currentIndex: _selectedIndex,
          itemCount: _filteredItems.length,
        );

        if (newIndex != null) {
          setState(() {
            _selectedIndex = newIndex;
            _selectedRom = _filteredItems[newIndex];
          });
          _scrollToIndexInList(newIndex);
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: ListView.builder(
        controller: _listScrollController,
        padding: const EdgeInsets.all(8),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          final isSelected = index == _selectedIndex;
          return _buildListItem(item, isSelected);
        },
      ),
    );
  }

  Widget _buildListItem(RomItem item, bool isSelected) {
    // Trigger lazy loading of media
    if (item.isRom && !_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];
    final imagePath = media != null
        ? _mediaService.getBestImagePath(media)
        : null;
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isSelected ? 8 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : null,
      child: ListTile(
        leading: item.isFolder
            ? _buildThumbnail(folderImagePath)
            : _buildThumbnail(imagePath),
        title: Text(
          item.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: item.isFolder
            ? const Text('Folder')
            : Text(
                isLocalFile ? 'Local file' : item.downloadUrl!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
        trailing: Icon(
          item.isFolder
              ? Icons.chevron_right
              : (isLocalFile ? Icons.play_arrow : Icons.download),
          color: Colors.grey[600],
        ),
        onTap: () {
          if (item.isFolder) {
            _navigateToFolder(item);
          } else {
            setState(() {
              _selectedRom = item;
              _selectedIndex = _filteredItems.indexOf(item);
            });
          }
        },
      ),
    );
  }

  Widget _buildGridView() {
    return Focus(
      focusNode: _gridFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        final key = event.logicalKey;

        // Handle back navigation
        if (_keyboardService.isBackKey(key)) {
          _navigateBack();
          return KeyEventResult.handled;
        }

        // Handle selection
        if (_keyboardService.isSelectKey(key)) {
          final item = _filteredItems[_selectedIndex];
          if (item.isFolder) {
            _navigateToFolder(item);
          } else {
            _showRomDetailDialog(item);
          }
          return KeyEventResult.handled;
        }

        // Handle navigation
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
            _selectedRom = _filteredItems[newIndex];
          });
          _scrollToIndexInGrid(newIndex, columns);
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: GridView.builder(
        controller: _gridScrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return _buildGridCard(item);
        },
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

  Widget _buildGridCard(RomItem item) {
    if (item.isFolder) {
      return _buildFolderCard(item);
    }

    // Trigger lazy loading of media
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];
    final imagePath = media != null
        ? _mediaService.getBestImagePath(media)
        : null;
    final isSelected = _selectedRom == item;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showRomDetailDialog(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imagePath != null
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage(null);
                      },
                    )
                  : _buildPlaceholderImage(null),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderCard(RomItem item) {
    final isSelected = _selectedRom == item;

    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _navigateToFolder(item),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder, size: 64, color: Colors.amber),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.displayName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselView() {
    return Focus(
      focusNode: _carouselFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            if (_showNavigationHint) {
              setState(() {
                _showNavigationHint = false;
              });
            }
            setState(() {
              // Infinite carousel: wrap to end if at beginning
              if (_carouselCurrentIndex > 0) {
                _carouselCurrentIndex--;
              } else {
                _carouselCurrentIndex = _filteredItems.length - 1;
              }
              _selectedRom = _filteredItems[_carouselCurrentIndex];
            });
            _scrollToCarouselIndex(_carouselCurrentIndex);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (_showNavigationHint) {
              setState(() {
                _showNavigationHint = false;
              });
            }
            setState(() {
              // Infinite carousel: wrap to beginning if at end
              if (_carouselCurrentIndex < _filteredItems.length - 1) {
                _carouselCurrentIndex++;
              } else {
                _carouselCurrentIndex = 0;
              }
              _selectedRom = _filteredItems[_carouselCurrentIndex];
            });
            _scrollToCarouselIndex(_carouselCurrentIndex);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            final item = _filteredItems[_carouselCurrentIndex];
            if (item.isFolder) {
              _navigateToFolder(item);
            } else {
              _handleRomLaunch(item);
            }
            return KeyEventResult.handled;
          } else if (_keyboardService.isBackKey(event.logicalKey)) {
            _navigateBack();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          // Top section: ROM details (2/3 of screen)
          Expanded(flex: 2, child: _buildCarouselDetailPanel()),
          // Bottom section: Horizontal carousel of ROM cards (280px height)
          SizedBox(height: 280, child: _buildCarouselCards()),
        ],
      ),
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

  Widget _buildCarouselDetailPanel() {
    final item = _filteredItems[_carouselCurrentIndex];

    if (item.isFolder) {
      return Center(
        key: ValueKey('folder_${item.path}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder, size: 128, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              item.displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _navigateToFolder(item),
              icon: const Icon(Icons.folder_open),
              label: const Text('Open Folder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Trigger lazy loading of media
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
      // Show loading while media loads
      return Center(
        key: ValueKey('loading_${item.path}'),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading media...'),
          ],
        ),
      );
    }

    final media = _mediaCache[item.name];
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    return LayoutBuilder(
      key: ValueKey('detail_${item.path}'),
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight - 48; // Subtract padding

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Media (2/3 width)
              Expanded(
                flex: 2,
                child: media != null
                    ? MediaCarousel(
                        key: ValueKey('carousel_${item.path}'),
                        media: media,
                        height: availableHeight,
                      )
                    : Center(child: _buildPlaceholderImage(300)),
              ),
              const SizedBox(width: 24),
              // Right side: Info and actions (1/3 width)
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ROM title
                      Text(
                        item.displayName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Type
                      _buildInfoRow(
                        'Type',
                        isLocalFile ? 'Local File' : 'Download URL',
                      ),
                      const SizedBox(height: 12),
                      // Description section
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No description available for this ROM.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleRomLaunch(item),
                          icon: Icon(
                            isLocalFile ? Icons.play_arrow : Icons.download,
                          ),
                          label: Text(
                            isLocalFile ? 'Launch' : 'Download & Launch',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showRomDetailDialog(item),
                          icon: const Icon(Icons.info_outline),
                          label: const Text('More Details'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarouselCards() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          ListView.builder(
            controller: _carouselController,
            scrollDirection: Axis.horizontal,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              final isSelected = index == _carouselCurrentIndex;
              return _buildCarouselCard(item, isSelected, index);
            },
          ),
          // Position indicator
          Positioned(
            bottom: 8,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_carouselCurrentIndex + 1} / ${_filteredItems.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Navigation hint
          if (_showNavigationHint)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Use arrow keys or swipe to navigate',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselCard(RomItem item, bool isSelected, int index) {
    const cardWidth = 180.0;
    const cardHeight = cardWidth / 0.7; // Maintain 0.7 aspect ratio like grid

    if (item.isFolder) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Card(
            elevation: isSelected ? 8 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    )
                  : BorderSide.none,
            ),
            child: InkWell(
              onTap: () => _navigateToFolder(item),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder, size: 64, color: Colors.amber),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Trigger lazy loading of media
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];
    final imagePath = media != null
        ? _mediaService.getBestImagePath(media)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: isSelected ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _carouselCurrentIndex = index;
                _selectedRom = item;
              });
              _scrollToCarouselIndex(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage(null);
                          },
                        )
                      : _buildPlaceholderImage(null),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? imagePath) {
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(imagePath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage(60);
          },
        ),
      );
    }
    return _buildPlaceholderImage(60);
  }

  Widget _buildPlaceholderImage(double? size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(
        Icons.videogame_asset,
        size: size != null ? size * 0.5 : 48,
        color: Colors.grey[600],
      ),
    );
  }

  void _showRomDetailDialog(RomItem item) {
    // Ensure media is loaded
    if (!_mediaCache.containsKey(item.name)) {
      _loadMediaForItem(item);
    }

    final media = _mediaCache[item.name];
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
          child: Column(
            children: [
              // Header
              AppBar(
                title: Text(item.displayName),
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
                      // Media carousel
                      if (media != null)
                        MediaCarousel(media: media, height: 400)
                      else
                        Center(child: _buildPlaceholderImage(300)),
                      const SizedBox(height: 24),
                      // Type
                      Text(
                        'Type',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(isLocalFile ? 'Local File' : 'Download URL'),
                      const SizedBox(height: 16),
                      // Path/URL
                      Text(
                        isLocalFile ? 'Path' : 'Download URL',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        isLocalFile ? item.path : item.downloadUrl!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
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
                      icon: Icon(
                        isLocalFile ? Icons.play_arrow : Icons.download,
                      ),
                      label: Text(isLocalFile ? 'Launch' : 'Download'),
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
    );
  }

  Future<void> _handleRomLaunch(RomItem item) async {
    // Load emulator config for platform
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
    return showDialog<EmulatorCommand>(
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
  }

  Future<void> _launchWithCommand(RomItem item, EmulatorCommand command) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(item.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              item.downloadUrl != null && item.downloadUrl!.isNotEmpty
                  ? 'Downloading & Launching...'
                  : 'Launching...',
            ),
            const SizedBox(height: 8),
            Text(
              'Emulator: ${command.name}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );

    try {
      final success = await _emulatorService.launchRom(
        romItem: item,
        platform: widget.platform.name,
        selectedCommand: command,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Launched: ${item.displayName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        _showErrorDialog(
          'Failed to launch ROM.\n\n'
          'Check that:\n'
          '• Emulator is installed correctly\n'
          '• ROM file is valid\n'
          '• Configuration is correct',
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Error launching ROM: $e');
    }
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
    );
  }
}

// Media Carousel Widget
