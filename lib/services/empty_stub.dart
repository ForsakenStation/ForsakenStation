// Empty stub for non-web platforms
class WebEmulatorService {
  static WebEmulatorService get instance => WebEmulatorService();

  /// CORS proxy URL (no-op on non-web platforms)
  String? corsProxyUrl;

  // Stub methods that do nothing on non-web platforms
  Future<void> initialize() async {
    // No-op on non-web platforms
  }
}
