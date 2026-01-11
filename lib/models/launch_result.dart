/// Result of launching a ROM
class LaunchResult {
  final bool success;
  final String? filePath;
  final bool isPdf;
  final String? error;

  LaunchResult({
    required this.success,
    this.filePath,
    this.isPdf = false,
    this.error,
  });

  factory LaunchResult.success({String? filePath, bool isPdf = false}) {
    return LaunchResult(success: true, filePath: filePath, isPdf: isPdf);
  }

  factory LaunchResult.failure(String error) {
    return LaunchResult(success: false, error: error);
  }
}
