import 'dart:async';
import 'package:http/http.dart' as http;
import 'debug_service.dart';

/// Service to handle special download providers (MediaFire, MEGA, etc.)
/// that require HTML scraping or API calls to get direct download links
class DownloadResolverService {
  final _debug = DebugService.instance;

  /// Detects the type of URL and returns appropriate handler
  DownloadUrlType detectUrlType(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.contains('mediafire.com')) {
      return DownloadUrlType.mediafire;
    } else if (lowerUrl.contains('mega.nz') ||
        lowerUrl.contains('mega.co.nz')) {
      return DownloadUrlType.mega;
    } else if (lowerUrl.startsWith('magnet:')) {
      return DownloadUrlType.magnet;
    } else if (lowerUrl.endsWith('.torrent')) {
      return DownloadUrlType.torrent;
    } else if (lowerUrl.contains('drive.google.com') ||
        lowerUrl.contains('docs.google.com')) {
      return DownloadUrlType.googleDrive;
    } else if (lowerUrl.contains('dropbox.com')) {
      return DownloadUrlType.dropbox;
    } else if (lowerUrl.contains('1fichier.com')) {
      return DownloadUrlType.oneFichier;
    }

    return DownloadUrlType.direct;
  }

  /// Resolves URL to direct download link
  /// Returns null if resolution fails
  Future<String?> resolveDownloadUrl(String url) async {
    final urlType = detectUrlType(url);

    _debug.info(
      'Detected URL type: $urlType for URL: $url',
      tag: 'DownloadResolver',
    );

    switch (urlType) {
      case DownloadUrlType.mediafire:
        return await _resolveMediaFireUrl(url);

      case DownloadUrlType.mega:
        _debug.warning(
          'MEGA downloads not yet supported',
          tag: 'DownloadResolver',
        );
        return null;

      case DownloadUrlType.magnet:
      case DownloadUrlType.torrent:
        _debug.warning(
          'Torrent downloads not yet supported',
          tag: 'DownloadResolver',
        );
        return null;

      case DownloadUrlType.googleDrive:
        return await _resolveGoogleDriveUrl(url);

      case DownloadUrlType.dropbox:
        return await _resolveDropboxUrl(url);

      case DownloadUrlType.oneFichier:
        _debug.warning(
          '1fichier downloads not yet supported',
          tag: 'DownloadResolver',
        );
        return null;

      case DownloadUrlType.direct:
        // Already a direct URL
        return url;
    }
  }

  /// Resolves MediaFire URL by scraping the download page
  /// MediaFire requires fetching the HTML page and extracting the direct link
  Future<String?> _resolveMediaFireUrl(String url) async {
    try {
      _debug.info('Resolving MediaFire URL: $url', tag: 'DownloadResolver');

      // Fetch the MediaFire page
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        _debug.error(
          'MediaFire page fetch failed with status: ${response.statusCode}',
          tag: 'DownloadResolver',
        );
        return null;
      }

      final html = response.body;

      // Method 1: Look for download button link
      // Pattern: <a href="https://download[number].mediafire.com/..." class="input popsok" id="downloadButton"
      final downloadButtonPattern = RegExp(
        r'href="(https?://download\d*\.mediafire\.com/[^"]+)"',
        caseSensitive: false,
      );

      final match = downloadButtonPattern.firstMatch(html);
      if (match != null) {
        final directUrl = match.group(1);
        if (directUrl != null) {
          _debug.info(
            'Found MediaFire direct URL: $directUrl',
            tag: 'DownloadResolver',
          );
          return directUrl;
        }
      }

      // Method 2: Look for alternative download link patterns
      // Pattern: "https://download*.mediafire.com/..." in JavaScript or meta tags
      final altPattern = RegExp(
        r'(https?://download\d*\.mediafire\.com/[^\s"<>]+)',
        caseSensitive: false,
      );

      final altMatch = altPattern.firstMatch(html);
      if (altMatch != null) {
        final directUrl = altMatch.group(1);
        if (directUrl != null) {
          _debug.info(
            'Found MediaFire alt URL: $directUrl',
            tag: 'DownloadResolver',
          );
          return directUrl;
        }
      }

      _debug.error(
        'Could not extract direct download link from MediaFire page',
        tag: 'DownloadResolver',
      );
      return null;
    } catch (e) {
      _debug.error(
        'Error resolving MediaFire URL',
        tag: 'DownloadResolver',
        error: e,
      );
      return null;
    }
  }

  /// Resolves Google Drive URL to direct download
  Future<String?> _resolveGoogleDriveUrl(String url) async {
    try {
      // Google Drive direct download format:
      // https://drive.google.com/uc?export=download&id=FILE_ID

      // Extract file ID from various Google Drive URL formats
      String? fileId;

      // Format 1: /file/d/FILE_ID/view
      final pattern1 = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match1 = pattern1.firstMatch(url);
      if (match1 != null) {
        fileId = match1.group(1);
      }

      // Format 2: id=FILE_ID
      if (fileId == null) {
        final pattern2 = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)');
        final match2 = pattern2.firstMatch(url);
        if (match2 != null) {
          fileId = match2.group(1);
        }
      }

      if (fileId != null) {
        final directUrl =
            'https://drive.google.com/uc?export=download&id=$fileId';
        _debug.info(
          'Converted Google Drive URL to: $directUrl',
          tag: 'DownloadResolver',
        );
        return directUrl;
      }

      _debug.warning(
        'Could not extract file ID from Google Drive URL',
        tag: 'DownloadResolver',
      );
      return null;
    } catch (e) {
      _debug.error(
        'Error resolving Google Drive URL',
        tag: 'DownloadResolver',
        error: e,
      );
      return null;
    }
  }

  /// Resolves Dropbox URL to direct download
  Future<String?> _resolveDropboxUrl(String url) async {
    try {
      // Dropbox direct download: replace ?dl=0 with ?dl=1
      // or append ?dl=1 if not present

      if (url.contains('?dl=0')) {
        final directUrl = url.replaceAll('?dl=0', '?dl=1');
        _debug.info(
          'Converted Dropbox URL to: $directUrl',
          tag: 'DownloadResolver',
        );
        return directUrl;
      } else if (url.contains('?')) {
        final directUrl = url.replaceAll('?', '?dl=1&');
        _debug.info(
          'Converted Dropbox URL to: $directUrl',
          tag: 'DownloadResolver',
        );
        return directUrl;
      } else {
        final directUrl = '$url?dl=1';
        _debug.info(
          'Converted Dropbox URL to: $directUrl',
          tag: 'DownloadResolver',
        );
        return directUrl;
      }
    } catch (e) {
      _debug.error(
        'Error resolving Dropbox URL',
        tag: 'DownloadResolver',
        error: e,
      );
      return null;
    }
  }
}

/// Types of download URLs
enum DownloadUrlType {
  direct, // Direct download link
  mediafire, // MediaFire file hosting
  mega, // MEGA cloud storage
  googleDrive, // Google Drive
  dropbox, // Dropbox
  oneFichier, // 1fichier.com
  magnet, // Magnet link (torrent)
  torrent, // .torrent file
}
