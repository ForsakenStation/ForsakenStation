import '../services/debug_service.dart';
import 'dart:io';

enum RomItemType { folder, rom }

class RomItem {
  final String name;
  final String path;
  final RomItemType type;
  final String? downloadUrl;

  RomItem({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
  });

  String get displayName {
    // No need to remove extension anymore - show full filename
    return name;
  }

  bool get isFolder => type == RomItemType.folder;
  bool get isRom => type == RomItemType.rom;

  Future<String?> loadDownloadUrl() async {
    if (type != RomItemType.rom) return null;

    try {
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.trim();
      }
    } catch (e) {
      DebugService.instance.error('Error loading download URL for $name', tag: 'RomItem', error: e);
    }
    return null;
  }

  @override
  String toString() {
    return 'RomItem(name: $displayName, type: $type)';
  }
}
