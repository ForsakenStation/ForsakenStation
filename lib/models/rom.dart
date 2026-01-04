import '../services/debug_service.dart';
import 'dart:io';

class Rom {
  final String name;
  final String fileName;
  final String platform;
  final String urlFilePath;
  String? downloadUrl;
  String? localPath;
  bool isDownloading = false;
  double downloadProgress = 0.0;

  Rom({
    required this.name,
    required this.fileName,
    required this.platform,
    required this.urlFilePath,
    this.downloadUrl,
    this.localPath,
  });

  Future<String?> loadDownloadUrl() async {
    try {
      final file = File(urlFilePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        downloadUrl = content.trim();
        return downloadUrl;
      }
    } catch (e) {
      DebugService.instance.error('Error loading download URL for $name', tag: 'Rom', error: e);
    }
    return null;
  }

  String get displayName {
    // Remove extension from filename for display
    return name.replaceAll('.txt', '');
  }

  @override
  String toString() {
    return 'Rom(name: $displayName, platform: $platform)';
  }
}
