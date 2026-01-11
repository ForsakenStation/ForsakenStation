import 'rom.dart';
import 'package:path/path.dart' as file_path;
import '../utils/platform_names.dart';

class Platform {
  final String name;
  final String path;
  final List<Rom> roms; // For file-based platforms or cached JSONL ROMs
  final int? _romCount; // For JSONL platforms: pre-calculated count

  Platform({
    required this.name,
    required this.path,
    this.roms = const [],
    int? romCount,
  }) : _romCount = romCount;

  String get displayName {
    // Check if this is a collection
    if (name == 'recently_played') return 'Jugados Recientemente';
    if (name == 'downloaded') return 'Descargados';
    if (name == 'favorites') return 'Favoritos';

    return PlatformNames.getDisplayName(name);
  }

  String get shortName {
    return PlatformNames.getShortName(name);
  }

  String get code {
    return file_path.basename(name);
  }

  int get romCount => _romCount ?? roms.length;

  /// True if this is a JSONL platform (lazy-loaded, ROMs not in memory)
  bool get isJsonlPlatform => _romCount != null && roms.isEmpty;

  @override
  String toString() {
    return 'Platform(name: $displayName, roms: $romCount)';
  }
}
