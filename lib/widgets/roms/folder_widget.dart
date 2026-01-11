import 'package:flutter/material.dart';

/// A widget that displays a folder icon/image
///
/// Shows a custom folder image from assets (_default.png),
/// otherwise falls back to a folder icon.
///
/// The image path is constant: 'assets/theme/images/systems/_default.png'
///
/// This widget is used across all ROM view modes (grid, list, carousel)
/// to maintain consistency in folder representation.
class FolderWidget extends StatelessWidget {
  /// Width of the container
  final double width;

  /// Height of the container
  final double height;

  /// Size of the fallback icon (when image not available)
  final double iconSize;

  /// Border radius for the container
  final double borderRadius;

  /// Constant path to the default folder image
  static const String _folderImagePath =
      'assets/theme/images/systems/_default.webp';

  const FolderWidget({
    super.key,
    this.width = 64,
    this.height = 64,
    this.iconSize = 64,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          _folderImagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if image not found
            return Icon(Icons.folder, size: iconSize, color: Colors.amber);
          },
        ),
      ),
    );
  }
}
