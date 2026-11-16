/// Model for game information loaded from gamelist.xml files
/// This contains metadata about ROMs such as description, genre, developer, etc.
/// Media path fields are optional and used to avoid filesystem scanning when
/// the gamelist.xml has been enriched with media information.
class GameInfo {
  final String path;
  final String name;
  final String? desc;
  final double? rating;
  final DateTime? releaseDate;
  final String? developer;
  final String? publisher;
  final String? genre;
  final int? players;

  // Media paths (relative to media base path, e.g., "snes/3dboxes/rom.webp")
  final String? box3dPath;
  final String? coverPath;
  final String? marqueePath;
  final String? screenshotPath;
  final String? mixImagePath;
  final String? videoPath;
  final String? titlescreenPath;
  final String? manualPath;
  final String? backcoverPath;
  final String? fanartPath;

  const GameInfo({
    required this.path,
    required this.name,
    this.desc,
    this.rating,
    this.releaseDate,
    this.developer,
    this.publisher,
    this.genre,
    this.players,
    this.box3dPath,
    this.coverPath,
    this.marqueePath,
    this.screenshotPath,
    this.mixImagePath,
    this.videoPath,
    this.titlescreenPath,
    this.manualPath,
    this.backcoverPath,
    this.fanartPath,
  });

  /// Creates a GameInfo instance from XML element data
  factory GameInfo.fromXml(Map<String, String?> data) {
    // Parse release date (format: YYYYMMDDTHHMMSS)
    DateTime? parseReleaseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        // Format: 19901121T000000
        if (dateStr.length >= 8) {
          final year = int.parse(dateStr.substring(0, 4));
          final month = int.parse(dateStr.substring(4, 6));
          final day = int.parse(dateStr.substring(6, 8));
          return DateTime(year, month, day);
        }
      } catch (e) {
        // If parsing fails, return null
        return null;
      }
      return null;
    }

    // Parse rating (0.0 - 1.0)
    double? parseRating(String? ratingStr) {
      if (ratingStr == null || ratingStr.isEmpty) return null;
      try {
        final rating = double.parse(ratingStr);
        return rating.clamp(0.0, 1.0);
      } catch (e) {
        return null;
      }
    }

    // Parse players count
    int? parsePlayers(String? playersStr) {
      if (playersStr == null || playersStr.isEmpty) return null;
      try {
        return int.parse(playersStr);
      } catch (e) {
        return null;
      }
    }

    String? unescapeHtml(String? raw) {
      if (raw == null || !raw.contains('&')) return raw;
      // Run twice to handle double-escaped entities (e.g. &amp;quot; -> &quot; -> ")
      var result = raw;
      for (var i = 0; i < 2; i++) {
        result = result
            .replaceAll('&amp;', '&')
            .replaceAll('&quot;', '"')
            .replaceAll('&apos;', "'")
            .replaceAll('&#39;', "'")
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&nbsp;', ' ')
            .replaceAllMapped(
              RegExp(r'&#x([0-9a-fA-F]+);'),
              (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
            )
            .replaceAllMapped(
              RegExp(r'&#(\d+);'),
              (m) => String.fromCharCode(int.parse(m.group(1)!)),
            );
      }
      return result;
    }

    return GameInfo(
      path: data['path'] ?? '',
      name: unescapeHtml(data['name']) ?? '',
      desc: unescapeHtml(data['desc']),
      rating: parseRating(data['rating']),
      releaseDate: parseReleaseDate(data['releasedate']),
      developer: unescapeHtml(data['developer']),
      publisher: unescapeHtml(data['publisher']),
      genre: unescapeHtml(data['genre']),
      players: parsePlayers(data['players']),
      box3dPath: data['media_box3d'],
      coverPath: data['media_cover'],
      marqueePath: data['media_marquee'],
      screenshotPath: data['media_screenshot'],
      mixImagePath: data['media_miximage'],
      videoPath: data['media_video'],
      titlescreenPath: data['media_titlescreen'],
      manualPath: data['media_manual'],
      backcoverPath: data['media_backcover'],
      fanartPath: data['media_fanart'],
    );
  }

  /// Returns true if this GameInfo has any media path information
  bool get hasMediaPaths =>
      box3dPath != null ||
      coverPath != null ||
      marqueePath != null ||
      screenshotPath != null ||
      mixImagePath != null ||
      videoPath != null ||
      titlescreenPath != null ||
      manualPath != null ||
      backcoverPath != null ||
      fanartPath != null;

  /// Returns a formatted release year string
  String? get releaseYear {
    if (releaseDate == null) return null;
    return releaseDate!.year.toString();
  }

  /// Returns a formatted rating string (e.g., "95%")
  String? get ratingPercentage {
    if (rating == null) return null;
    return '${(rating! * 100).round()}%';
  }

  /// Returns a formatted player count (e.g., "1-2 players")
  String? get playersText {
    if (players == null) return null;
    if (players == 1) return '1 player';
    return '$players players';
  }

  @override
  String toString() {
    return 'GameInfo(name: $name, path: $path, genre: $genre, developer: $developer)';
  }
}
