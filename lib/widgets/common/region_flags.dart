import 'package:flutter/material.dart';
import '../../models/region_info.dart';

class RegionFlags extends StatelessWidget {
  final RegionInfo? regionInfo;
  final double size;
  final double spacing;

  const RegionFlags({
    super.key,
    required this.regionInfo,
    this.size = 20,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (regionInfo == null || regionInfo!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: regionInfo!.regions.map((region) {
        final flag = RegionInfo.getFlag(region);
        final regionName = RegionInfo.getRegionName(region);

        return Tooltip(
          message: regionName,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(4),
            ),
            child: _buildFlagWidget(flag, region),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFlagWidget(String flag, String region) {
    // Check if it's an emoji (unicode > 0x1F000)
    final isEmoji = flag.runes.any((rune) => rune > 0x1F000);

    if (isEmoji) {
      // Display emoji flag
      return Text(
        flag,
        style: TextStyle(
          fontSize: size,
          height: 1.2,
          fontFamily: 'Noto Color Emoji',
          fontFamilyFallback: const [
            'Apple Color Emoji',
            'Segoe UI Emoji',
            'Noto Color Emoji',
            'Twemoji Mozilla',
          ],
        ),
      );
    } else {
      // Fallback: display region text in a colored box
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: _getRegionColor(region),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          region.length <= 3 ? region.toUpperCase() : region,
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      );
    }
  }

  /// Get a color for a region (fallback when emoji fails)
  Color _getRegionColor(String region) {
    final regionLower = region.toLowerCase();

    // Assign colors based on region
    const regionColors = {
      'usa': Colors.blue,
      'united states': Colors.blue,
      'europe': Colors.green,
      'japan': Colors.red,
      'world': Colors.purple,
      'asia': Colors.orange,
      'australia': Colors.teal,
      'brazil': Colors.yellow,
      'canada': Colors.red,
      'china': Colors.red,
      'france': Colors.blue,
      'germany': Colors.amber,
      'italy': Colors.green,
      'korea': Colors.blue,
      'netherlands': Colors.orange,
      'spain': Colors.red,
      'esp': Colors.red,
      'sweden': Colors.blue,
      'uk': Colors.blue,
      'united kingdom': Colors.blue,
      'russia': Colors.blue,
    };

    return regionColors[regionLower] ?? Colors.grey;
  }
}
