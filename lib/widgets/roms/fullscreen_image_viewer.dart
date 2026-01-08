import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/media.dart';

/// Full screen image viewer with zoom, pan, and navigation capabilities
class FullScreenImageViewer extends StatefulWidget {
  final String imagePath;
  final List<Media>? allMedia;
  final int? initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    this.allMedia,
    this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  late List<Media> _imageMedia;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();

    // Filter only image media (no videos)
    _imageMedia =
        widget.allMedia?.where((m) => m.type != MediaType.video).toList() ?? [];

    // Find initial index
    if (_imageMedia.isNotEmpty && widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
    } else if (_imageMedia.isNotEmpty) {
      // Find index by path
      _currentIndex = _imageMedia.indexWhere((m) => m.path == widget.imagePath);
      if (_currentIndex == -1) _currentIndex = 0;
    } else {
      _currentIndex = 0;
    }

    _pageController = PageController(initialPage: _currentIndex);

    // Auto-hide controls after 3 seconds
    _startAutoHideTimer();
  }

  void _startAutoHideTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < _imageMedia.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startAutoHideTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = _imageMedia.length > 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(context).pop();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _previousImage();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _nextImage();
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              _toggleControls();
            }
          }
        },
        child: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Image PageView
              if (_imageMedia.isNotEmpty)
                PageView.builder(
                  controller: _pageController,
                  itemCount: _imageMedia.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(
                          File(_imageMedia[index].path),
                          key: ValueKey(_imageMedia[index].path),
                        ),
                      ),
                    );
                  },
                )
              else
                Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(File(widget.imagePath)),
                  ),
                ),

              // Controls overlay
              if (_showControls) ...[
                // Top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Close (ESC)',
                          ),
                          const SizedBox(width: 16),
                          if (_imageMedia.isNotEmpty)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _imageMedia[_currentIndex].typeName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (hasMultipleImages)
                                    Text(
                                      '${_currentIndex + 1} / ${_imageMedia.length}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom navigation hint
                if (hasMultipleImages)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHintButton(
                            Icons.arrow_back,
                            'Previous',
                            _currentIndex > 0,
                            _previousImage,
                          ),
                          const SizedBox(width: 32),
                          _buildHintButton(
                            Icons.arrow_forward,
                            'Next',
                            _currentIndex < _imageMedia.length - 1,
                            _nextImage,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Navigation arrows
                if (hasMultipleImages && _currentIndex > 0)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 48),
                        color: Colors.white,
                        onPressed: _previousImage,
                      ),
                    ),
                  ),
                if (hasMultipleImages && _currentIndex < _imageMedia.length - 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 48),
                        color: Colors.white,
                        onPressed: _nextImage,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton(
    IconData icon,
    String label,
    bool enabled,
    VoidCallback? onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.3),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: enabled
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
