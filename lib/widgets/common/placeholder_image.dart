import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A sleek dark-glass SVG placeholder displayed when ROM media is not available.
class PlaceholderImage extends StatelessWidget {
  final double? size;
  final double borderRadius;

  const PlaceholderImage({
    super.key,
    this.size,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final targetSize = size ?? 140.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2331), Color(0xFF0E1118)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: SvgPicture.asset(
          'assets/images/rom_placeholder.svg',
          width: targetSize,
          height: targetSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
