import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/debug_service.dart';
import 'package:flutter/services.dart';
import '../../models/bios_requirement.dart';
import '../../models/bios_requirement_download.dart';
import '../../services/bios_check_service.dart';
import '../../services/bios_download_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/bios/bios_download_dialog.dart';
import '../../l10n/generated/app_localizations.dart';

class BiosHelpScreen extends StatefulWidget {
  const BiosHelpScreen({super.key});

  @override
  State<BiosHelpScreen> createState() => _BiosHelpScreenState();
}

class _BiosHelpScreenState extends State<BiosHelpScreen> {
  final KeyboardService _keyboardService = KeyboardService.instance;
  final ScrollController _scrollController = ScrollController();
  final BiosDownloadService _downloadService = BiosDownloadService.instance;

  bool _isLoading = true;
  bool _showOnlyMissing = false;
  List<BiosRequirement> _allRequirements = [];
  List<BiosRequirement> _filteredRequirements = [];

  // Download state tracking
  final Map<String, bool> _downloadingPlatforms = {};
  String? _currentDownloadToken;

  @override
  void initState() {
    super.initState();
    _loadBiosData();
  }

  @override
  void dispose() {
    // Note: We don't dispose the singleton service here anymore
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBiosData() async {
    setState(() => _isLoading = true);
    try {
      final requirements = await BiosCheckService.instance.scanAllBios();
      if (!mounted) return;
      setState(() {
        _allRequirements = requirements;
        _updateFilteredList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      DebugService.instance.error(
        'Error loading BIOS data: $e',
        tag: 'BiosHelp',
      );
      setState(() => _isLoading = false);
    }
  }

  void _updateFilteredList() {
    setState(() {
      if (_showOnlyMissing) {
        _filteredRequirements = BiosCheckService.instance.filterMissing(
          _allRequirements,
        );
      } else {
        _filteredRequirements = _allRequirements;
      }

      // Sort alphabetically by display name
      _filteredRequirements.sort(
        (a, b) => a.displayName.compareTo(b.displayName),
      );
    });
  }

  void _toggleFilter() {
    setState(() {
      _showOnlyMissing = !_showOnlyMissing;
      _updateFilteredList();
    });
  }

  /// Downloads BIOS files for a specific platform
  Future<void> _downloadPlatformBios(BiosRequirement requirement) async {
    if (!requirement.canDownload) return;

    // Include both required and optional missing files
    final missingFiles = requirement.downloadableMissingAllFiles;
    if (missingFiles.isEmpty) return;

    // Mark platform as downloading
    setState(() {
      _downloadingPlatforms[requirement.platform] = true;
    });

    try {
      final success = await BiosDownloadDialog.showSinglePlatform(
        context: context,
        platformName: requirement.displayName,
        filesToDownload: missingFiles,
        downloadFunction: (onProgress) => _downloadService.downloadPlatformBios(
          platformId: requirement.platform,
          missingFiles: missingFiles,
          destinationPath: _expandPath(requirement.primaryLocation),
          onProgress: onProgress,
          cancellationToken: _currentDownloadToken,
        ),
      );

      if (success == true) {
        // Refresh BIOS data to update UI
        await _loadBiosData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.downloadFailed}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Remove downloading state
      setState(() {
        _downloadingPlatforms.remove(requirement.platform);
      });
    }
  }

  /// Downloads all missing BIOS files
  Future<void> _downloadAllMissingBios() async {
    final missingByPlatform = <String, List<String>>{};
    final destinationPaths = <String, String>{};

    for (final requirement in _allRequirements) {
      if (requirement.canDownload && requirement.hasDownloadableMissingAny) {
        final missingFiles = requirement.downloadableMissingAllFiles;
        if (missingFiles.isNotEmpty) {
          missingByPlatform[requirement.platform] = missingFiles;
          destinationPaths[requirement.platform] = _expandPath(
            requirement.primaryLocation,
          );
        }
      }
    }

    if (missingByPlatform.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noDownloadableBios),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final shouldProceed = await _showBatchDownloadConfirmation(
      missingByPlatform,
    );
    if (!shouldProceed) return;

    if (!mounted) return;

    _currentDownloadToken = _downloadService.createCancellationToken();

    try {
      final success = await BiosDownloadDialog.showBatchDownload(
        context: context,
        filesToDownload: missingByPlatform,
        downloadFunction: (onProgress) =>
            _downloadService.downloadAllMissingBios(
              missingByPlatform: missingByPlatform,
              destinationPaths: destinationPaths,
              onProgress: onProgress,
              cancellationToken: _currentDownloadToken,
            ),
      );

      if (success == true) {
        // Refresh BIOS data to update UI
        await _loadBiosData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.allDownloadsCompleted,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.batchDownloadFailed}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Shows confirmation dialog for batch download
  Future<bool> _showBatchDownloadConfirmation(
    Map<String, List<String>> missingByPlatform,
  ) async {
    final totalFiles = missingByPlatform.values.fold<int>(
      0,
      (sum, files) => sum + files.length,
    );

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.downloadAllMissingBios),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.batchDownloadConfirmation(
                      totalFiles,
                      missingByPlatform.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final entry in missingByPlatform.entries) ...[
                    Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...entry.value.map(
                      (file) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '• $file',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.downloadSourceNote,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.download),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Expands ~ to home directory in path
  String _expandPath(String filePath) {
    if (filePath.startsWith('~/')) {
      final home = Platform.environment['HOME'] ?? '/home/user';
      return filePath.replaceFirst('~', home);
    }
    return filePath;
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    if (_keyboardService.isSelectKey(key)) {
      // Toggle filter on select
      _toggleFilter();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.f5 ||
        key == LogicalKeyboardKey.browserRefresh) {
      _loadBiosData();
      return KeyEventResult.handled;
    }

    // Download shortcut (D key)
    if (key == LogicalKeyboardKey.keyD) {
      final missingCount = _allRequirements
          .where((req) => req.canDownload && req.hasDownloadableMissing)
          .length;

      if (missingCount > 0) {
        _downloadAllMissingBios();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _buildStatusIcon(BiosRequirement requirement) {
    if (requirement.hasAllFiles) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    } else if (requirement.hasSomeFiles) {
      return const Icon(Icons.warning, color: Colors.orange, size: 20);
    } else {
      return const Icon(Icons.cancel, color: Colors.red, size: 20);
    }
  }

  Color _getStatusColor(BiosRequirement requirement) {
    if (requirement.hasAllFiles) {
      return Colors.green.withValues(alpha: 0.1);
    } else if (requirement.hasSomeFiles) {
      return Colors.orange.withValues(alpha: 0.1);
    } else {
      return Colors.red.withValues(alpha: 0.1);
    }
  }

  Widget _buildBiosFileItem(BiosFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Icon(
            file.found ? Icons.check_circle : Icons.cancel,
            color: file.found ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.filename,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: file.found ? Colors.green : Colors.red,
                  ),
                ),
                if (file.description != null || file.region != null)
                  Text(
                    [
                      if (file.region != null) file.region,
                      if (file.description != null) file.description,
                    ].join(' - '),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds download button text based on requirement status
  String _buildDownloadButtonText(
    BiosRequirement requirement,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (_downloadingPlatforms[requirement.platform] == true) {
      return l10n.biosDownloading;
    }

    final requiredCount = requirement.downloadableMissingCount;
    final optionalCount = requirement.downloadableMissingOptionalCount;

    if (requiredCount > 0 && optionalCount > 0) {
      return l10n.downloadRequiredAndExtras(requiredCount, optionalCount);
    } else if (requiredCount > 0) {
      return l10n.downloadRequiredFiles(requiredCount);
    } else if (optionalCount > 0) {
      return l10n.downloadOptionalExtras(optionalCount);
    } else {
      return l10n.downloadFiles;
    }
  }

  Widget _buildPlatformCard(BiosRequirement requirement) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: _getStatusColor(requirement),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildStatusIcon(requirement),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  requirement.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (requirement.required)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.biosRequired,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.biosOptional,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.biosFilesFound(
                    requirement.foundCount,
                    requirement.totalCount,
                  ),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                // Show optional files info if available
                if (requirement.hasDownloadableMissingOptional) ...[
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.optionalExtrasAvailable(
                      requirement.downloadableMissingOptionalCount,
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                  ),
                ],
              ],
            ),
          ),
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Files list
                  ...requirement.files.map((file) => _buildBiosFileItem(file)),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Locations
                  Text(
                    AppLocalizations.of(context)!.biosLocations,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...requirement.locations.map(
                    (location) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Notes
                  if (requirement.notes != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              requirement.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Download button
                  if (requirement.canDownload &&
                      requirement.hasDownloadableMissingAny) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 16,
                          color: Colors.purple[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.availableForDownload,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _downloadingPlatforms[requirement.platform] == true
                            ? null
                            : () => _downloadPlatformBios(requirement),
                        icon:
                            _downloadingPlatforms[requirement.platform] == true
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download, size: 16),
                        label: Text(
                          _buildDownloadButtonText(requirement, context),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final stats = BiosCheckService.instance.getStatistics(_allRequirements);
    final downloadableCount = _allRequirements
        .where((req) => req.canDownload && req.hasDownloadableMissing)
        .length;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.summary,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (downloadableCount > 0)
                ElevatedButton.icon(
                  onPressed: _downloadAllMissingBios,
                  icon: const Icon(Icons.download, size: 16),
                  label: Text(
                    AppLocalizations.of(context)!.downloadAllMissingBios,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat(
                AppLocalizations.of(context)!.biosComplete,
                '${stats['platformsComplete']}',
                Colors.green,
              ),
              _buildSummaryStat(
                AppLocalizations.of(context)!.biosPartial,
                '${stats['platformsPartial']}',
                Colors.orange,
              ),
              _buildSummaryStat(
                AppLocalizations.of(context)!.biosMissing,
                '${stats['platformsMissing']}',
                Colors.red,
              ),
              _buildSummaryStat(
                AppLocalizations.of(context)!.biosFiles,
                '${stats['foundFiles']}/${stats['totalFiles']}',
                Colors.blue,
              ),
              if (downloadableCount > 0)
                _buildSummaryStat(
                  AppLocalizations.of(context)!.biosDownloadable,
                  '$downloadableCount',
                  Colors.purple,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.biosFirmwareHelp),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadBiosData,
              tooltip: AppLocalizations.of(context)!.refreshF5Tooltip,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Summary
                  _buildSummary(),

                  // Filter toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SwitchListTile(
                      title: Text(
                        AppLocalizations.of(context)!.showOnlyMissing,
                      ),
                      value: _showOnlyMissing,
                      onChanged: (value) => _toggleFilter(),
                    ),
                  ),

                  // Platform list
                  Expanded(
                    child: _filteredRequirements.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _showOnlyMissing
                                      ? AppLocalizations.of(
                                          context,
                                        )!.allBiosFilesFound
                                      : AppLocalizations.of(
                                          context,
                                        )!.noBiosRequirements,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _filteredRequirements.length,
                            itemBuilder: (context, index) {
                              return _buildPlatformCard(
                                _filteredRequirements[index],
                              );
                            },
                          ),
                  ),

                  // Bottom controls bar
                  ControlsBottomBar(
                    actions: [
                      BottomBarAction(
                        label: AppLocalizations.of(context)!.back,
                        keyboardKey: 'ESC',
                        gamepadButton: 'B',
                      ),
                      BottomBarAction(
                        label: AppLocalizations.of(context)!.toggleFilter,
                        keyboardKey: 'Enter',
                        gamepadButton: 'A',
                      ),
                      BottomBarAction(
                        label: AppLocalizations.of(context)!.refresh,
                        keyboardKey: 'F5',
                        gamepadButton: 'Start',
                      ),
                      if (_allRequirements.any(
                        (req) => req.canDownload && req.hasDownloadableMissing,
                      ))
                        BottomBarAction(
                          label: AppLocalizations.of(context)!.downloadAll,
                          keyboardKey: 'D',
                          gamepadButton: 'Y',
                        ),
                    ],
                    counterText: _filteredRequirements.isEmpty
                        ? null
                        : AppLocalizations.of(
                            context,
                          )!.platformCount(_filteredRequirements.length),
                  ),
                ],
              ),
      ),
    );
  }
}
