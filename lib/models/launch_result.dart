import 'download_result.dart';

/// Result of launching a ROM
class LaunchResult {
  final bool success;
  final String? filePath;
  final bool isPdf;
  final String? error;
  final DownloadErrorType? downloadErrorType;

  LaunchResult({
    required this.success,
    this.filePath,
    this.isPdf = false,
    this.error,
    this.downloadErrorType,
  });

  factory LaunchResult.success({String? filePath, bool isPdf = false}) {
    return LaunchResult(success: true, filePath: filePath, isPdf: isPdf);
  }

  factory LaunchResult.failure(
    String error, {
    DownloadErrorType? downloadErrorType,
  }) {
    return LaunchResult(
      success: false,
      error: error,
      downloadErrorType: downloadErrorType,
    );
  }

  /// Whether this failure is due to an authentication error
  bool get isAuthError => downloadErrorType == DownloadErrorType.authRequired;
}
