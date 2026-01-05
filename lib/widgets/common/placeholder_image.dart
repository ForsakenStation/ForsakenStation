import 'package:flutter/material.dart';

/// A placeholder image widget displayed when ROM media is not available
class PlaceholderImage extends StatelessWidget {
  final double? size;

  const PlaceholderImage({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(
        Icons.videogame_asset,
        size: size != null ? size! * 0.5 : 48,
        color: Colors.grey[600],
      ),
    );
  }
}
