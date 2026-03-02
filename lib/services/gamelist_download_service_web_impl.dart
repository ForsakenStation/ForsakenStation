// Web implementation stub for GamelistDownloadService
// On web, gamelists are not supported for local download

Future<bool> isGamelistsDownloaded() async {
  return false;
}

Future<bool> downloadAndExtractGamelists({
  void Function(double progress, int received, int total)? onProgress,
}) async {
  return true;
}

Future<bool> deleteGamelists() async {
  return true;
}

Future<Map<String, dynamic>> getGamelistDownloadInfo() async {
  return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
}
