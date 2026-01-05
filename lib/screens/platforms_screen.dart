import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/platform.dart';
import '../services/rom_service.dart';
import '../services/media_service.dart';
import '../services/keyboard_service.dart';
import '../utils/platform_icons.dart';
import '../widgets/platforms/platform_card.dart';
import '../widgets/common/theme_selector.dart';
import '../widgets/common/help_dialog.dart';
import 'roms_screen.dart';

enum ViewMode { grid, carousel }

class PlatformsScreen extends StatefulWidget {
  final RomService romService;

  const PlatformsScreen({super.key, required this.romService});

  @override
  State<PlatformsScreen> createState() => _PlatformsScreenState();
}

class _PlatformsScreenState extends State<PlatformsScreen> {
  List<Platform> _platforms = [];
  bool _isLoading = true;
  String? _errorMessage;
  late MediaService _mediaService;
  late KeyboardService _keyboardService;
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
    _carouselController = PageController();
    _gridScrollController = ScrollController();
    _carouselFocusNode = FocusNode();
    _gridFocusNode = FocusNode();
    _loadPlatforms();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _gridScrollController.dispose();
    _carouselFocusNode.dispose();
    _gridFocusNode.dispose();
    super.dispose();
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
      final platforms = await widget.romService.loadPlatforms();
      if (mounted) {
        setState(() {
          _platforms = platforms;
          _isLoading = false;
        });

        // Request focus after loading platforms
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _requestFocusForCurrentViewMode();
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

  Future<void> _loadSystemImage(String platformName) async {
    if (_systemImagesCache.containsKey(platformName)) {
      return;
    }

    // Load system image
    final imagePath = await _mediaService.getSystemImage(platformName);

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
    final logoPath = await _mediaService.getSystemLogo(platformName);

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
    final backgroundPath = await _mediaService.getSystemBackground(
      platformName,
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
      _requestFocusForCurrentViewMode();
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

  /// Handles common keyboard shortcuts (R, V) that work across all view modes
  /// Returns true if the key was handled, false otherwise
  bool _handleCommonShortcuts(LogicalKeyboardKey key) {
    if (key == KeyboardService.keyRefresh) {
      _loadPlatforms();
      return true;
    }
    if (key == KeyboardService.keyToggleView) {
      _toggleViewMode();
      return true;
    }
    return false;
  }

  /// Centralized keyboard event handler for all view modes
  /// This eliminates code duplication across grid and carousel views
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

    // 3. Handle common shortcuts (R, V)
    if (_handleCommonShortcuts(key)) {
      return KeyEventResult.handled;
    }

    // 4. Handle back/exit
    if (_keyboardService.isBackKey(key)) {
      _showExitDialog();
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
    HelpDialog.show(context, showSearchShortcut: false);
  }

  /// Handle alphabetical jump based on current view mode
  KeyEventResult _handleAlphabeticalJump(KeyEvent event) {
    final letter = _keyboardService.getAlphabeticalJumpLetter(event);
    if (letter == null) return KeyEventResult.ignored;

    final newIndex = _keyboardService.findIndexByLetter(
      letter: letter,
      items: _platforms,
      getDisplayName: (platform) => platform.displayName,
    );

    if (newIndex == null) return KeyEventResult.ignored;

    if (_viewMode == ViewMode.grid) {
      setState(() {
        _gridSelectedIndex = newIndex;
      });
      final columns = _calculateCrossAxisCount(context);
      _scrollToIndex(newIndex, columns);
    } else {
      // Carousel
      _hideNavigationHint();
      _carouselController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return KeyEventResult.handled;
  }

  /// Handle selection based on current view mode
  void _handleSelection() {
    final selectedPlatform = _viewMode == ViewMode.grid
        ? _platforms[_gridSelectedIndex]
        : _platforms[_carouselCurrentIndex];
    _navigateToRoms(selectedPlatform);
  }

  /// Handle directional navigation based on current view mode
  KeyEventResult _handleDirectionalNavigation(LogicalKeyboardKey key) {
    if (_viewMode == ViewMode.grid) {
      return _handleGridNavigation(key);
    } else {
      return _handleCarouselNavigation(key);
    }
  }

  /// Handle grid-specific navigation
  KeyEventResult _handleGridNavigation(LogicalKeyboardKey key) {
    final columns = _calculateCrossAxisCount(context);
    final newIndex = _keyboardService.handleGridNavigation(
      key: key,
      currentIndex: _gridSelectedIndex,
      itemCount: _platforms.length,
      columns: columns,
    );

    if (newIndex != null) {
      setState(() {
        _gridSelectedIndex = newIndex;
      });
      _scrollToIndex(newIndex, columns);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Handle carousel-specific navigation
  KeyEventResult _handleCarouselNavigation(LogicalKeyboardKey key) {
    final newIndex = _keyboardService.handleCarouselNavigation(
      key: key,
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
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Image.file(File('assets/images/icon.png'), width: 24, height: 24),
        actions: [
          const ThemeSelector(),
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.grid
                  ? Icons.view_carousel
                  : Icons.grid_view,
            ),
            onPressed: _toggleViewMode,
            tooltip: _viewMode == ViewMode.grid ? 'Carousel View' : 'Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlatforms,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
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

  void _navigateToRoms(Platform platform) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RomsScreen(platform: platform, romService: widget.romService),
      ),
    );
  }

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Application'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
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
          // Position indicator (bottom-right)
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_carouselCurrentIndex + 1} / ${_platforms.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                      ? Image.file(
                          File(imagePath),
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
    final isSvg = logoPath.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.asset(
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
