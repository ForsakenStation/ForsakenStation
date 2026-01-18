import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/services/debug_service.dart';
import 'fullscreen_image_viewer.dart';

/// Carousel widget for displaying media (images and videos) with navigation
class MediaCarousel extends StatefulWidget {
  final RomMedia media;
  final double height;
  final VoidCallback? onBeforeNavigation;
  final VoidCallback? onAfterNavigation;

  const MediaCarousel({
    super.key,
    required this.media,
    required this.height,
    this.onBeforeNavigation,
    this.onAfterNavigation,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  List<Media> _mediaItems = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadMediaItems();
  }

  @override
  void didUpdateWidget(MediaCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media != widget.media) {
      setState(() {
        _currentPage = 0;
        _loadMediaItems();
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  void _loadMediaItems() {
    final debug = DebugService.instance;
    _mediaItems = widget.media.allMedia;
    debug.debug(
      'MediaCarousel: Loaded ${_mediaItems.length} media items',
      tag: 'MediaCarousel',
    );
    for (var item in _mediaItems) {
      debug.debug('  - ${item.typeName}: ${item.path}', tag: 'MediaCarousel');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mediaItems.isEmpty) {
      return Container(height: widget.height);
    }

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: widget.height,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _mediaItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildMediaItem(_mediaItems[index]);
                },
              ),
            ),
            // Navigation buttons
            if (_mediaItems.length > 1) ...[
              // Left arrow
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                ),
              ),
              // Right arrow
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, size: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _currentPage < _mediaItems.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (_mediaItems.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              // Page indicators
              ...List.generate(
                _mediaItems.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              // Next button
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: _currentPage < _mediaItems.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaItem(Media media) {
    if (media.type == MediaType.video) {
      return _buildVideoPreview(media);
    } else {
      return _buildImagePreview(media);
    }
  }

  Widget _buildImagePreview(Media media) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(media.path),
              key: ValueKey(media.path),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.all(8),
              ),
              onPressed: () => _showFullScreenImage(media),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                media.typeName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview(Media media) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
      ), // Space for nav buttons
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.movie, size: 64, color: Colors.white54),
            ),
          ),
          Center(
            child: IconButton(
              icon: const Icon(Icons.play_circle_filled, size: 80),
              color: Colors.white,
              onPressed: () => _showFullScreenImage(media),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Video',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(Media media) async {
    final index = _mediaItems.indexOf(media);
    widget.onBeforeNavigation?.call();
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenImageViewer(
          imagePath: media.path,
          allMedia: _mediaItems,
          initialIndex: index >= 0 ? index : 0,
        ),
      ),
    );

    if (mounted) {
      widget.onAfterNavigation?.call();
    }
  }
}
