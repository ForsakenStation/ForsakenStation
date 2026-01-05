import 'package:flutter/material.dart';

/// Widget that displays a 5-star rating based on a percentage (0.0 - 1.0)
class StarRating extends StatelessWidget {
  final double? rating; // 0.0 to 1.0
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showRatingText;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.showRatingText = false,
  });

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return const SizedBox.shrink();
    }

    // Convert 0.0-1.0 rating to 0-5 stars
    final starRating = (rating! * 5).clamp(0.0, 5.0);

    final activeStarColor = activeColor ?? Colors.amber;
    final inactiveStarColor = inactiveColor ?? Colors.grey.shade400;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          // Calculate how filled this star should be
          final starValue = starRating - index;

          Widget star;
          if (starValue >= 1.0) {
            // Full star
            star = Icon(Icons.star, size: size, color: activeStarColor);
          } else if (starValue > 0.0) {
            // Partial star
            star = Stack(
              children: [
                Icon(Icons.star, size: size, color: inactiveStarColor),
                ClipRect(
                  clipper: _StarClipper(starValue),
                  child: Icon(Icons.star, size: size, color: activeStarColor),
                ),
              ],
            );
          } else {
            // Empty star
            star = Icon(
              Icons.star_border,
              size: size,
              color: inactiveStarColor,
            );
          }

          return star;
        }),
        if (showRatingText) ...[
          const SizedBox(width: 8),
          Text(
            '${(rating! * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom clipper to show partial stars
class _StarClipper extends CustomClipper<Rect> {
  final double fillPercentage;

  _StarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fillPercentage, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}
