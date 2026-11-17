import 'package:path/path.dart' as p;

/// Security validation helpers for download URLs and filesystem paths.
class SecurityValidator {
  const SecurityValidator._();

  static const Set<String> _allowedSchemes = {'http', 'https'};

  /// Returns true if [url] is a well-formed HTTP/HTTPS URL with a valid host.
  static bool isValidDownloadUrl(String? url) {
    if (url == null) return false;
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
    if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) return false;
    if (uri.host.trim().isEmpty) return false;
    if (uri.userInfo.isNotEmpty) return false;

    return true;
  }

  /// Returns true if [targetPath] resolves strictly inside (or equal to) [basePath].
  /// Prevents directory traversal (`../`) and Zip Slip attacks.
  static bool isSafePathWithinBase(String basePath, String targetPath) {
    if (basePath.isEmpty || targetPath.isEmpty) return false;
    if (targetPath.contains('\x00')) return false;

    final normalizedBase = p.normalize(p.absolute(basePath));
    final normalizedTarget = p.normalize(p.absolute(targetPath));

    return normalizedBase == normalizedTarget ||
        p.isWithin(normalizedBase, normalizedTarget);
  }

  /// Sanitizes a filename by removing path separators, null bytes, and `..` segments.
  static String sanitizeFileName(String fileName) {
    final base = p.basename(fileName.replaceAll('\\', '/')).replaceAll('\x00', '');
    final cleaned = base.replaceAll('..', '').trim();
    return cleaned.isEmpty ? 'unnamed' : cleaned;
  }
}
