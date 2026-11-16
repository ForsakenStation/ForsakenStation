import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import '../constants/legal.dart';
import '../services/config_service.dart';
import '../services/debug_service.dart';
import '../services/keyboard_service.dart';
import '../services/gamepad_service.dart';
import '../services/emulator_download_service.dart';
import '../services/romlist_download_service.dart';
import '../services/gamelist_download_service.dart';
import '../models/emulator_download_info.dart';
import '../widgets/common/animated_lucide_icon.dart';
import '../widgets/common/controls_bottom_bar.dart';
import '../mixins/gamepad_polling_mixin.dart';
import '../mixins/screen_navigation_mixin.dart';
import '../l10n/generated/app_localizations.dart';

/// First-run setup wizard that guides users through initial configuration.
///
/// Steps:
///   1. Welcome + Legal Disclaimer (must accept to proceed)
///   2. Platform Selection / Emulator Paths (desktop only, skipped on web)
///   3. Storage Paths (desktop only, skipped on web)
///   4. Download Emulators (desktop only, optional)
///   5. Download ROM Lists (desktop only, optional)
///   6. Download Gamelists (desktop only, optional)
///   7. Ready / Summary
class SetupWizardScreen extends StatefulWidget {
  /// Callback invoked when the wizard completes.
  /// The parent should navigate to the home screen.
  final VoidCallback onComplete;

  const SetupWizardScreen({super.key, required this.onComplete});

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen>
    with
        GamepadPollingMixin<SetupWizardScreen>,
        ScreenNavigationMixin<SetupWizardScreen> {
  final _focusNode = FocusNode();
  final _keyboardService = KeyboardService.instance;
  final _configService = ConfigService.instance;
  final _pageController = PageController();

  // Step tracking
  int _currentStep = 0;
  late int _totalSteps;
  late List<_WizardStep> _steps;
  bool _stepsInitialized = false;

  // Validation
  String? _validationError;

  // Step 1: Legal disclaimer acceptance
  bool _disclaimerAccepted = false;

  // Step 2: Emulator paths (desktop only)
  late final TextEditingController _emulatorsPathController;
  late final TextEditingController _emulatorsConfigPathController;

  // Step 3: Storage paths (desktop only)
  late final TextEditingController _mediaPathController;
  late final TextEditingController _romTempPathController;
  late final TextEditingController _romForeverPathController;

  // Step 4: Download Emulators (desktop only)
  _WizardDownloadState _emuDownloadState = _WizardDownloadState.idle;
  double _emuDownloadProgress = 0.0;
  String? _emuDownloadStatus;
  int _emuDownloadTotal = 0;
  int _emuDownloadCompleted = 0;

  // Step 5: Download ROM Lists (desktop only)
  _WizardDownloadState _romlistDownloadState = _WizardDownloadState.idle;
  double _romlistDownloadProgress = 0.0;

  // Step 6: Download Gamelists (desktop only)
  _WizardDownloadState _gamelistDownloadState = _WizardDownloadState.idle;
  double _gamelistDownloadProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _disclaimerAccepted = _configService.isDisclaimerAccepted;

    // Initialize controllers with current values
    _emulatorsPathController = TextEditingController(
      text: _configService.emulatorsPath,
    );
    _emulatorsConfigPathController = TextEditingController(
      text: _configService.emulatorsConfigPath,
    );
    _mediaPathController = TextEditingController(
      text: _configService.mediaPath,
    );
    _romTempPathController = TextEditingController(
      text: _configService.romTempPath,
    );
    _romForeverPathController = TextEditingController(
      text: _configService.romForeverPath,
    );

    startGamepadPolling(_handleGamepadInput);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stepsInitialized) {
      _stepsInitialized = true;
      // Build step list based on platform
      _steps = [
        _WizardStep(
          title: AppLocalizations.of(context)!.welcome,
          icon: AnimatedLucideIconType.wandSparkles,
          builder: _buildWelcomeStep,
        ),
        if (!kIsWeb) ...[
          _WizardStep(
            title: AppLocalizations.of(context)!.emulators,
            icon: AnimatedLucideIconType.cpu,
            builder: _buildEmulatorsStep,
          ),
          _WizardStep(
            title: AppLocalizations.of(context)!.storage,
            icon: AnimatedLucideIconType.folder,
            builder: _buildStorageStep,
          ),
          _WizardStep(
            title: AppLocalizations.of(context)!.wizardDownloadEmulators,
            icon: AnimatedLucideIconType.cloudDownload,
            builder: _buildDownloadEmulatorsStep,
          ),
          _WizardStep(
            title: AppLocalizations.of(context)!.wizardDownloadRomLists,
            icon: AnimatedLucideIconType.database,
            builder: _buildDownloadRomListsStep,
          ),
          _WizardStep(
            title: AppLocalizations.of(context)!.wizardDownloadGamelists,
            icon: AnimatedLucideIconType.archive,
            builder: _buildDownloadGamelistsStep,
          ),
        ],
        _WizardStep(
          title: AppLocalizations.of(context)!.ready,
          icon: AnimatedLucideIconType.shieldCheck,
          builder: _buildReadyStep,
        ),
      ];
      _totalSteps = _steps.length;

      // Check initial download states
      if (!kIsWeb) {
        _checkInitialDownloadStates();
      }
    }
  }

  Future<void> _checkInitialDownloadStates() async {
    final romlistDownloaded = await RomlistDownloadService.instance
        .isDownloaded();
    final gamelistDownloaded = await GamelistDownloadService.instance
        .isDownloaded();

    if (!mounted) return;
    setState(() {
      if (romlistDownloaded) {
        _romlistDownloadState = _WizardDownloadState.alreadyDone;
      }
      if (gamelistDownloaded) {
        _gamelistDownloadState = _WizardDownloadState.alreadyDone;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _pageController.dispose();
    _emulatorsPathController.dispose();
    _emulatorsConfigPathController.dispose();
    _mediaPathController.dispose();
    _romTempPathController.dispose();
    _romForeverPathController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  bool get _canGoNext => _currentStep < _totalSteps - 1;

  bool get _canGoBack => _currentStep > 0;

  bool get _isLastStep => _currentStep == _totalSteps - 1;

  /// Validates the current step. Returns null if valid, or an error message.
  String? _validateCurrentStep() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentStep == 0) {
      if (!_disclaimerAccepted) {
        return l10n.disclaimerRequired;
      }
      return null;
    }

    // Desktop-only steps (index 1 = Emulators, index 2 = Storage)
    if (!kIsWeb) {
      if (_currentStep == 1) {
        if (_emulatorsPathController.text.trim().isEmpty) {
          return l10n.emulatorsPathRequired;
        }
        if (_emulatorsConfigPathController.text.trim().isEmpty) {
          return l10n.emulatorConfigPathRequired;
        }
        return null;
      }

      if (_currentStep == 2) {
        if (_mediaPathController.text.trim().isEmpty) {
          return l10n.mediaPathRequired;
        }
        if (_romTempPathController.text.trim().isEmpty) {
          return l10n.tempRomPathRequired;
        }
        if (_romForeverPathController.text.trim().isEmpty) {
          return l10n.permanentRomPathRequired;
        }
        return null;
      }
    }

    // Download steps (3, 4, 5) are optional - no validation needed
    return null;
  }

  void _goNext() {
    final error = _validateCurrentStep();
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }

    if (_currentStep == 0 && _disclaimerAccepted) {
      _configService.setDisclaimerAccepted(true);
    }

    // Save paths when leaving storage step (step 2) so download steps
    // can use the configured paths
    if (!kIsWeb && _currentStep == 2) {
      _savePaths();
    }

    if (!_canGoNext) return;
    setState(() {
      _validationError = null;
      _currentStep++;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    if (!_canGoBack) return;
    setState(() {
      _validationError = null;
      _currentStep--;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishSetup() async {
    // Save any modified paths
    if (!kIsWeb) {
      await _savePaths();
    }

    // Mark setup as completed
    await _configService.setSetupCompleted(true);

    DebugService.instance.info('Setup wizard completed', tag: 'SetupWizard');

    widget.onComplete();
  }

  Future<void> _savePaths() async {
    final settings = <String, String>{
      'EMULATORS_PATH': _emulatorsPathController.text.trim(),
      'EMULATORS_CONFIG_PATH': _emulatorsConfigPathController.text.trim(),
      'MEDIA_PATH': _mediaPathController.text.trim(),
      'ROM_TEMP_PATH': _romTempPathController.text.trim(),
      'ROM_FOREVER_PATH': _romForeverPathController.text.trim(),
    };

    await _configService.savePathSettings(settings);
  }

  Future<void> _pickDirectory(TextEditingController controller) async {
    final result = await FilePicker.getDirectoryPath();
    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Input handling
  // ---------------------------------------------------------------------------

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

    if (gamepad.isSelectPressed()) {
      if (_isLastStep) {
        _finishSetup();
      } else {
        _goNext();
      }
    } else if (gamepad.isBackPressed()) {
      _goBack();
    }

    gamepad.updatePreviousButtonStates();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isBackKey(key)) {
      if (_canGoBack) {
        _goBack();
      }
      return KeyEventResult.handled;
    }

    if (_keyboardService.isSelectKey(key)) {
      if (_isLastStep) {
        _finishSetup();
      } else {
        _goNext();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // ---------------------------------------------------------------------------
  // Download logic
  // ---------------------------------------------------------------------------

  Future<void> _downloadEmulators(String category) async {
    setState(() {
      _emuDownloadState = _WizardDownloadState.downloading;
      _emuDownloadProgress = 0.0;
      _emuDownloadStatus = null;
      _emuDownloadCompleted = 0;
    });

    try {
      final downloadService = EmulatorDownloadService.instance;
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
        setState(() {
          _emuDownloadState = _WizardDownloadState.done;
        });
        return;
      }

      setState(() {
        _emuDownloadTotal = emulators.length;
      });

      for (final emulator in emulators) {
        final isInstalled = await downloadService.isEmulatorInstalled(emulator);
        if (isInstalled) {
          setState(() {
            _emuDownloadCompleted++;
            _emuDownloadProgress = _emuDownloadCompleted / _emuDownloadTotal;
            _emuDownloadStatus = emulator.displayName;
          });
          continue;
        }

        if (!mounted) return;
        setState(() {
          _emuDownloadStatus = emulator.displayName;
        });

        await downloadService.downloadEmulator(
          emulator,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                final baseProgress = _emuDownloadCompleted / _emuDownloadTotal;
                final stepProgress = progress / _emuDownloadTotal;
                _emuDownloadProgress = baseProgress + stepProgress;
              });
            }
          },
          onStatus: (status) {
            if (mounted) {
              setState(() {
                _emuDownloadStatus = '${emulator.displayName}: $status';
              });
            }
          },
        );

        if (!mounted) return;
        setState(() {
          _emuDownloadCompleted++;
          _emuDownloadProgress = _emuDownloadCompleted / _emuDownloadTotal;
        });
      }

      downloadService.makeAppImagesExecutable(
        Directory(ConfigService.instance.emulatorsPath).path,
      );

      if (!mounted) return;
      setState(() {
        _emuDownloadState = _WizardDownloadState.done;
        _emuDownloadProgress = 1.0;
      });
    } catch (e) {
      DebugService.instance.error(
        'Wizard emulator download failed: $e',
        tag: 'SetupWizard',
      );
      if (!mounted) return;
      setState(() {
        _emuDownloadState = _WizardDownloadState.failed;
        _emuDownloadStatus = e.toString();
      });
    }
  }

  Future<void> _downloadRomLists() async {
    setState(() {
      _romlistDownloadState = _WizardDownloadState.downloading;
      _romlistDownloadProgress = 0.0;
    });

    try {
      final success = await RomlistDownloadService.instance.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _romlistDownloadProgress = progress;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _romlistDownloadState = success
            ? _WizardDownloadState.done
            : _WizardDownloadState.failed;
        _romlistDownloadProgress = success ? 1.0 : 0.0;
      });
    } catch (e) {
      DebugService.instance.error(
        'Wizard ROM list download failed: $e',
        tag: 'SetupWizard',
      );
      if (!mounted) return;
      setState(() {
        _romlistDownloadState = _WizardDownloadState.failed;
      });
    }
  }

  Future<void> _downloadGamelists() async {
    setState(() {
      _gamelistDownloadState = _WizardDownloadState.downloading;
      _gamelistDownloadProgress = 0.0;
    });

    try {
      final success = await GamelistDownloadService.instance.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _gamelistDownloadProgress = progress;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _gamelistDownloadState = success
            ? _WizardDownloadState.done
            : _WizardDownloadState.failed;
        _gamelistDownloadProgress = success ? 1.0 : 0.0;
      });
    } catch (e) {
      DebugService.instance.error(
        'Wizard gamelist download failed: $e',
        tag: 'SetupWizard',
      );
      if (!mounted) return;
      setState(() {
        _gamelistDownloadState = _WizardDownloadState.failed;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        body: Column(
          children: [
            // Step indicator
            _buildStepIndicator(theme),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _steps.map((step) => step.builder()).toList(),
              ),
            ),

            // Validation error
            if (_validationError != null)
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF453A).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF453A).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 18,
                      color: Color(0xFFFF453A),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _validationError!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Mouse / touch navigation bar
            _buildNavigationButtons(theme),

            // Bottom controls
            ControlsBottomBar(
              actions: [
                if (_canGoBack)
                  BottomBarAction(
                    label: AppLocalizations.of(context)!.back,
                    keyboardKey: 'ESC',
                    gamepadButton: 'B',
                  ),
                if (_canGoNext)
                  BottomBarAction(
                    label: AppLocalizations.of(context)!.next,
                    keyboardKey: 'Enter',
                    gamepadButton: 'A',
                  ),
                if (_isLastStep)
                  BottomBarAction(
                    label: AppLocalizations.of(context)!.finish,
                    keyboardKey: 'Enter',
                    gamepadButton: 'A',
                  ),
              ],
              counterText: AppLocalizations.of(
                context,
              )!.wizardStepCounter(_currentStep + 1, _totalSteps),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_canGoBack)
                OutlinedButton.icon(
                  onPressed: _goBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.85),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(l10n.back),
                )
              else
                const SizedBox.shrink(),
              FilledButton.icon(
                onPressed: _isLastStep ? _finishSetup : _goNext,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: Icon(
                  _isLastStep
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
                label: Text(
                  _isLastStep ? l10n.finish : l10n.next,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: List.generate(_totalSteps, (index) {
            final step = _steps[index];
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;
            final activeColor = theme.colorScheme.primary;
            const completedColor = Color(0xFF30D158);
            final labelColor = isActive
                ? Colors.white
                : isCompleted
                ? completedColor
                : Colors.white.withValues(alpha: 0.45);

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: index == 0
                        ? const SizedBox.shrink()
                        : Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 18),
                            color: isCompleted || isActive
                                ? activeColor.withValues(alpha: 0.55)
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? activeColor
                              : isCompleted
                              ? completedColor.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.07),
                          border: Border.all(
                            color: isActive
                                ? activeColor
                                : isCompleted
                                ? completedColor.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: completedColor,
                                )
                              : AnimatedLucideIcon(
                                  type: step.icon,
                                  size: 16,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.55),
                                  animate: isActive,
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: labelColor,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Expanded(
                    child: index == _totalSteps - 1
                        ? const SizedBox.shrink()
                        : Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 18),
                            color: isCompleted
                                ? activeColor.withValues(alpha: 0.55)
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1: Welcome + Legal Disclaimer
  // ---------------------------------------------------------------------------

  Widget _buildWelcomeStep() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Center(
                  child: AnimatedLucideIcon(
                    type: AnimatedLucideIconType.gamepad,
                    size: 28,
                    color: theme.colorScheme.primary,
                    animate: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.welcomeMessage,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${AppLocalizations.of(context)!.version} $kAppVersion',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.appDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              // Legal disclaimer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  kLegalDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Acceptance checkbox
              Material(
                color: _disclaimerAccepted
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: _disclaimerAccepted
                        ? theme.colorScheme.primary.withValues(alpha: 0.45)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: CheckboxListTile(
                  value: _disclaimerAccepted,
                  onChanged: (value) {
                    final accepted = value ?? false;
                    setState(() {
                      _disclaimerAccepted = accepted;
                      _validationError = null;
                    });
                    _configService.setDisclaimerAccepted(accepted);
                  },
                  title: Text(
                    AppLocalizations.of(context)!.iUnderstand,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Emulator Paths (desktop only)
  // ---------------------------------------------------------------------------

  Widget _buildEmulatorsStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.emulatorConfiguration,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emulatorConfigStepDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              _buildPathField(
                label: l10n.emulatorsDirectory,
                hint: l10n.pathToEmulatorBinaries,
                controller: _emulatorsPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: l10n.emulatorConfigFile,
                hint: l10n.pathToEmulatorConfig,
                controller: _emulatorsConfigPathController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3: Storage Paths (desktop only)
  // ---------------------------------------------------------------------------

  Widget _buildStorageStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.storagePaths,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.storagePathsStepDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              _buildPathField(
                label: l10n.mediaPath,
                hint: l10n.wizardMediaPathHint,
                controller: _mediaPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: l10n.temporaryRomStorage,
                hint: l10n.temporaryRomStorageHint,
                controller: _romTempPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: l10n.permanentRomStorage,
                hint: l10n.permanentRomStorageHint,
                controller: _romForeverPathController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4: Download Emulators (desktop only)
  // ---------------------------------------------------------------------------

  Widget _buildDownloadEmulatorsStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.wizardDownloadEmulators,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadEmulatorsDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadOptional,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Status / progress
              _buildDownloadStateWidget(
                theme: theme,
                state: _emuDownloadState,
                progress: _emuDownloadProgress,
                statusText: _emuDownloadStatus,
                completedCount: _emuDownloadCompleted,
                totalCount: _emuDownloadTotal,
              ),

              const SizedBox(height: 24),

              // Category selection buttons
              if (_emuDownloadState == _WizardDownloadState.idle ||
                  _emuDownloadState == _WizardDownloadState.failed) ...[
                Text(
                  l10n.wizardSelectCategory,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCategoryChip(
                      label: l10n.downloadAll,
                      icon: Icons.download,
                      onTap: () => _downloadEmulators('all'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categorySony,
                      icon: Icons.videogame_asset,
                      onTap: () => _downloadEmulators('sony'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categoryNintendo,
                      icon: Icons.sports_esports,
                      onTap: () => _downloadEmulators('nintendo'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categoryMicrosoft,
                      icon: Icons.gamepad,
                      onTap: () => _downloadEmulators('microsoft'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categoryMultiPlatform,
                      icon: Icons.apps,
                      onTap: () => _downloadEmulators('multi'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categoryOtherEmulators,
                      icon: Icons.more_horiz,
                      onTap: () => _downloadEmulators('other'),
                    ),
                    _buildCategoryChip(
                      label: l10n.categoryUtilities,
                      icon: Icons.build,
                      onTap: () => _downloadEmulators('utilities'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 5: Download ROM Lists (desktop only)
  // ---------------------------------------------------------------------------

  Widget _buildDownloadRomListsStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.wizardDownloadRomLists,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadRomListsDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadOptional,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Status / progress
              _buildDownloadStateWidget(
                theme: theme,
                state: _romlistDownloadState,
                progress: _romlistDownloadProgress,
              ),

              const SizedBox(height: 24),

              // Download button
              if (_romlistDownloadState == _WizardDownloadState.idle ||
                  _romlistDownloadState == _WizardDownloadState.failed)
                Center(
                  child: FilledButton.icon(
                    onPressed: _downloadRomLists,
                    icon: const Icon(Icons.download),
                    label: Text(l10n.download),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 6: Download Gamelists (desktop only)
  // ---------------------------------------------------------------------------

  Widget _buildDownloadGamelistsStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.wizardDownloadGamelists,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadGamelistsDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wizardDownloadOptional,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Status / progress
              _buildDownloadStateWidget(
                theme: theme,
                state: _gamelistDownloadState,
                progress: _gamelistDownloadProgress,
              ),

              const SizedBox(height: 24),

              // Download button
              if (_gamelistDownloadState == _WizardDownloadState.idle ||
                  _gamelistDownloadState == _WizardDownloadState.failed)
                Center(
                  child: FilledButton.icon(
                    onPressed: _downloadGamelists,
                    icon: const Icon(Icons.download),
                    label: Text(l10n.download),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 7: Ready
  // ---------------------------------------------------------------------------

  Widget _buildReadyStep() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              AnimatedLucideIcon(
                type: AnimatedLucideIconType.shieldCheck,
                size: 80,
                color: theme.colorScheme.primary,
                animate: true,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.allSet,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.wizardEmulatorReady,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Configuration summary
              if (!kIsWeb) ...[
                _buildSummaryCard(theme),
                const SizedBox(height: 24),
              ],
              Text(
                l10n.changeSettingsLater,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _finishSetup,
                icon: const Icon(Icons.arrow_forward),
                label: Text(l10n.start),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.configurationSummary,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildSummaryRow(
              l10n.summaryEmulators,
              _emulatorsPathController.text,
            ),
            _buildSummaryRow(l10n.summaryMedia, _mediaPathController.text),
            _buildSummaryRow(l10n.summaryTempRoms, _romTempPathController.text),
            _buildSummaryRow(
              l10n.summarySavedRoms,
              _romForeverPathController.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty
                  ? AppLocalizations.of(context)!.defaultValue
                  : value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared widgets
  // ---------------------------------------------------------------------------

  Widget _buildPathField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _pickDirectory(controller),
              icon: const Icon(Icons.folder_open),
              tooltip: AppLocalizations.of(context)!.browse,
            ),
          ],
        ),
      ],
    );
  }

  /// Shared widget for showing download state across the 3 download steps.
  Widget _buildDownloadStateWidget({
    required ThemeData theme,
    required _WizardDownloadState state,
    required double progress,
    String? statusText,
    int? completedCount,
    int? totalCount,
  }) {
    final l10n = AppLocalizations.of(context)!;

    switch (state) {
      case _WizardDownloadState.idle:
        return const SizedBox.shrink();

      case _WizardDownloadState.downloading:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.wizardDownloading,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    if (completedCount != null && totalCount != null)
                      Text(
                        '$completedCount / $totalCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress > 0 ? progress : null),
                if (statusText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    statusText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (progress > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );

      case _WizardDownloadState.done:
        return Card(
          color: Colors.green.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Text(
                  l10n.wizardDownloadComplete,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );

      case _WizardDownloadState.failed:
        return Card(
          color: Colors.red.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.wizardDownloadFailed(
                          statusText ?? 'Unknown error',
                        ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case _WizardDownloadState.alreadyDone:
        return Card(
          color: Colors.blue.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  l10n.wizardAlreadyDownloaded,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildCategoryChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

// -----------------------------------------------------------------------------
// Helper classes
// -----------------------------------------------------------------------------

class _WizardStep {
  final String title;
  final AnimatedLucideIconType icon;
  final Widget Function() builder;

  const _WizardStep({
    required this.title,
    required this.icon,
    required this.builder,
  });
}

/// State for each download step in the wizard.
enum _WizardDownloadState { idle, downloading, done, failed, alreadyDone }
