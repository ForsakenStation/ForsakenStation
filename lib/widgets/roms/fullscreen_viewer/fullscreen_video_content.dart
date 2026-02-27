import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'fullscreen_viewer_controller.dart';
import '../../../services/gamepad_service.dart';

class FullScreenVideoContent extends StatelessWidget {
  final String path;
  final FullScreenViewerController controller;

  const FullScreenVideoContent({
    super.key,
    required this.path,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.isVideoReady(path)) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final videoController = controller.getVideoController(path)!;
    final player = controller.getPlayer(path)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Video(controller: videoController, controls: NoVideoControls),
        ),
        if (controller.showControls) _buildVideoControls(context, player),
      ],
    );
  }

  Widget _buildVideoControls(BuildContext context, dynamic player) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlHints(),
            const SizedBox(height: 12),
            _buildProgressBar(player),
          ],
        ),
      ),
    );
  }

  Widget _buildControlHints() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!GamepadService.instance.isGamepadConnected)
            _buildKeyHint('SPACE'),
          if (GamepadService.instance.isGamepadConnected)
            _buildGamepadHint('Ⓐ'),
          const SizedBox(width: 8),
          const Text(
            'Play/Pause',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyHint(String key) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        key,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGamepadHint(String button) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Text(
        button,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar(dynamic player) {
    return StreamBuilder<bool>(
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
              onPressed: () => controller.toggleVideoPlayPause(path),
            ),
            Expanded(
              child: StreamBuilder<Duration>(
                stream: player.stream.position,
                builder: (context, positionSnapshot) {
                  return StreamBuilder<Duration>(
                    stream: player.stream.duration,
                    builder: (context, durationSnapshot) {
                      final position = positionSnapshot.data ?? Duration.zero;
                      final duration = durationSnapshot.data ?? Duration.zero;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: duration.inMilliseconds > 0
                                ? position.inMilliseconds.toDouble()
                                : 0.0,
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              player.seek(
                                Duration(milliseconds: value.toInt()),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
