/// The type of error that occurred during download
enum DownloadErrorType {
  /// HTTP 401 — authentication required
  authRequired,

  /// HTTP 403 — access denied
  accessDenied,

  /// HTTP 404 or URL could not be resolved
  notFound,

  /// User cancelled the download
  cancelled,

  /// Network / IO / other failure
  generic,
}

/// Result of a ROM download attempt.
///
/// Replaces the previous nullable String return so callers can
/// distinguish between different failure modes (e.g. 401 auth
/// required vs generic error).
class DownloadResult {
  final bool success;
  final String? filePath;
  final DownloadErrorType? errorType;
  final String? errorMessage;
  final int? httpStatusCode;

  const DownloadResult._({
    required this.success,
    this.filePath,
    this.errorType,
    this.errorMessage,
    this.httpStatusCode,
  });

  factory DownloadResult.ok(String filePath) {
    return DownloadResult._(success: true, filePath: filePath);
  }

  factory DownloadResult.error(
    DownloadErrorType type, {
    String? message,
    int? httpStatusCode,
  }) {
    return DownloadResult._(
      success: false,
      errorType: type,
      errorMessage: message,
      httpStatusCode: httpStatusCode,
    );
  }

  /// Whether this is an authentication-related failure
  bool get isAuthError => errorType == DownloadErrorType.authRequired;
}
