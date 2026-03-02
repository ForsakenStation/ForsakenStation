import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:forsaken/services/emulator_download_service.dart';
import 'package:forsaken/services/romlist_download_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/models/emulator_download_info.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:forsaken/widgets/common/dialog_button_bar.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';
import 'package:forsaken/l10n/generated/app_localizations.dart';

/// Screen for managing downloads
///
/// Allows users to:
/// - Download emulators
/// - Download game lists
/// - View download progress
/// - Manage download queue
class DownloadManagerScreen extends StatefulWidget {
  const DownloadManagerScreen({super.key});

  @override
  State<DownloadManagerScreen> createState() => _DownloadManagerScreenState();
}

class _DownloadManagerScreenState extends State<DownloadManagerScreen> {
  final _downloadService = EmulatorDownloadService.instance;
  final _romListService = RomListDownloadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  final Map<String, DownloadTask> _tasks = {};
  bool _isDownloading = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    // Handle clear completed (C key)
    if (key == LogicalKeyboardKey.keyC && _tasks.isNotEmpty) {
      _clearCompleted();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.downloadManager),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.downloadEmulatorsAndGameLists,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.quickActions,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _ActionButton(
                                  icon: Icons.download,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.downloadAll,
                                  onPressed: _isDownloading
                                      ? null
                                      : () => _downloadCategory('all'),
                                ),
                                _ActionButton(
                                  icon: Icons.category,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.byCategory,
                                  onPressed: _isDownloading
                                      ? null
                                      : _showCategoryDialog,
                                ),
                                _ActionButton(
                                  icon: Icons.list,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.downloadGameLists,
                                  onPressed: _isDownloading
                                      ? null
                                      : _downloadGameLists,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Download Queue Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.downloadQueue,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_tasks.isNotEmpty) ...[
                          TextButton(
                            onPressed: _clearCompleted,
                            child: Text(
                              AppLocalizations.of(context)!.clearCompleted,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Task List
                    Expanded(
                      child: _tasks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.download_done,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noDownloadsInProgress,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.selectQuickActionToStart,
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                final taskKey = _tasks.keys.elementAt(index);
                                final task = _tasks[taskKey]!;
                                return _DownloadTaskCard(
                                  task: task,
                                  onCancel:
                                      task.status == DownloadStatus.downloading
                                      ? () => _cancelDownload(taskKey)
                                      : null,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            ControlsBottomBar(
              actions: const [
                BottomBarAction(
                  label: 'Back',
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: 'Clear',
                  keyboardKey: 'C',
                  gamepadButton: 'Y',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCategory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CategoryTile(
              icon: Icons.videogame_asset,
              title: AppLocalizations.of(context)!.categorySony,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('sony');
              },
            ),
            _CategoryTile(
              icon: Icons.sports_esports,
              title: AppLocalizations.of(context)!.categoryNintendo,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('nintendo');
              },
            ),
            _CategoryTile(
              icon: Icons.gamepad,
              title: AppLocalizations.of(context)!.categoryMicrosoft,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('microsoft');
              },
            ),
            _CategoryTile(
              icon: Icons.apps,
              title: AppLocalizations.of(context)!.categoryMultiPlatform,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('multi');
              },
            ),
            _CategoryTile(
              icon: Icons.more_horiz,
              title: AppLocalizations.of(context)!.categoryOtherEmulators,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('other');
              },
            ),
            _CategoryTile(
              icon: Icons.build,
              title: AppLocalizations.of(context)!.categoryUtilities,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('utilities');
              },
            ),
          ],
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context),
                primary: true,
                gamepadButton: GamepadButton.b,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _downloadCategory(String category) async {
    setState(() => _isDownloading = true);

    try {
      // Get emulators for category
      final List<EmulatorDownloadInfo> emulators;
      if (category == 'all') {
        emulators = await EmulatorCatalog.getAvailableForCurrentPlatform();
      } else {
        final allInCategory = await EmulatorCatalog.getByCategory(category);
        emulators = allInCategory
            .where((e) => e.isAvailableForCurrentPlatform())
            .toList();
      }

      if (emulators.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noEmulatorsAvailable),
          ),
        );
        return;
      }

      // Calculate total size
      final totalSizeMB = _downloadService.getTotalDownloadSize(emulators);

      // Ask for confirmation
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDownload),
          content: Text(
            AppLocalizations.of(context)!.confirmDownloadDescription(
              '${emulators.length}',
              '$totalSizeMB',
            ),
          ),
          actions: [
            DialogButtonBar(
              buttons: [
                DialogButton(
                  label: AppLocalizations.of(context)!.cancel,
                  onPressed: () => Navigator.pop(context, false),
                  gamepadButton: GamepadButton.b,
                ),
                DialogButton(
                  label: AppLocalizations.of(context)!.download,
                  onPressed: () => Navigator.pop(context, true),
                  primary: true,
                  gamepadButton: GamepadButton.a,
                ),
              ],
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Add tasks
      for (final emulator in emulators) {
        // Check if already installed
        final isInstalled = await _downloadService.isEmulatorInstalled(
          emulator,
        );
        if (isInstalled) {
          setState(() {
            _tasks[emulator.name] = DownloadTask(
              name: emulator.displayName,
              type: DownloadType.emulator,
              status: DownloadStatus.completed,
              progress: 1.0,
              statusMessage: AppLocalizations.of(context)!.alreadyInstalled,
            );
          });
          continue;
        }

        setState(() {
          _tasks[emulator.name] = DownloadTask(
            name: emulator.displayName,
            type: DownloadType.emulator,
            status: DownloadStatus.pending,
          );
        });
      }

      // Download each emulator
      for (final emulator in emulators) {
        final task = _tasks[emulator.name];
        if (task == null || task.status == DownloadStatus.completed) continue;

        setState(() {
          task.status = DownloadStatus.downloading;
          task.statusMessage = AppLocalizations.of(context)!.starting;
        });

        await _downloadService.downloadEmulator(
          emulator,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                task.progress = progress;
              });
            }
          },
          onStatus: (status) {
            if (mounted) {
              setState(() {
                task.statusMessage = status;
              });
            }
          },
        );

        setState(() {
          task.status = DownloadStatus.completed;
          task.progress = 1.0;
          task.statusMessage = AppLocalizations.of(context)!.completed;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.allDownloads)),
        );
      }
      _downloadService.makeAppImagesExecutable(
        Directory(ConfigService.instance.emulatorsPath).path,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
        );
      }
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _downloadGameLists() async {
    setState(() => _isDownloading = true);

    try {
      // Check if already downloaded
      final isDownloaded = await _romListService.isGameListsDownloaded();
      if (!mounted) return;

      // Ask user what they want to do
      final action = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.downloadGameLists),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.downloadGameListsDescription),
              const SizedBox(height: 16),
              if (isDownloaded) ...[
                Text(
                  AppLocalizations.of(context)!.gameListsAlreadyDownloaded,
                  style: const TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
          actions: [
            DialogButtonBar(
              buttons: [
                DialogButton(
                  label: AppLocalizations.of(context)!.cancel,
                  onPressed: () => Navigator.pop(context),
                  gamepadButton: GamepadButton.b,
                ),
                DialogButton(
                  label: isDownloaded
                      ? AppLocalizations.of(context)!.redownload
                      : AppLocalizations.of(context)!.download,
                  onPressed: () => Navigator.pop(context, 'download'),
                  primary: true,
                  gamepadButton: GamepadButton.a,
                ),
              ],
            ),
          ],
        ),
      );

      if (action == null) return;

      // Download game lists
      if (action == 'download' || action == 'redownload') {
        setState(() {
          _tasks['gamelists'] = DownloadTask(
            name: AppLocalizations.of(context)!.gameListsFromGitHub,
            type: DownloadType.gamelist,
            status: DownloadStatus.downloading,
            statusMessage: AppLocalizations.of(context)!.downloading,
          );
        });

        await _romListService.downloadGameLists(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _tasks['gamelists']!.progress = progress;
              });
            }
          },
          onStatus: (status) {
            if (mounted) {
              setState(() {
                _tasks['gamelists']!.statusMessage = status;
              });
            }
          },
        );

        setState(() {
          _tasks['gamelists']!.status = DownloadStatus.completed;
          _tasks['gamelists']!.progress = 1.0;
          _tasks['gamelists']!.statusMessage = AppLocalizations.of(
            context,
          )!.downloaded;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.gameListsDownloaded),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
        );
      }

      // Mark all pending tasks as failed
      setState(() {
        for (final task in _tasks.values) {
          if (task.status == DownloadStatus.downloading) {
            task.status = DownloadStatus.failed;
            task.statusMessage = '${AppLocalizations.of(context)!.error}: $e';
          }
        }
      });
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  void _cancelDownload(String taskKey) {
    setState(() {
      final task = _tasks[taskKey];
      if (task != null) {
        task.status = DownloadStatus.failed;
        task.statusMessage = AppLocalizations.of(context)!.cancelled;
      }
    });
  }

  void _clearCompleted() {
    setState(() {
      _tasks.removeWhere(
        (key, task) =>
            task.status == DownloadStatus.completed ||
            task.status == DownloadStatus.failed,
      );
    });
  }
}

/// Widget for category selection
class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

/// Widget for action buttons
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

/// Widget for displaying a download task
class _DownloadTaskCard extends StatelessWidget {
  final DownloadTask task;
  final VoidCallback? onCancel;

  const _DownloadTaskCard({required this.task, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForType(task.type),
                  color: _getColorForStatus(task.status),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (task.statusMessage != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.statusMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (task.status == DownloadStatus.downloading &&
                    onCancel != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onCancel,
                    tooltip: AppLocalizations.of(context)!.cancel,
                  ),
                if (task.status == DownloadStatus.downloading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (task.status == DownloadStatus.completed)
                  const Icon(Icons.check_circle, color: Colors.green),
                if (task.status == DownloadStatus.failed)
                  const Icon(Icons.error, color: Colors.red),
              ],
            ),
            if (task.status == DownloadStatus.downloading) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: task.progress > 0 ? task.progress : null,
                backgroundColor: Colors.grey.shade200,
              ),
              if (task.progress > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${(task.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(DownloadType type) {
    switch (type) {
      case DownloadType.emulator:
        return Icons.videogame_asset;
      case DownloadType.gamelist:
        return Icons.list;
      case DownloadType.media:
        return Icons.image;
    }
  }

  Color _getColorForStatus(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.pending:
        return Colors.grey;
      case DownloadStatus.downloading:
        return Colors.blue;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
    }
  }
}

/// Download task model
class DownloadTask {
  final String name;
  final DownloadType type;
  DownloadStatus status;
  double progress;
  String? statusMessage;
  String? error;

  DownloadTask({
    required this.name,
    required this.type,
    this.status = DownloadStatus.pending,
    this.progress = 0.0,
    this.statusMessage,
    this.error,
  });
}

/// Types of downloads
enum DownloadType { emulator, gamelist, media }

/// Download status
enum DownloadStatus { pending, downloading, completed, failed }
