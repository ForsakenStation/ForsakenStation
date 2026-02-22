import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import '../../models/media.dart';
import '../../services/debug_service.dart';
import '../../services/gamepad_service.dart';

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
  Timer? _gamepadPollTimer;

  // Video player state
  final Map<String, mk.Player> _videoPlayers = {};
  final Map<String, VideoController> _videoControllers = {};
  final Map<String, bool> _videoLoadingStates = {}; // Track loading state

  @override
  void initState() {
    super.initState();

    // Include ALL media (images AND videos)
    _imageMedia = widget.allMedia ?? [];

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

    // Start gamepad polling
    _startGamepadPolling();

    // If initial page is a video, load it after a short delay
    if (_imageMedia.isNotEmpty && _imageMedia[_currentIndex].isVideo) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _initializePlayer(_imageMedia[_currentIndex]);
        }
      });
    }
  }

  void _startAutoHideTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;

      // Navigation with D-pad or left stick
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        if (direction == 'left') {
          _previousImage();
        } else if (direction == 'right') {
          _nextImage();
        }
      }

      // B button to close
      if (gamepad.isBackPressed()) {
        Navigator.of(context).pop();
        gamepad.updatePreviousButtonStates();
      }

      // A button - play video if current item is video, otherwise toggle controls
      if (gamepad.isSelectPressed()) {
        if (_imageMedia.isNotEmpty && _imageMedia[_currentIndex].isVideo) {
          _toggleVideoPlayPause();
        } else {
          _toggleControls();
        }
      }
      gamepad.updatePreviousButtonStates();
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _disposeAllPlayers();
    _pageController.dispose();
    super.dispose();
  }

  void _disposeAllPlayers() {
    for (final player in _videoPlayers.values) {
      player.dispose();
    }
    _videoPlayers.clear();
    _videoControllers.clear();
    _videoLoadingStates.clear();
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
              // Play video if current item is video, otherwise toggle controls
              if (_imageMedia.isNotEmpty &&
                  _imageMedia[_currentIndex].isVideo) {
                _toggleVideoPlayPause();
              } else {
                _toggleControls();
              }
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
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final media = _imageMedia[index];

                    if (media.isVideo) {
                      // Inline video player
                      return _buildVideoPlayer(media);
                    } else {
                      // Image with zoom
                      return Center(
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Image.file(
                            File(media.path),
                            key: ValueKey(media.path),
                          ),
                        ),
                      );
                    }
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
                            tooltip: 'Close',
                          ),
                          const SizedBox(width: 8),
                          // Close hint with keyboard + gamepad
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Keyboard hint
                                if (!GamepadService.instance.isGamepadConnected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'ESC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                // Gamepad hint (if connected)
                                if (GamepadService
                                    .instance
                                    .isGamepadConnected) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      'Ⓑ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                const Text(
                                  'Cerrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildVideoPlayer(Media media) {
    // Initialize player if not already done
    if (!_videoPlayers.containsKey(media.path) && !_isVideoLoading(media)) {
      _initializePlayer(media);
    }

    // Show loading state
    if (!_isVideoReady(media)) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Cargando video...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _videoControllers[media.path]!;
    final player = _videoPlayers[media.path]!;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video widget
        Center(
          child: Video(controller: controller, controls: NoVideoControls),
        ),

        // Overlay controls when _showControls is true
        if (_showControls)
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
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Control hints
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Keyboard hint
                        if (!GamepadService.instance.isGamepadConnected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'SPACE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        // Gamepad hint (if connected)
                        if (GamepadService.instance.isGamepadConnected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              'Ⓐ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        const Text(
                          'Play/Pause',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Player controls
                  StreamBuilder<bool>(
                    stream: player.stream.playing,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _toggleVideoPlayPause,
                          ),
                          Expanded(
                            child: StreamBuilder<Duration>(
                              stream: player.stream.position,
                              builder: (context, positionSnapshot) {
                                return StreamBuilder<Duration>(
                                  stream: player.stream.duration,
                                  builder: (context, durationSnapshot) {
                                    final position =
                                        positionSnapshot.data ?? Duration.zero;
                                    final duration =
                                        durationSnapshot.data ?? Duration.zero;

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Slider(
                                          value: duration.inMilliseconds > 0
                                              ? position.inMilliseconds
                                                    .toDouble()
                                              : 0.0,
                                          min: 0.0,
                                          max: duration.inMilliseconds
                                              .toDouble(),
                                          onChanged: (value) {
                                            player.seek(
                                              Duration(
                                                milliseconds: value.toInt(),
                                              ),
                                            );
                                          },
                                          activeColor: Colors.red,
                                          inactiveColor: Colors.white24,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDuration(position),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                _formatDuration(duration),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        // Center play button when paused
        if (_showControls)
          StreamBuilder<bool>(
            stream: player.stream.playing,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              if (isPlaying) return const SizedBox.shrink();

              return Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleVideoPlayPause() {
    DebugService.instance.debug(
      '_toggleVideoPlayPause() called',
      tag: 'MediaViewer',
    );

    if (_imageMedia.isEmpty) {
      DebugService.instance.debug('_imageMedia is empty', tag: 'MediaViewer');
      return;
    }

    final media = _imageMedia[_currentIndex];
    DebugService.instance.debug(
      'Current media: ${media.path}, isVideo: ${media.isVideo}',
      tag: 'MediaViewer',
    );

    if (!media.isVideo) {
      DebugService.instance.debug('Not a video', tag: 'MediaViewer');
      return;
    }

    // Only allow play/pause if video is ready
    final isReady = _isVideoReady(media);
    final isLoading = _isVideoLoading(media);
    final hasPlayer = _videoPlayers.containsKey(media.path);

    DebugService.instance.debug(
      'Video ready: $isReady, loading: $isLoading, has player: $hasPlayer',
      tag: 'MediaViewer',
    );

    if (!isReady) {
      DebugService.instance.debug('Video not ready yet', tag: 'MediaViewer');
      return;
    }

    final player = _videoPlayers[media.path];
    if (player != null) {
      final currentlyPlaying = player.state.playing;
      DebugService.instance.debug(
        'Player found! Currently playing: $currentlyPlaying',
        tag: 'MediaViewer',
      );
      DebugService.instance.debug(
        'Calling playOrPause()...',
        tag: 'MediaViewer',
      );

      player.playOrPause();

      DebugService.instance.debug(
        'playOrPause() called successfully',
        tag: 'MediaViewer',
      );

      // Force UI update and show controls temporarily
      setState(() {
        _showControls = true;
      });
      _startAutoHideTimer();

      DebugService.instance.debug('UI updated', tag: 'MediaViewer');
    } else {
      DebugService.instance.debug('Player is null!', tag: 'MediaViewer');
    }
  }

  Future<void> _initializePlayer(Media media) async {
    if (_videoPlayers.containsKey(media.path)) return;

    // Mark as loading
    setState(() {
      _videoLoadingStates[media.path] = true;
    });

    try {
      final player = mk.Player();
      final controller = VideoController(player);

      _videoPlayers[media.path] = player;
      _videoControllers[media.path] = controller;

      // Load video asynchronously
      await player.open(mk.Media(media.path));
      await player.setPlaylistMode(mk.PlaylistMode.loop);

      // Mark as loaded
      if (mounted) {
        setState(() {
          _videoLoadingStates[media.path] = false;
        });
      }
    } catch (e) {
      DebugService.instance.error(
        'Error loading video: $e',
        tag: 'MediaViewer',
      );
      if (mounted) {
        setState(() {
          _videoLoadingStates[media.path] = false;
        });
      }
    }
  }

  bool _isVideoLoading(Media media) {
    return _videoLoadingStates[media.path] ?? false;
  }

  bool _isVideoReady(Media media) {
    return _videoPlayers.containsKey(media.path) && !_isVideoLoading(media);
  }

  void _onPageChanged(int index) {
    // Pause any playing videos when navigating away
    if (_currentIndex != index) {
      final previousMedia = _imageMedia[_currentIndex];
      if (previousMedia.isVideo) {
        final player = _videoPlayers[previousMedia.path];
        if (player != null && player.state.playing) {
          player.pause();
        }
      }
    }

    setState(() {
      _currentIndex = index;
      // Show controls when navigating to new media
      _showControls = true;
    });
    _startAutoHideTimer();

    // Delay video initialization until page transition animation completes
    final currentMedia = _imageMedia[index];
    if (currentMedia.isVideo && !_videoPlayers.containsKey(currentMedia.path)) {
      // Wait for PageView animation to finish (300ms) + small buffer
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && _currentIndex == index) {
          _initializePlayer(currentMedia);
        }
      });
    }
  }

  Widget _buildHintButton(
    IconData icon,
    String label,
    bool enabled,
    VoidCallback? onPressed,
  ) {
    final isGamepadConnected = GamepadService.instance.isGamepadConnected;

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
          const SizedBox(width: 12),
          // Control hints
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Keyboard arrow
                if (!isGamepadConnected)
                  Icon(
                    icon == Icons.arrow_back
                        ? Icons.keyboard_arrow_left
                        : Icons.keyboard_arrow_right,
                    color: enabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    size: 16,
                  ),
                // Gamepad D-pad (if connected)
                if (isGamepadConnected) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: enabled
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      icon == Icons.arrow_back ? '◀' : '▶',
                      style: TextStyle(
                        color: enabled
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
