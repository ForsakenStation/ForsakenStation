import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Lucide-style icons ported from AnimateIcons with micro-animations on hover/focus.
enum AnimatedLucideIconType {
  gamepad,
  database,
  cpu,
  folder,
  folderCheck,
  cloudDownload,
  globe,
  shieldCheck,
  slidersHorizontal,
  languages,
  wandSparkles,
  info,
  wrench,
  bug,
  trash2,
  archive,
}

/// Renders a crisp 24x24 Lucide SVG icon with an AnimateIcons-inspired
/// micro-animation whenever [animate] becomes true (hover or focus).
class AnimatedLucideIcon extends StatefulWidget {
  const AnimatedLucideIcon({
    super.key,
    required this.type,
    required this.color,
    this.size = 20,
    this.animate = false,
  });

  final AnimatedLucideIconType type;
  final Color color;
  final double size;
  final bool animate;

  @override
  State<AnimatedLucideIcon> createState() => _AnimatedLucideIconState();
}

class _AnimatedLucideIconState extends State<AnimatedLucideIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    if (widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedLucideIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _svgForType(AnimatedLucideIconType type) {
    final inner = switch (type) {
      AnimatedLucideIconType.gamepad =>
        '<path d="M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z"/>'
            '<line x1="6" x2="10" y1="11" y2="11"/>'
            '<line x1="8" x2="8" y1="9" y2="13"/>'
            '<line x1="15" x2="15.01" y1="12" y2="12"/>'
            '<line x1="18" x2="18.01" y1="10" y2="10"/>',
      AnimatedLucideIconType.database =>
        '<ellipse cx="12" cy="5" rx="9" ry="3"/>'
            '<path d="M3 5V19A9 3 0 0 0 21 19V5"/>'
            '<path d="M3 12A9 3 0 0 0 21 12"/>',
      AnimatedLucideIconType.cpu =>
        '<path d="M7 2v2"/><path d="M12 2v2"/><path d="M17 2v2"/>'
            '<path d="M20 7h2"/><path d="M20 12h2"/><path d="M20 17h2"/>'
            '<path d="M17 20v2"/><path d="M12 20v2"/><path d="M7 20v2"/>'
            '<path d="M2 17h2"/><path d="M2 12h2"/><path d="M2 7h2"/>'
            '<rect x="4" y="4" width="16" height="16" rx="2"/>'
            '<rect x="8" y="8" width="8" height="8" rx="1"/>',
      AnimatedLucideIconType.folder =>
        '<path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"/>',
      AnimatedLucideIconType.folderCheck =>
        '<path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"/>'
            '<path d="m9 13 2 2 4-4"/>',
      AnimatedLucideIconType.cloudDownload =>
        '<path d="M12 13v8l-4-4"/>'
            '<path d="m12 21 4-4"/>'
            '<path d="M4.393 15.269A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.436 8.284"/>',
      AnimatedLucideIconType.globe =>
        '<circle cx="12" cy="12" r="10"/>'
            '<path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/>'
            '<path d="M2 12h20"/>',
      AnimatedLucideIconType.shieldCheck =>
        '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>'
            '<path d="m9 12 2 2 4-4"/>',
      AnimatedLucideIconType.slidersHorizontal =>
        '<path d="M10 5H3"/><path d="M21 5h-7"/>'
            '<path d="M12 19H3"/><path d="M21 19h-5"/>'
            '<path d="M21 12h-9"/><path d="M8 12H3"/>'
            '<path d="M14 3v4"/><path d="M16 17v4"/><path d="M8 10v4"/>',
      AnimatedLucideIconType.languages =>
        '<path d="m5 8 6 6"/><path d="m4 14 6-6 2-3"/>'
            '<path d="M2 5h12"/><path d="M7 2h1"/>'
            '<path d="m22 22-5-10-5 10"/><path d="M14 18h6"/>',
      AnimatedLucideIconType.wandSparkles =>
        '<path d="m21.64 3.64-1.28-1.28a1.21 1.21 0 0 0-1.72 0L2.36 18.64a1.21 1.21 0 0 0 0 1.72l1.28 1.28a1.2 1.2 0 0 0 1.72 0L21.64 5.36a1.2 1.2 0 0 0 0-1.72"/>'
            '<path d="m14 7 3 3"/>'
            '<path d="M5 6v4"/><path d="M7 8H3"/>'
            '<path d="M10 2v2"/><path d="M11 3H9"/>'
            '<path d="M19 14v4"/><path d="M21 16h-4"/>',
      AnimatedLucideIconType.info =>
        '<circle cx="12" cy="12" r="10"/>'
            '<path d="M12 16v-4"/><path d="M12 8h.01"/>',
      AnimatedLucideIconType.wrench =>
        '<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-8.259 7.057l-7.91 7.91a1 1 0 0 1-2.999-3l7.91-7.91a6 6 0 0 1 7.057-8.259c.438.12.54.662.219.984z"/>',
      AnimatedLucideIconType.bug =>
        '<path d="M12 20v-9"/>'
            '<path d="M14 7a4 4 0 0 1 4 4v3a6 6 0 0 1-12 0v-3a4 4 0 0 1 4-4z"/>'
            '<path d="M9 7.13V6a3 3 0 1 1 6 0v1.13"/>'
            '<path d="M14.12 3.88 16 2"/><path d="m8 2 1.88 1.88"/>'
            '<path d="M3 5a4 4 0 0 0 3.55 3.97"/><path d="M6 13H2"/>'
            '<path d="M3 21a4 4 0 0 1 3.81-4"/>'
            '<path d="M21 5a4 4 0 0 1-3.55 3.97"/><path d="M22 13h-4"/>'
            '<path d="M21 21a4 4 0 0 0-3.81-4"/>',
      AnimatedLucideIconType.trash2 =>
        '<path d="M10 11v6"/><path d="M14 11v6"/>'
            '<path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/>'
            '<path d="M3 6h18"/>'
            '<path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>',
      AnimatedLucideIconType.archive =>
        '<rect width="20" height="5" x="2" y="3" rx="1"/>'
            '<path d="M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8"/>'
            '<path d="M10 12h4"/>',
    };

    return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
        'viewBox="0 0 24 24" fill="none" stroke="currentColor" '
        'stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'
        '$inner</svg>';
  }

  Widget _applyMotion(Widget child) {
    final t = _controller.value;
    if (t == 0 || t == 1) return child;

    switch (widget.type) {
      case AnimatedLucideIconType.gamepad:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.07), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -0.07, end: 0.07), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.07, end: -0.05), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.03), weight: 15),
          TweenSequenceItem(tween: Tween(begin: 0.03, end: 0.0), weight: 15),
        ]).transform(t);
        return Transform.rotate(angle: angle, child: child);

      case AnimatedLucideIconType.shieldCheck:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.11), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.11, end: 0.07), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.07, end: -0.02), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.02, end: 0.0), weight: 20),
        ]).transform(t);
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.bottomCenter,
          child: child,
        );

      case AnimatedLucideIconType.wandSparkles:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.14), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.14, end: 0.09), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.09, end: -0.03), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.03, end: 0.0), weight: 20),
        ]).transform(t);
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.bottomLeft,
          child: child,
        );

      case AnimatedLucideIconType.folder:
      case AnimatedLucideIconType.folderCheck:
      case AnimatedLucideIconType.languages:
        final dy = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -2.0), weight: 35),
          TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.6), weight: 35),
          TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.0), weight: 30),
        ]).transform(t);
        return Transform.translate(offset: Offset(0, dy), child: child);

      case AnimatedLucideIconType.cloudDownload:
        final dy = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 2.0), weight: 35),
          TweenSequenceItem(tween: Tween(begin: 2.0, end: -0.6), weight: 35),
          TweenSequenceItem(tween: Tween(begin: -0.6, end: 0.0), weight: 30),
        ]).transform(t);
        return Transform.translate(offset: Offset(0, dy), child: child);

      case AnimatedLucideIconType.slidersHorizontal:
        final dx = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.8), weight: 35),
          TweenSequenceItem(tween: Tween(begin: 1.8, end: -1.0), weight: 35),
          TweenSequenceItem(tween: Tween(begin: -1.0, end: 0.0), weight: 30),
        ]).transform(t);
        return Transform.translate(offset: Offset(dx, 0), child: child);

      case AnimatedLucideIconType.globe:
        final sx = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.78), weight: 45),
          TweenSequenceItem(tween: Tween(begin: 0.78, end: 1.0), weight: 55),
        ]).transform(t);
        return Transform.scale(scaleX: sx, scaleY: 1.0, child: child);

      case AnimatedLucideIconType.database:
      case AnimatedLucideIconType.cpu:
      case AnimatedLucideIconType.info:
        final scale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.12), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 30),
        ]).transform(t);
        return Transform.scale(scale: scale, child: child);

      case AnimatedLucideIconType.wrench:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.21), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.21, end: 0.17), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.17, end: -0.1), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 20),
        ]).transform(t);
        return Transform.rotate(
          angle: angle,
          alignment: const Alignment(0.25, -0.25),
          child: child,
        );

      case AnimatedLucideIconType.bug:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.1), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.07), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.07, end: 0.0), weight: 20),
        ]).transform(t);
        final dy = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -1.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -1.0, end: 0.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -1.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -1.0, end: 0.0), weight: 25),
        ]).transform(t);
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(angle: angle, child: child),
        );

      case AnimatedLucideIconType.trash2:
        final angle = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.14), weight: 30),
          TweenSequenceItem(tween: Tween(begin: -0.14, end: 0.1), weight: 35),
          TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 35),
        ]).transform(t);
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.topLeft,
          child: child,
        );

      case AnimatedLucideIconType.archive:
        final sy = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 60),
        ]).transform(t);
        return Transform.scale(
          scaleX: 1.0,
          scaleY: sy,
          alignment: Alignment.bottomCenter,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.string(
      _svgForType(widget.type),
      width: widget.size,
      height: widget.size,
      colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => _applyMotion(child!),
      child: svg,
    );
  }
}
