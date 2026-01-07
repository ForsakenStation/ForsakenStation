import 'package:flutter/material.dart';

/// Represents tags/markers extracted from ROM names
///
/// ROMs often include various tags in brackets or parentheses:
/// - Quality: [!] (verified good), [b] (bad dump), [a] (alternate)
/// - Modifications: [h] (hack), [t] (translation), [p] (pirate)
/// - Version: (Rev 1), (v1.1), (Beta)
/// - Special: [Collector's Edition], (Original), etc.
///
/// This class extracts and categorizes these tags.
class RomTags {
  final List<RomTag> tags;

  const RomTags(this.tags);

  /// Extract tags from ROM name
  static RomTags? fromRomName(String romName) {
    final List<RomTag> extractedTags = [];

    // Pattern 1: Square brackets [!], [h], [t], etc.
    final squareBracketPattern = RegExp(r'\[([^\]]+)\]');
    final squareMatches = squareBracketPattern.allMatches(romName);

    for (final match in squareMatches) {
      final tagText = match.group(1);
      if (tagText != null) {
        final tag = _parseTag(tagText);
        if (tag != null) {
          extractedTags.add(tag);
        }
      }
    }

    // Pattern 2: Parentheses tags that aren't regions or languages
    final parenPattern = RegExp(r'\(([^)]+)\)');
    final parenMatches = parenPattern.allMatches(romName);

    for (final match in parenMatches) {
      final tagText = match.group(1);
      if (tagText != null && _isTagNotRegionOrLanguage(tagText)) {
        final tag = _parseTag(tagText);
        if (tag != null) {
          extractedTags.add(tag);
        }
      }
    }

    return extractedTags.isEmpty ? null : RomTags(extractedTags);
  }

  static bool _isTagNotRegionOrLanguage(String text) {
    final lower = text.toLowerCase().trim();

    // Skip empty or very short text
    if (lower.isEmpty || lower.length <= 1) {
      return false;
    }

    // Skip if it looks like a region
    final regionKeywords = [
      'usa',
      'us',
      'europe',
      'eu',
      'japan',
      'jp',
      'jap',
      'world',
      'asia',
      'australia',
      'au',
      'brazil',
      'br',
      'canada',
      'ca',
      'china',
      'cn',
      'spain',
      'es',
      'germany',
      'de',
      'france',
      'fr',
      'italy',
      'it',
      'uk',
      'gb',
      'korea',
      'kr',
      'netherlands',
      'nl',
      'sweden',
      'se',
      'russia',
      'ru',
      'pal',
      'ntsc',
    ];

    // Exact match check
    if (regionKeywords.contains(lower)) {
      return false;
    }

    // Check if it's a comma-separated list of regions
    if (lower.contains(',')) {
      final parts = lower.split(',').map((s) => s.trim());
      // If all parts are regions, skip this
      if (parts.every((part) => regionKeywords.contains(part))) {
        return false;
      }
    }

    // Skip if it's language codes (2-letter codes separated by commas)
    if (RegExp(
      r'^[a-z]{2}(,[a-z]{2})*$',
      caseSensitive: false,
    ).hasMatch(text)) {
      return false;
    }

    // Skip if it's just a number (like disc numbers without text)
    if (RegExp(r'^\d+$').hasMatch(lower)) {
      return false;
    }

    return true;
  }

  static RomTag? _parseTag(String text) {
    final lower = text.toLowerCase().trim();

    // Quality tags
    if (lower == '!' || lower == 'verified') {
      return const RomTag(
        text: 'Verified',
        type: RomTagType.quality,
        icon: '✓',
        color: Colors.green,
      );
    }
    if (lower == 'b' || lower == 'bad' || lower == 'bad dump') {
      return const RomTag(
        text: 'Bad Dump',
        type: RomTagType.quality,
        icon: '✗',
        color: Colors.red,
      );
    }
    if (lower == 'a' || lower == 'alternate' || lower == 'alt') {
      return const RomTag(
        text: 'Alternate',
        type: RomTagType.quality,
        icon: '≈',
        color: Colors.blue,
      );
    }
    if (lower == 'o' || lower == 'overdump') {
      return const RomTag(
        text: 'Overdump',
        type: RomTagType.quality,
        icon: '⊕',
        color: Colors.orange,
      );
    }

    // Modification tags
    if (lower == 'h' || lower == 'hack' || lower.contains('hack')) {
      return const RomTag(
        text: 'Hack',
        type: RomTagType.modification,
        icon: '🔧',
        color: Colors.purple,
      );
    }
    if (lower == 't' || lower.contains('translation')) {
      return const RomTag(
        text: 'Translation',
        type: RomTagType.modification,
        icon: '🌐',
        color: Colors.cyan,
      );
    }
    if (lower == 'p' || lower == 'pirate') {
      return const RomTag(
        text: 'Pirate',
        type: RomTagType.modification,
        icon: '🏴‍☠️',
        color: Colors.deepOrange,
      );
    }
    if (lower == 'f' || lower == 'fixed') {
      return const RomTag(
        text: 'Fixed',
        type: RomTagType.modification,
        icon: '🔨',
        color: Colors.teal,
      );
    }

    // Version tags
    if (lower.startsWith('rev') || lower.startsWith('revision')) {
      return RomTag(
        text: text,
        type: RomTagType.version,
        icon: '📝',
        color: Colors.amber,
      );
    }
    if (lower.startsWith('v') && RegExp(r'^v\d').hasMatch(lower)) {
      return RomTag(
        text: text,
        type: RomTagType.version,
        icon: '📝',
        color: Colors.amber,
      );
    }
    if (lower == 'beta' ||
        lower == 'alpha' ||
        lower == 'proto' ||
        lower == 'prototype' ||
        lower == 'demo' ||
        lower == 'sample') {
      return RomTag(
        text: text,
        type: RomTagType.version,
        icon: '🔧',
        color: Colors.orange,
      );
    }

    // Special editions
    if (lower.contains('edition') ||
        lower.contains('collection') ||
        lower.contains('original') ||
        lower.contains('remaster') ||
        lower.contains('enhanced') ||
        lower.contains('deluxe')) {
      return RomTag(
        text: text,
        type: RomTagType.special,
        icon: '⭐',
        color: Colors.yellow,
      );
    }

    // Media tags
    if (lower.contains('disc') ||
        lower.contains('disk') ||
        lower.contains('cd') ||
        lower.contains('side')) {
      return RomTag(
        text: text,
        type: RomTagType.media,
        icon: '💿',
        color: Colors.blueGrey,
      );
    }

    // Trainer/cheat
    if (lower.contains('trainer') || lower == 'tr') {
      return RomTag(
        text: 'Trainer',
        type: RomTagType.modification,
        icon: '🎯',
        color: Colors.pink,
      );
    }

    // If we can't categorize it but it's short, show it as misc
    if (text.length <= 20) {
      return RomTag(
        text: text,
        type: RomTagType.other,
        icon: '•',
        color: Colors.grey,
      );
    }

    return null;
  }

  bool get isEmpty => tags.isEmpty;
  bool get isNotEmpty => tags.isNotEmpty;

  @override
  String toString() => 'RomTags(${tags.map((t) => t.text).join(', ')})';
}

/// Represents a single ROM tag
class RomTag {
  final String text;
  final RomTagType type;
  final String icon;
  final Color color;

  const RomTag({
    required this.text,
    required this.type,
    required this.icon,
    required this.color,
  });
}

/// Types of ROM tags
enum RomTagType {
  quality, // [!], [b], [a] - dump quality
  modification, // [h], [t], [p] - hacks, translations, pirates
  version, // Rev 1, v1.1, Beta - version info
  special, // Collector's Edition, Remaster - special releases
  media, // Disc 1, CD 2 - multi-disc info
  other, // Miscellaneous tags
}
