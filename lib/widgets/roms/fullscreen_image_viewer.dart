import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/media.dart';
import '../../services/gamepad_service.dart';
import 'fullscreen_viewer/fullscreen_viewer_controller.dart';
import 'fullscreen_viewer/fullscreen_image_content.dart';
import 'fullscreen_viewer/fullscreen_video_content.dart';
import 'fullscreen_viewer/fullscreen_manual_content.dart';
import 'fullscreen_viewer/fullscreen_viewer_controls.dart';

/// Full screen media viewer for images and videos
class FullScreenImageViewer extends StatefulWidget {
  final String imagePath;
  final List<Media>? allMedia;
  final int? initialIndex;
  final String? romName;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    this.allMedia,
    this.initialIndex,
    this.romName,
  });

  @override
  State<FullScreenImageViewer> createState() => FullScreenImageViewerState();
}

class FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late FullScreenViewerController _controller;
  late PageController _pageController;
  Timer? _gamepadPollTimer;
  final FocusNode _keyboardFocusNode = FocusNode();

  List<Media> getMediaList() => _controller.items;
  int getCurrentIndex() => _controller.currentIndex;

  @override
  void initState() {
    super.initState();

    final List<Media> mediaList = widget.allMedia ?? [];
    int initialIndex = 0;

    if (mediaList.isNotEmpty) {
      if (widget.initialIndex != null) {
        initialIndex = widget.initialIndex!;
      } else {
        initialIndex = mediaList.indexWhere((m) => m.path == widget.imagePath);
        if (initialIndex == -1) initialIndex = 0;
      }
    }

    _controller = FullScreenViewerController(
      mediaList: mediaList,
      initialIndex: initialIndex,
    );
    _controller.addListener(_onControllerUpdate);

    _pageController = PageController(initialPage: initialIndex);

    _controller.showControlsTemporarily();
    _startGamepadPolling();

    // Initialize first item if it's a video
    if (mediaList.isNotEmpty && mediaList[initialIndex].isVideo) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _controller.initializeVideoPlayer(mediaList[initialIndex].path);
        }
      });
    }
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;

      final gamepad = GamepadService.instance;
      final direction = gamepad.getNavigationDirection();

      if (direction == 'left') {
        _previous();
      } else if (direction == 'right') {
        _next();
      }

      if (gamepad.isBackPressed()) {
        Navigator.of(context).pop();
      }

      final current = _controller.items[_controller.currentIndex];

      // PDF Specific handling (L1/R1, L2/R2, X)
      if (current.type == MediaType.manual &&
          widget.imagePath.toLowerCase().endsWith('.pdf')) {
        // These are handled by the PDF viewer logic if we had a way to communicate.
        // Since we are in the parent, we can try to find the state or just
        // let the PageView handle left/right.
      }

      if (gamepad.isSelectPressed()) {
        final current = _controller.items[_controller.currentIndex];
        if (current.isVideo) {
          _controller.toggleVideoPlayPause(current.path);
        } else {
          _controller.toggleControls();
        }
      }
      gamepad.updatePreviousButtonStates();
    });
  }

  @override
  void dispose() {
    _gamepadPollTimer?.cancel();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _pageController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _previous() {
    if (_controller.currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _next() {
    if (_controller.currentIndex < _controller.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    if (_controller.currentIndex != index) {
      final prev = _controller.items[_controller.currentIndex];
      if (prev.isVideo) _controller.pauseVideo(prev.path);
    }

    _controller.currentIndex = index;
    _controller.showControlsTemporarily();

    final current = _controller.items[index];
    if (current.isVideo && !_controller.isVideoReady(current.path)) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && _controller.currentIndex == index) {
          _controller.initializeVideoPlayer(current.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is! KeyDownEvent) return;
          final key = event.logicalKey;

          if (key == LogicalKeyboardKey.escape) {
            Navigator.of(context).pop();
          } else if (key == LogicalKeyboardKey.arrowLeft) {
            _previous();
          } else if (key == LogicalKeyboardKey.arrowRight) {
            _next();
          } else if (key == LogicalKeyboardKey.space) {
            final current = _controller.items[_controller.currentIndex];
            if (current.isVideo) {
              _controller.toggleVideoPlayPause(current.path);
            } else {
              _controller.toggleControls();
            }
          }
        },
        child: GestureDetector(
          onTap: _controller.toggleControls,
          child: Stack(
            children: [
              _buildContent(),
              FullScreenViewerControls(
                controller: _controller,
                title: widget.romName,
                onBack: () => Navigator.of(context).pop(),
                onPrevious: _previous,
                onNext: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_controller.items.isEmpty) {
      return FullScreenImageContent(path: widget.imagePath);
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: _controller.items.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final media = _controller.items[index];
        final isActive = index == _controller.currentIndex;

        if (media.isVideo) {
          return FullScreenVideoContent(
            path: media.path,
            controller: _controller,
          );
        } else if (media.type == MediaType.manual) {
          return FullScreenManualContent(
            path: media.path,
            controller: _controller,
            isActive: isActive,
          );
        } else {
          return FullScreenImageContent(path: media.path);
        }
      },
    );
  }
}
