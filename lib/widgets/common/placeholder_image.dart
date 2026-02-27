import 'package:flutter/material.dart';

/// A placeholder image widget displayed when ROM media is not available
class PlaceholderImage extends StatelessWidget {
  final double? size;

  const PlaceholderImage({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      color: isDark ? Colors.grey[850] : Colors.grey[300],
      child: Icon(
        Icons.videogame_asset,
        size: size != null ? size! * 0.5 : 48,
        color: isDark ? Colors.grey[700] : Colors.grey[600],
      ),
    );
  }
}
