/// Model for game information loaded from gamelist.xml files
/// This contains metadata about ROMs such as description, genre, developer, etc.
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

    return GameInfo(
      path: data['path'] ?? '',
      name: data['name'] ?? '',
      desc: data['desc'],
      rating: parseRating(data['rating']),
      releaseDate: parseReleaseDate(data['releasedate']),
      developer: data['developer'],
      publisher: data['publisher'],
      genre: data['genre'],
      players: parsePlayers(data['players']),
    );
  }

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
