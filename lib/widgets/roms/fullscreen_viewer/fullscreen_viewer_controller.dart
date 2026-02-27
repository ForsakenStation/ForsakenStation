import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import '../../../models/media.dart';
import '../../../services/debug_service.dart';

class FullScreenViewerController extends ChangeNotifier {
  final List<Media> mediaList;
  int _currentIndex;
  bool _showControls = true;
  Timer? _autoHideTimer;

  // Video player state
  final Map<String, mk.Player> _videoPlayers = {};
  final Map<String, VideoController> _videoControllers = {};
  final Map<String, bool> _videoLoadingStates = {};

  FullScreenViewerController({
    required this.mediaList,
    required int initialIndex,
  }) : _currentIndex = initialIndex;

  int get currentIndex => _currentIndex;
  bool get showControls => _showControls;
  List<Media> get items => mediaList;

  set currentIndex(int value) {
    if (_currentIndex != value) {
      _currentIndex = value;
      notifyListeners();
    }
  }

  void toggleControls() {
    _showControls = !_showControls;
    if (_showControls) {
      _startAutoHideTimer();
    } else {
      _autoHideTimer?.cancel();
    }
    notifyListeners();
  }

  void showControlsTemporarily() {
    _showControls = true;
    _startAutoHideTimer();
    notifyListeners();
  }

  void _startAutoHideTimer() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(const Duration(seconds: 3), () {
      _showControls = false;
      notifyListeners();
    });
  }

  // --- Video Logic ---

  bool isVideoLoading(String path) => _videoLoadingStates[path] ?? false;
  bool isVideoReady(String path) =>
      _videoPlayers.containsKey(path) && !isVideoLoading(path);

  mk.Player? getPlayer(String path) => _videoPlayers[path];
  VideoController? getVideoController(String path) => _videoControllers[path];

  Future<void> initializeVideoPlayer(String path) async {
    if (_videoPlayers.containsKey(path)) return;

    _videoLoadingStates[path] = true;
    notifyListeners();

    try {
      final player = mk.Player();
      final controller = VideoController(player);

      _videoPlayers[path] = player;
      _videoControllers[path] = controller;

      await player.open(mk.Media(path));
      await player.setPlaylistMode(mk.PlaylistMode.loop);

      _videoLoadingStates[path] = false;
      notifyListeners();
    } catch (e) {
      DebugService.instance.error(
        'Error loading video: $e',
        tag: 'FullScreenViewer',
      );
      _videoLoadingStates[path] = false;
      notifyListeners();
    }
  }

  void toggleVideoPlayPause(String path) {
    final player = _videoPlayers[path];
    if (player != null && isVideoReady(path)) {
      player.playOrPause();
      showControlsTemporarily();
    }
  }

  void pauseVideo(String path) {
    final player = _videoPlayers[path];
    if (player != null && player.state.playing) {
      player.pause();
    }
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    for (final player in _videoPlayers.values) {
      player.dispose();
    }
    _videoPlayers.clear();
    _videoControllers.clear();
    super.dispose();
  }
}
