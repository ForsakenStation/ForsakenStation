import 'package:flutter/material.dart';
import '../../models/rom_tags.dart';

/// Widget that displays ROM tags as colored badges
///
/// Shows tags extracted from ROM names like [!], [h], (Rev 1), etc.
/// with icons and colors based on tag type.
class RomTagBadges extends StatelessWidget {
  final RomTags? romTags;
  final double fontSize;
  final double spacing;

  const RomTagBadges({
    super.key,
    required this.romTags,
    this.fontSize = 11,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (romTags == null || romTags!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: romTags!.tags.map((tag) {
        return _buildTagBadge(tag);
      }).toList(),
    );
  }

  Widget _buildTagBadge(RomTag tag) {
    return Tooltip(
      message: _getTagDescription(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: tag.color.withValues(alpha: 0.2),
          border: Border.all(color: tag.color.withValues(alpha: 0.5), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag.icon, style: TextStyle(fontSize: fontSize)),
            const SizedBox(width: 3),
            Text(
              tag.text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: tag.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTagDescription(RomTag tag) {
    switch (tag.type) {
      case RomTagType.quality:
        if (tag.text == 'Verified') {
          return 'Verified good dump - confirmed working';
        } else if (tag.text == 'Bad Dump') {
          return 'Bad dump - may not work correctly';
        } else if (tag.text == 'Alternate') {
          return 'Alternate version';
        } else if (tag.text == 'Overdump') {
          return 'Overdump - contains extra data';
        }
        break;

      case RomTagType.modification:
        if (tag.text == 'Hack') {
          return 'Modified/hacked ROM';
        } else if (tag.text == 'Translation') {
          return 'Fan translation';
        } else if (tag.text == 'Pirate') {
          return 'Pirate/bootleg version';
        } else if (tag.text == 'Fixed') {
          return 'Fixed version';
        } else if (tag.text == 'Trainer') {
          return 'Includes cheat trainer';
        }
        break;

      case RomTagType.version:
        return 'Version: ${tag.text}';

      case RomTagType.special:
        return 'Special release: ${tag.text}';

      case RomTagType.media:
        return 'Media info: ${tag.text}';

      case RomTagType.other:
        return tag.text;
    }

    return tag.text;
  }
}
