import 'rom.dart';

/// Represents a collection of ROMs across multiple platforms
/// Examples: Recently Played, Downloaded, Favorites, Genre-based, etc.
class Collection {
  final String id;
  final String name;
  final String displayName;
  final CollectionType type;
  final List<Rom> roms;
  final int? _romCount; // For lazy-loaded collections

  Collection({
    required this.id,
    required this.name,
    required this.displayName,
    required this.type,
    this.roms = const [],
    int? romCount,
  }) : _romCount = romCount;

  int get romCount => _romCount ?? roms.length;

  /// True if this is a lazy-loaded collection (ROMs not in memory)
  bool get isLazyLoaded => _romCount != null && roms.isEmpty;

  /// Get icon for this collection type
  String get icon {
    switch (type) {
      case CollectionType.recentlyPlayed:
        return 'history';
      case CollectionType.downloaded:
        return 'download';
      case CollectionType.favorites:
        return 'favorite';
      case CollectionType.genre:
        return 'category';
      case CollectionType.custom:
        return 'folder_special';
    }
  }

  @override
  String toString() {
    return 'Collection(id: $id, name: $displayName, roms: $romCount)';
  }
}

/// Types of collections
enum CollectionType { recentlyPlayed, downloaded, favorites, genre, custom }
