import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// Enhanced error information with recovery suggestions
class BiosDownloadError {
  final String message;
  final String? details;
  final List<String> recoverySuggestions;
  final BiosErrorType type;

  const BiosDownloadError({
    required this.message,
    this.details,
    required this.recoverySuggestions,
    required this.type,
  });

  /// Create error from exception with automatic categorization
  factory BiosDownloadError.fromException(Object exception) {
    final errorMessage = exception.toString();

    // Network-related errors
    if (errorMessage.contains('Failed host lookup') ||
        errorMessage.contains('No route to host') ||
        errorMessage.contains('Network is unreachable')) {
      return BiosDownloadError(
        message: 'Network connection failed',
        details: errorMessage,
        type: BiosErrorType.network,
        recoverySuggestions: [
          'Check your internet connection',
          'Try again in a few moments',
          'Verify DNS settings',
          'Try using a VPN if access is restricted',
        ],
      );
    }

    // HTTP errors
    if (errorMessage.contains('HTTP 404')) {
      return BiosDownloadError(
        message: 'File not found on server',
        details: errorMessage,
        type: BiosErrorType.fileNotFound,
        recoverySuggestions: [
          'The BIOS file may have been moved or renamed',
          'Try downloading from an alternative source',
          'Check if the file exists in a different branch/repository',
          'Report this issue if problem persists',
        ],
      );
    }

    if (errorMessage.contains('HTTP 403')) {
      return BiosDownloadError(
        message: 'Access denied by server',
        details: errorMessage,
        type: BiosErrorType.accessDenied,
        recoverySuggestions: [
          'Server may be blocking downloads',
          'Try again later - server may be temporarily restricted',
          'Use VPN if access is region-restricted',
          'Check if authentication is required',
        ],
      );
    }

    if (errorMessage.contains('HTTP 429')) {
      return BiosDownloadError(
        message: 'Rate limit exceeded',
        details: errorMessage,
        type: BiosErrorType.rateLimited,
        recoverySuggestions: [
          'Wait a few minutes before trying again',
          'Reduce number of simultaneous downloads',
          'Server is protecting against excessive requests',
        ],
      );
    }

    // Checksum errors
    if (errorMessage.contains('checksum mismatch') ||
        errorMessage.contains('MD5 mismatch') ||
        errorMessage.contains('SHA1 mismatch')) {
      return BiosDownloadError(
        message: 'File integrity verification failed',
        details: errorMessage,
        type: BiosErrorType.checksumMismatch,
        recoverySuggestions: [
          'File may be corrupted during download',
          'Try downloading again',
          'Check if file was updated on server',
          'Verify your internet connection stability',
        ],
      );
    }

    // Size errors
    if (errorMessage.contains('size mismatch') ||
        errorMessage.contains('Size mismatch')) {
      return BiosDownloadError(
        message: 'Unexpected file size',
        details: errorMessage,
        type: BiosErrorType.sizeMismatch,
        recoverySuggestions: [
          'File may be different version than expected',
          'Download may be incomplete',
          'Try downloading again',
          'Check available disk space',
        ],
      );
    }

    // Storage errors
    if (errorMessage.contains('No space left') ||
        errorMessage.contains('disk full') ||
        errorMessage.contains('FileSystemException')) {
      return BiosDownloadError(
        message: 'Storage error',
        details: errorMessage,
        type: BiosErrorType.storage,
        recoverySuggestions: [
          'Free up disk space',
          'Check file permissions',
          'Ensure destination directory is writable',
          'Try downloading to a different location',
        ],
      );
    }

    // Timeout errors
    if (errorMessage.contains('TimeoutException') ||
        errorMessage.contains('timed out')) {
      return BiosDownloadError(
        message: 'Download timeout',
        details: errorMessage,
        type: BiosErrorType.timeout,
        recoverySuggestions: [
          'Internet connection may be slow',
          'Server may be overloaded',
          'Try again with a stable connection',
          'Check if firewall is blocking the connection',
        ],
      );
    }

    // Archive extraction errors
    if (errorMessage.contains('Archive') ||
        errorMessage.contains('extraction') ||
        errorMessage.contains('Invalid ZIP')) {
      return BiosDownloadError(
        message: 'Archive extraction failed',
        details: errorMessage,
        type: BiosErrorType.archiveError,
        recoverySuggestions: [
          'Downloaded archive may be corrupted',
          'Try downloading the file again',
          'Check if correct extraction tool is available',
          'Verify file is a valid archive format',
        ],
      );
    }

    // Generic/unknown errors
    return BiosDownloadError(
      message: 'Download failed',
      details: errorMessage,
      type: BiosErrorType.unknown,
      recoverySuggestions: [
        'Try downloading again',
        'Check your internet connection',
        'Verify the file is still available',
        'Contact support if problem persists',
      ],
    );
  }

  /// Get appropriate icon for this error type
  IconData get icon {
    switch (type) {
      case BiosErrorType.network:
        return Icons.wifi_off;
      case BiosErrorType.fileNotFound:
        return Icons.file_download_off;
      case BiosErrorType.accessDenied:
        return Icons.lock;
      case BiosErrorType.rateLimited:
        return Icons.hourglass_empty;
      case BiosErrorType.checksumMismatch:
        return Icons.verified_user_outlined;
      case BiosErrorType.sizeMismatch:
        return Icons.straighten;
      case BiosErrorType.storage:
        return Icons.storage;
      case BiosErrorType.timeout:
        return Icons.access_time;
      case BiosErrorType.archiveError:
        return Icons.folder_zip;
      case BiosErrorType.unknown:
        return Icons.error_outline;
    }
  }

  /// Get color associated with this error type
  Color get color {
    switch (type) {
      case BiosErrorType.network:
        return Colors.orange;
      case BiosErrorType.fileNotFound:
        return Colors.red;
      case BiosErrorType.accessDenied:
        return Colors.red;
      case BiosErrorType.rateLimited:
        return Colors.amber;
      case BiosErrorType.checksumMismatch:
        return Colors.deepOrange;
      case BiosErrorType.sizeMismatch:
        return Colors.deepOrange;
      case BiosErrorType.storage:
        return Colors.purple;
      case BiosErrorType.timeout:
        return Colors.orange;
      case BiosErrorType.archiveError:
        return Colors.red;
      case BiosErrorType.unknown:
        return Colors.grey;
    }
  }
}

enum BiosErrorType {
  network,
  fileNotFound,
  accessDenied,
  rateLimited,
  checksumMismatch,
  sizeMismatch,
  storage,
  timeout,
  archiveError,
  unknown,
}

/// Widget to display enhanced error information
class BiosErrorDisplay extends StatelessWidget {
  final BiosDownloadError error;
  final VoidCallback? onRetry;
  final bool showDetails;

  const BiosErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: error.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: error.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error header
          Row(
            children: [
              Icon(error.icon, color: error.color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error.message,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: error.color,
                  ),
                ),
              ),
            ],
          ),

          // Error details (if available and requested)
          if (showDetails && error.details != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                error.details!,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.grey,
                ),
              ),
            ),
          ],

          // Recovery suggestions
          if (error.recoverySuggestions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.whatYouCanTry,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            ...error.recoverySuggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Retry button
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(AppLocalizations.of(context)!.tryAgain),
                style: ElevatedButton.styleFrom(
                  backgroundColor: error.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
