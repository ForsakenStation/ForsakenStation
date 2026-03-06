import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/bios_download_mapping.dart';
import '../../models/bios_requirement.dart';
import '../../services/bios_checksum_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/controls_bottom_bar.dart';

/// Comprehensive BIOS Status Dashboard
///
/// Provides an overview of all platform BIOS status including:
/// - Platform coverage summary
/// - Missing/present file counts
/// - Verification status
/// - Quick access to download missing files
class BiosStatusDashboard extends StatefulWidget {
  final String biosPath;

  const BiosStatusDashboard({super.key, required this.biosPath});

  @override
  State<BiosStatusDashboard> createState() => _BiosStatusDashboardState();
}

class _BiosStatusDashboardState extends State<BiosStatusDashboard> {
  List<PlatformBiosStatus> _platformStatuses = [];
  BiosSummaryStats? _summaryStats;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBiosStatus();
  }

  Future<void> _loadBiosStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final platformStatuses = <PlatformBiosStatus>[];
      int totalFiles = 0;
      int presentFiles = 0;
      int verifiedFiles = 0;
      int downloadableFiles = 0;

      // Check each platform
      final requirements = await BiosRequirement.getDefaultRequirements();
      for (final requirement in requirements) {
        final mapping = await BiosDownloadMapping.getMapping(
          requirement.platform,
        );
        final platformPath = Directory(
          '${widget.biosPath}/${requirement.platform}',
        );

        final fileStatuses = <BiosFileStatus>[];

        for (final biosFile in requirement.files) {
          final file = File('${platformPath.path}/${biosFile.filename}');
          final exists = await file.exists();

          totalFiles++;
          if (exists) presentFiles++;

          // Check if downloadable
          final downloadable = mapping?.hasFile(biosFile.filename) ?? false;
          if (downloadable) downloadableFiles++;

          // Verify checksum if file exists
          bool? verified;
          if (exists) {
            try {
              final downloadableFile = mapping?.getFile(biosFile.filename);
              if (downloadableFile?.expectedMd5 != null ||
                  downloadableFile?.expectedSha1 != null) {
                final verificationResult = await BiosChecksumService.instance
                    .verifyFile(
                      file: file,
                      expectedMd5: downloadableFile?.expectedMd5,
                      expectedSha1: downloadableFile?.expectedSha1,
                      expectedCrc32: downloadableFile?.expectedCrc32,
                      expectedSize: downloadableFile?.expectedSize,
                    );
                verified = verificationResult.success;
                if (verified) verifiedFiles++;
              }
            } catch (e) {
              verified = false;
            }
          }

          fileStatuses.add(
            BiosFileStatus(
              filename: biosFile.filename,
              description: biosFile.description,
              exists: exists,
              downloadable: downloadable,
              verified: verified,
            ),
          );
        }

        final presentCount = fileStatuses.where((f) => f.exists).length;
        final verifiedCount = fileStatuses
            .where((f) => f.verified == true)
            .length;
        final downloadableCount = fileStatuses
            .where((f) => f.downloadable)
            .length;

        platformStatuses.add(
          PlatformBiosStatus(
            platform: requirement.platform,
            displayName: requirement.displayName,
            totalFiles: requirement.files.length,
            presentFiles: presentCount,
            verifiedFiles: verifiedCount,
            downloadableFiles: downloadableCount,
            fileStatuses: fileStatuses,
            available: mapping?.available ?? false,
          ),
        );
      }

      _summaryStats = BiosSummaryStats(
        totalPlatforms: platformStatuses.length,
        completePlatforms: platformStatuses.where((p) => p.isComplete).length,
        totalFiles: totalFiles,
        presentFiles: presentFiles,
        verifiedFiles: verifiedFiles,
        downloadableFiles: downloadableFiles,
      );

      setState(() {
        _platformStatuses = platformStatuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.biosStatusDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBiosStatus,
            tooltip: AppLocalizations.of(context)!.refreshStatus,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.failedToLoadBiosStatus(_errorMessage!),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : _buildDashboardContent(),
          ),
          ControlsBottomBar(
            actions: [
              BottomBarAction(
                label: AppLocalizations.of(context)!.back,
                keyboardKey: 'ESC',
                gamepadButton: 'B',
              ),
              BottomBarAction(
                label: AppLocalizations.of(context)!.refresh,
                keyboardKey: 'F5',
                gamepadButton: 'Start',
              ),
            ],
            counterText: _summaryStats != null
                ? AppLocalizations.of(context)!.platformsCompleteCount(
                    _summaryStats!.completePlatforms,
                    _summaryStats!.totalPlatforms,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Stats Card
        if (_summaryStats != null) _buildSummaryCard(),
        const SizedBox(height: 16),

        // Platform Status Grid
        Text(
          AppLocalizations.of(context)!.platformStatusHeader,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        ...List.generate(_platformStatuses.length, (index) {
          final platformStatus = _platformStatuses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: Icon(
                platformStatus.isComplete
                    ? Icons.check_circle
                    : platformStatus.hasAnyFiles
                    ? Icons.warning
                    : Icons.error,
                color: platformStatus.isComplete
                    ? Colors.green
                    : platformStatus.hasAnyFiles
                    ? Colors.orange
                    : Colors.red,
              ),
              title: Text(platformStatus.displayName),
              subtitle: Text(
                AppLocalizations.of(context)!.filesVerifiedStatus(
                  platformStatus.presentFiles,
                  platformStatus.totalFiles,
                  platformStatus.verifiedFiles,
                ),
              ),
              trailing: platformStatus.available
                  ? const Icon(Icons.cloud_download, color: Colors.blue)
                  : const Icon(Icons.cloud_off, color: Colors.grey),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File status list
                      ...platformStatus.fileStatuses.map((fileStatus) {
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            fileStatus.exists
                                ? (fileStatus.verified == true
                                      ? Icons.verified
                                      : fileStatus.verified == false
                                      ? Icons.warning
                                      : Icons.check_circle_outline)
                                : Icons.radio_button_unchecked,
                            color: fileStatus.exists
                                ? (fileStatus.verified == true
                                      ? Colors.green
                                      : fileStatus.verified == false
                                      ? Colors.orange
                                      : Colors.blue)
                                : Colors.grey,
                            size: 20,
                          ),
                          title: Text(
                            fileStatus.filename,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          subtitle: fileStatus.description != null
                              ? Text(fileStatus.description!)
                              : null,
                          trailing: fileStatus.downloadable
                              ? const Icon(Icons.download, size: 16)
                              : null,
                        );
                      }),

                      // Quick actions
                      if (!platformStatus.isComplete &&
                          platformStatus.available)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _downloadMissingFiles(platformStatus),
                            icon: const Icon(Icons.download),
                            label: Text(
                              AppLocalizations.of(
                                context,
                              )!.downloadMissingFiles,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final stats = _summaryStats!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.biosCollectionOverview,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.platforms,
                    '${stats.completePlatforms}/${stats.totalPlatforms}',
                    stats.completePlatforms / stats.totalPlatforms,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.biosFiles,
                    '${stats.presentFiles}/${stats.totalFiles}',
                    stats.presentFiles / stats.totalFiles,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.biosVerified,
                    '${stats.verifiedFiles}/${stats.presentFiles}',
                    stats.presentFiles > 0
                        ? stats.verifiedFiles / stats.presentFiles
                        : 0,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.biosDownloadable,
                    '${stats.downloadableFiles}/${stats.totalFiles}',
                    stats.downloadableFiles / stats.totalFiles,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  void _downloadMissingFiles(PlatformBiosStatus platformStatus) {
    // TODO: Implement download missing files functionality
    // This would integrate with the existing BIOS download dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.downloadComingSoon(platformStatus.displayName),
        ),
      ),
    );
  }
}

// Data classes for BIOS status

class PlatformBiosStatus {
  final String platform;
  final String displayName;
  final int totalFiles;
  final int presentFiles;
  final int verifiedFiles;
  final int downloadableFiles;
  final List<BiosFileStatus> fileStatuses;
  final bool available;

  const PlatformBiosStatus({
    required this.platform,
    required this.displayName,
    required this.totalFiles,
    required this.presentFiles,
    required this.verifiedFiles,
    required this.downloadableFiles,
    required this.fileStatuses,
    required this.available,
  });

  bool get isComplete => presentFiles == totalFiles;
  bool get hasAnyFiles => presentFiles > 0;
}

class BiosFileStatus {
  final String filename;
  final String? description;
  final bool exists;
  final bool downloadable;
  final bool?
  verified; // null if not checked, true if verified, false if failed

  const BiosFileStatus({
    required this.filename,
    this.description,
    required this.exists,
    required this.downloadable,
    this.verified,
  });
}

class BiosSummaryStats {
  final int totalPlatforms;
  final int completePlatforms;
  final int totalFiles;
  final int presentFiles;
  final int verifiedFiles;
  final int downloadableFiles;

  const BiosSummaryStats({
    required this.totalPlatforms,
    required this.completePlatforms,
    required this.totalFiles,
    required this.presentFiles,
    required this.verifiedFiles,
    required this.downloadableFiles,
  });
}
