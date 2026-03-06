import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
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

    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: romTags!.tags.map((tag) {
        return _buildTagBadge(tag, l10n);
      }).toList(),
    );
  }

  Widget _buildTagBadge(RomTag tag, AppLocalizations l10n) {
    return Tooltip(
      message: _getTagDescription(tag, l10n),
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

  String _getTagDescription(RomTag tag, AppLocalizations l10n) {
    switch (tag.type) {
      case RomTagType.quality:
        if (tag.text == 'Verified') {
          return l10n.tagVerifiedGoodDump;
        } else if (tag.text == 'Bad Dump') {
          return l10n.tagBadDump;
        } else if (tag.text == 'Alternate') {
          return l10n.tagAlternateVersion;
        } else if (tag.text == 'Overdump') {
          return l10n.tagOverdump;
        }
        break;

      case RomTagType.modification:
        if (tag.text == 'Hack') {
          return l10n.tagModifiedHacked;
        } else if (tag.text == 'Translation') {
          return l10n.tagFanTranslation;
        } else if (tag.text == 'Pirate') {
          return l10n.tagPirateBootleg;
        } else if (tag.text == 'Fixed') {
          return l10n.tagFixedVersion;
        } else if (tag.text == 'Trainer') {
          return l10n.tagCheatTrainer;
        }
        break;

      case RomTagType.version:
        return l10n.tagVersion(tag.text);

      case RomTagType.special:
        return l10n.tagSpecialRelease(tag.text);

      case RomTagType.media:
        return l10n.tagMediaInfo(tag.text);

      case RomTagType.other:
        return tag.text;
    }

    return tag.text;
  }
}
