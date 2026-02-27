import 'package:flutter/material.dart';
import 'fullscreen_viewer_controller.dart';
import '../../../services/gamepad_service.dart';

class FullScreenViewerControls extends StatelessWidget {
  final FullScreenViewerController controller;
  final String? title;
  final VoidCallback onBack;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const FullScreenViewerControls({
    super.key,
    required this.controller,
    this.title,
    required this.onBack,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.showControls) return const SizedBox.shrink();

    final hasMultiple = controller.items.length > 1;

    return Stack(
      children: [
        _buildTopBar(context),
        if (hasMultiple) ...[_buildNavigationArrows(), _buildBottomHints()],
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onBack,
                tooltip: 'Close',
              ),
              const SizedBox(width: 8),
              _buildCloseHint(),
              const SizedBox(width: 16),
              if (controller.items.isNotEmpty) _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseHint() {
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
          if (!GamepadService.instance.isGamepadConnected) _buildKeyHint('ESC'),
          if (GamepadService.instance.isGamepadConnected) ...[
            const SizedBox(width: 8),
            _buildGamepadHint('Ⓑ'),
          ],
          const SizedBox(width: 8),
          const Text(
            'Close',
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
        color: Colors.red,
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

  Widget _buildTitleSection() {
    final current = controller.items[controller.currentIndex];
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? current.typeName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (controller.items.length > 1)
            Text(
              '${controller.currentIndex + 1} / ${controller.items.length}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationArrows() {
    return Stack(
      children: [
        if (controller.currentIndex > 0)
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 48),
                color: Colors.white,
                onPressed: onPrevious,
              ),
            ),
          ),
        if (controller.currentIndex < controller.items.length - 1)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 48),
                color: Colors.white,
                onPressed: onNext,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomHints() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHintButton(
              Icons.arrow_back,
              'Previous',
              controller.currentIndex > 0,
              onPrevious,
            ),
            const SizedBox(width: 32),
            _buildHintButton(
              Icons.arrow_forward,
              'Next',
              controller.currentIndex < controller.items.length - 1,
              onNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintButton(
    IconData icon,
    String label,
    bool enabled,
    VoidCallback onPressed,
  ) {
    final isGamepad = GamepadService.instance.isGamepadConnected;

    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            _buildSmallHint(icon, isGamepad),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallHint(IconData icon, bool isGamepad) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isGamepad
          ? Text(
              icon == Icons.arrow_back ? '◀' : '▶',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            )
          : Icon(
              icon == Icons.arrow_back
                  ? Icons.keyboard_arrow_left
                  : Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 16,
            ),
    );
  }
}
