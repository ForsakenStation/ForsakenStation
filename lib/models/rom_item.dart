import '../services/debug_service.dart';
import 'dart:io';
import 'language_info.dart';
import 'region_info.dart';
import 'rom_tags.dart';

enum RomItemType { folder, rom }

class RomItem {
  final String name;
  final String path;
  final RomItemType type;
  final String? downloadUrl;
  final int? romCount; // Number of ROMs inside folder (only for folders)

  // Cached extracted info from filename
  LanguageInfo? _languages;
  RegionInfo? _regions;
  RomTags? _tags;

  RomItem({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
    this.romCount,
  });

  String get displayName {
    return name
        .substring(
          0,
          name.lastIndexOf('.') > 0 ? name.lastIndexOf('.') : name.length,
        )
        .replaceAll('_', ' ');
  }

  bool get isFolder => type == RomItemType.folder;

  bool get isRom => type == RomItemType.rom;

  /// Extract language info from ROM filename
  /// Caches result for performance
  LanguageInfo? get languages {
    if (_languages == null && isRom) {
      _languages = LanguageInfo.fromRomName(name);
    }
    return _languages;
  }

  /// Extract region info from ROM filename
  /// Caches result for performance
  RegionInfo? get regions {
    if (_regions == null && isRom) {
      _regions = RegionInfo.fromRomName(name);
    }
    return _regions;
  }

  /// Extract ROM tags from filename
  /// Caches result for performance
  RomTags? get tags {
    if (_tags == null && isRom) {
      _tags = RomTags.fromRomName(name);
    }
    return _tags;
  }

  Future<String?> loadDownloadUrl() async {
    if (type != RomItemType.rom) return null;

    try {
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.trim();
      }
    } catch (e) {
      DebugService.instance.error(
        'Error loading download URL for $name',
        tag: 'RomItem',
        error: e,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RomItem(name: $displayName, type: $type)';
  }
}
