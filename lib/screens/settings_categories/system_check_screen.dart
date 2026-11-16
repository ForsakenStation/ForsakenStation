import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/system_check_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for checking system requirements
///
/// Displays:
/// - Required tools status
/// - Optional tools status
/// - Installation instructions for missing tools
class SystemCheckScreen extends StatefulWidget {
  const SystemCheckScreen({super.key});

  @override
  State<SystemCheckScreen> createState() => _SystemCheckScreenState();
}

class _SystemCheckScreenState extends State<SystemCheckScreen> {
  final _systemCheckService = SystemCheckService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  SystemCheckResult? _result;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _performCheck();
  }

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

    // Handle refresh (R key)
    if (key == LogicalKeyboardKey.keyR && !_isChecking) {
      _performCheck();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _performCheck() async {
    setState(() => _isChecking = true);

    try {
      final result = await _systemCheckService.performSystemCheck();
      setState(() {
        _result = result;
        _isChecking = false;
      });
    } catch (e) {
      setState(() => _isChecking = false);
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorCheckingSystem}: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.systemRequirements),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isChecking ? null : _performCheck,
              tooltip: AppLocalizations.of(context)!.recheckR,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isChecking
                  ? const Center(child: CircularProgressIndicator())
                  : _result == null
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.failedToCheckSystem,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 880),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Overall Status Card
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            (_result!.allRequiredMet
                                                    ? const Color(0xFF30D158)
                                                    : const Color(0xFFFF9F0A))
                                                .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _result!.allRequiredMet
                                            ? Icons.check_circle_rounded
                                            : Icons.warning_rounded,
                                        size: 30,
                                        color: _result!.allRequiredMet
                                            ? const Color(0xFF30D158)
                                            : const Color(0xFFFF9F0A),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _result!.allRequiredMet
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.allRequiredToolsInstalled
                                                : AppLocalizations.of(
                                                    context,
                                                  )!.missingRequiredTools,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _result!.allRequiredMet
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.systemReadyToUse
                                                : AppLocalizations.of(
                                                    context,
                                                  )!.someRequiredToolsMissing,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.65),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Required Tools Section
                              Text(
                                AppLocalizations.of(context)!.requiredTools,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.requiredToolsDescription,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.65),
                                    ),
                              ),
                              const SizedBox(height: 14),

                              ..._buildToolList(
                                _systemCheckService.getRequiredTools(),
                                _result!.missingRequired,
                                isRequired: true,
                              ),

                              if (_result!.missingRequired.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline_rounded,
                                            size: 20,
                                            color: Color(0xFFFF9F0A),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.installationInstructions,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _systemCheckService
                                            .getInstallInstructions(
                                              _result!.missingRequired,
                                            ),
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  keyboardKey: 'R',
                  gamepadButton: 'Start',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildToolList(
    List<String> allTools,
    List<String> missingTools, {
    required bool isRequired,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return allTools.map((tool) {
      final isInstalled = !missingTools.contains(tool);
      final statusColor =
          isInstalled ? const Color(0xFF30D158) : const Color(0xFFFF453A);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              isInstalled ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: statusColor,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _systemCheckService.getToolDescription(tool),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isInstalled
                    ? AppLocalizations.of(context)!.installed
                    : AppLocalizations.of(context)!.missing,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
