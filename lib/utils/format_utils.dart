// Shared formatting utilities.

/// Formats a byte count into a human-readable string (e.g. "1.2 MB").
///
/// Supports B, KB, MB, and GB. Uses 1024-based units.
/// Set [compact] to true to omit the space between value and unit.
String formatBytes(int bytes, {bool compact = false}) {
  final sep = compact ? '' : ' ';
  if (bytes < 1024) return '$bytes${sep}B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)}${sep}KB';
  }
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}${sep}MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}${sep}GB';
}
