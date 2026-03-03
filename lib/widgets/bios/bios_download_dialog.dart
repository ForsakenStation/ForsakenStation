import 'package:flutter/material.dart';
import '../../services/bios_download_service.dart';
import '../../l10n/generated/app_localizations.dart';
import 'enhanced_error_display.dart';

class BiosDownloadDialog extends StatefulWidget {
  final List<String> filesToDownload;
  final String title;
  final Future<bool> Function(void Function(Object)) downloadFunction;

  const BiosDownloadDialog({
    super.key,
    required this.filesToDownload,
    required this.title,
    required this.downloadFunction,
  });

  @override
  State<BiosDownloadDialog> createState() => _BiosDownloadDialogState();

  static Future<bool?> showSinglePlatform({
    required BuildContext context,
    required String platformName,
    required List<String> filesToDownload,
    required Future<bool> Function(void Function(DownloadProgress))
    downloadFunction,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BiosDownloadDialog(
        title: l10n.downloadingPlatformBios(platformName),
        filesToDownload: filesToDownload,
        downloadFunction: (onProgress) =>
            downloadFunction((progress) => onProgress(progress)),
      ),
    );
  }

  static Future<bool?> showBatchDownload({
    required BuildContext context,
    required Map<String, List<String>> filesToDownload,
    required Future<bool> Function(void Function(BatchDownloadProgress))
    downloadFunction,
  }) {
    final allFiles = <String>[];
    for (final files in filesToDownload.values) {
      allFiles.addAll(files);
    }

    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BiosDownloadDialog(
        title: l10n.downloadingAllMissingBios,
        filesToDownload: allFiles,
        downloadFunction: (onProgress) =>
            downloadFunction((progress) => onProgress(progress)),
      ),
    );
  }
}

class _BiosDownloadDialogState extends State<BiosDownloadDialog> {
  Object? _currentProgress;
  bool _isCompleted = false;
  bool _hasFailed = false;
  bool _isCancelled = false;
  BiosDownloadError? _enhancedError;

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  void _startDownload() async {
    try {
      final success = await widget.downloadFunction((progress) {
        if (mounted) {
          setState(() {
            _currentProgress = progress;

            if (progress is DownloadProgress) {
              if (progress.status == DownloadStatus.completed) {
                _isCompleted = true;
              } else if (progress.status == DownloadStatus.failed) {
                _hasFailed = true;
                _enhancedError = progress.errorMessage != null
                    ? BiosDownloadError.fromException(
                        Exception(progress.errorMessage),
                      )
                    : BiosDownloadError.fromException(
                        Exception(AppLocalizations.of(context)!.downloadFailed),
                      );
              } else if (progress.status == DownloadStatus.cancelled) {
                _isCancelled = true;
              }
            } else if (progress is BatchDownloadProgress) {
              if (progress.status == BatchDownloadStatus.completed) {
                _isCompleted = true;
              } else if (progress.status == BatchDownloadStatus.failed) {
                _hasFailed = true;
                _enhancedError = progress.errorMessage != null
                    ? BiosDownloadError.fromException(
                        Exception(progress.errorMessage),
                      )
                    : BiosDownloadError.fromException(
                        Exception(
                          AppLocalizations.of(context)!.batchDownloadFailed,
                        ),
                      );
              } else if (progress.status == BatchDownloadStatus.cancelled) {
                _isCancelled = true;
              }
            }
          });
        }
      });

      if (mounted && !_isCancelled && !_hasFailed) {
        setState(() {
          _isCompleted = true;
        });

        // Auto-close after a short delay on success
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop(success);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasFailed = true;
          _enhancedError = BiosDownloadError.fromException(e);
        });
      }
    }
  }

  void _cancel() {
    setState(() {
      _isCancelled = true;
    });
    Navigator.of(context).pop(false);
  }

  void _retryDownload() {
    setState(() {
      _hasFailed = false;
      _isCompleted = false;
      _isCancelled = false;
      _enhancedError = null;
      _currentProgress = null;
    });
    _startDownload();
  }

  void _close() {
    Navigator.of(context).pop(!_hasFailed && !_isCancelled);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (_isCompleted)
            const Icon(Icons.check_circle, color: Colors.green)
          else if (_hasFailed)
            const Icon(Icons.error, color: Colors.red)
          else if (_isCancelled)
            const Icon(Icons.cancel, color: Colors.orange)
          else
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          const SizedBox(width: 12),
          Expanded(child: Text(widget.title)),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentProgress != null) ...[
              if (_currentProgress is DownloadProgress)
                _buildSingleProgress(_currentProgress as DownloadProgress)
              else if (_currentProgress is BatchDownloadProgress)
                _buildBatchProgress(_currentProgress as BatchDownloadProgress),
            ] else ...[
              Text(AppLocalizations.of(context)!.preparingDownload),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],

            if (_enhancedError != null) ...[
              const SizedBox(height: 16),
              BiosErrorDisplay(
                error: _enhancedError!,
                onRetry: _retryDownload,
                showDetails: true,
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (_isCompleted || _hasFailed || _isCancelled)
          TextButton(
            onPressed: _close,
            child: Text(AppLocalizations.of(context)!.close),
          )
        else
          TextButton(
            onPressed: _cancel,
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
      ],
    );
  }

  Widget _buildSingleProgress(DownloadProgress progress) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.biosFileLabel(progress.filename),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _getStatusText(progress.status),
          style: TextStyle(
            color: _getStatusColor(progress.status),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.progress,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 4),
        Text(
          progress.detailedProgressText,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBatchProgress(BatchDownloadProgress batchProgress) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.batchProgressLabel(
            batchProgress.completedFiles.toString(),
            batchProgress.totalFiles.toString(),
          ),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: batchProgress.overallProgress,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text(
          _getBatchStatusText(batchProgress.status),
          style: TextStyle(
            color: _getBatchStatusColor(batchProgress.status),
            fontSize: 12,
          ),
        ),

        if (batchProgress.fileProgresses.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.fileDetails,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: batchProgress.fileProgresses.length,
              itemBuilder: (context, index) {
                final fileProgress = batchProgress.fileProgresses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(fileProgress.status),
                        size: 16,
                        color: _getStatusColor(fileProgress.status),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fileProgress.filename,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (fileProgress.status == DownloadStatus.downloading)
                        Text(
                          '${(fileProgress.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  String _getStatusText(DownloadStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case DownloadStatus.pending:
        return l10n.waiting;
      case DownloadStatus.downloading:
        return l10n.downloading;
      case DownloadStatus.verifying:
        return l10n.verifying;
      case DownloadStatus.completed:
        return l10n.completed;
      case DownloadStatus.failed:
        return l10n.failed;
      case DownloadStatus.cancelled:
        return l10n.cancelled;
    }
  }

  String _getBatchStatusText(BatchDownloadStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case BatchDownloadStatus.pending:
        return l10n.preparing;
      case BatchDownloadStatus.downloading:
        return l10n.downloadingFiles;
      case BatchDownloadStatus.completed:
        return l10n.allDownloadsCompleted;
      case BatchDownloadStatus.failed:
        return l10n.someDownloadsFailed;
      case BatchDownloadStatus.cancelled:
        return l10n.downloadsCancelled;
    }
  }

  Color _getStatusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.pending:
        return Colors.grey;
      case DownloadStatus.downloading:
      case DownloadStatus.verifying:
        return Colors.blue;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.cancelled:
        return Colors.orange;
    }
  }

  Color _getBatchStatusColor(BatchDownloadStatus status) {
    switch (status) {
      case BatchDownloadStatus.pending:
        return Colors.grey;
      case BatchDownloadStatus.downloading:
        return Colors.blue;
      case BatchDownloadStatus.completed:
        return Colors.green;
      case BatchDownloadStatus.failed:
        return Colors.red;
      case BatchDownloadStatus.cancelled:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.pending:
        return Icons.schedule;
      case DownloadStatus.downloading:
      case DownloadStatus.verifying:
        return Icons.download;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.cancelled:
        return Icons.cancel;
    }
  }
}
