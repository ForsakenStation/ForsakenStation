import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import 'package:forsaken/constants/legal.dart';
import 'package:forsaken/services/config_service.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/services/gamepad_service.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:forsaken/mixins/gamepad_polling_mixin.dart';
import 'package:forsaken/mixins/screen_navigation_mixin.dart';

/// First-run setup wizard that guides users through initial configuration.
///
/// Steps:
///   1. Welcome + Legal Disclaimer (must accept to proceed)
///   2. Platform Selection / Emulator Paths (desktop only, skipped on web)
///   3. Storage Paths (desktop only, skipped on web)
///   4. Ready / Summary
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
  late final int _totalSteps;
  late final List<_WizardStep> _steps;

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

  @override
  void initState() {
    super.initState();

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

    // Build step list based on platform
    _steps = [
      _WizardStep(
        title: 'Welcome',
        icon: Icons.waving_hand,
        builder: _buildWelcomeStep,
      ),
      if (!kIsWeb) ...[
        _WizardStep(
          title: 'Emulators',
          icon: Icons.videogame_asset,
          builder: _buildEmulatorsStep,
        ),
        _WizardStep(
          title: 'Storage',
          icon: Icons.folder,
          builder: _buildStorageStep,
        ),
      ],
      _WizardStep(
        title: 'Ready',
        icon: Icons.check_circle,
        builder: _buildReadyStep,
      ),
    ];
    _totalSteps = _steps.length;

    startGamepadPolling(_handleGamepadInput);
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
    if (_currentStep == 0) {
      if (!_disclaimerAccepted) {
        return 'You must accept the disclaimer to continue.';
      }
      return null;
    }

    // Desktop-only steps (index 1 = Emulators, index 2 = Storage)
    if (!kIsWeb) {
      if (_currentStep == 1) {
        if (_emulatorsPathController.text.trim().isEmpty) {
          return 'Emulators directory path is required.';
        }
        if (_emulatorsConfigPathController.text.trim().isEmpty) {
          return 'Emulator config file path is required.';
        }
        return null;
      }

      if (_currentStep == 2) {
        if (_mediaPathController.text.trim().isEmpty) {
          return 'Media path is required.';
        }
        if (_romTempPathController.text.trim().isEmpty) {
          return 'Temporary ROM storage path is required.';
        }
        if (_romForeverPathController.text.trim().isEmpty) {
          return 'Permanent ROM storage path is required.';
        }
        return null;
      }
    }

    return null;
  }

  void _goNext() {
    final error = _validateCurrentStep();
    if (error != null) {
      setState(() => _validationError = error);
      return;
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
    final result = await FilePicker.platform.getDirectoryPath();
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                color: theme.colorScheme.errorContainer,
                child: Text(
                  _validationError!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Bottom controls
            ControlsBottomBar(
              actions: [
                if (_canGoBack)
                  const BottomBarAction(
                    label: 'Back',
                    keyboardKey: 'ESC',
                    gamepadButton: 'B',
                  ),
                if (_canGoNext)
                  const BottomBarAction(
                    label: 'Next',
                    keyboardKey: 'Enter',
                    gamepadButton: 'A',
                  ),
                if (_isLastStep)
                  const BottomBarAction(
                    label: 'Finish',
                    keyboardKey: 'Enter',
                    gamepadButton: 'A',
                  ),
              ],
              counterText: 'Step ${_currentStep + 1} / $_totalSteps',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: List.generate(_totalSteps, (index) {
            final step = _steps[index];
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;
            final color = isActive
                ? theme.colorScheme.primary
                : isCompleted
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.onSurface.withValues(alpha: 0.3);

            return Expanded(
              child: Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.15,
                              ),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? theme.colorScheme.primary
                              : isCompleted
                              ? theme.colorScheme.primary.withValues(alpha: 0.2)
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.08,
                                ),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : step.icon,
                          size: 18,
                          color: isActive ? theme.colorScheme.onPrimary : color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (index < _totalSteps - 1 && index == 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: _currentStep > 0
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.15,
                              ),
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
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.sports_esports,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Forsaken Emulator',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A modern multi-platform emulator frontend built with Flutter.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Legal disclaimer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  kLegalDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 24),
              // Acceptance checkbox
              CheckboxListTile(
                value: _disclaimerAccepted,
                onChanged: (value) {
                  setState(() {
                    _disclaimerAccepted = value ?? false;
                    _validationError = null;
                  });
                },
                title: const Text('I understand and agree to these terms'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
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
                'Emulator Configuration',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set the paths where your emulators are installed. '
                'You can change these later in Settings > System Paths.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              _buildPathField(
                label: 'Emulators Directory',
                hint: 'Path to emulator binaries',
                controller: _emulatorsPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: 'Emulator Config File',
                hint: 'Path to emulator configuration JSON',
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
                'Storage Paths',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure where media assets and ROM files are stored. '
                'You can change these later in Settings > System Paths.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              _buildPathField(
                label: 'Media Path',
                hint: 'Box art, screenshots, and videos',
                controller: _mediaPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: 'Temporary ROM Storage',
                hint: 'Downloaded ROMs for single play sessions',
                controller: _romTempPathController,
              ),
              const SizedBox(height: 20),
              _buildPathField(
                label: 'Permanent ROM Storage',
                hint: 'ROMs saved for offline play',
                controller: _romForeverPathController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4: Ready
  // ---------------------------------------------------------------------------

  Widget _buildReadyStep() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'You\'re All Set!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Forsaken Emulator is ready to use.',
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
                'You can change any of these settings later from the '
                'Settings screen.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _finishSetup,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Summary',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildSummaryRow('Emulators', _emulatorsPathController.text),
            _buildSummaryRow('Media', _mediaPathController.text),
            _buildSummaryRow('Temp ROMs', _romTempPathController.text),
            _buildSummaryRow('Saved ROMs', _romForeverPathController.text),
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
              value.isEmpty ? '(default)' : value,
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
              tooltip: 'Browse',
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Helper class
// -----------------------------------------------------------------------------

class _WizardStep {
  final String title;
  final IconData icon;
  final Widget Function() builder;

  const _WizardStep({
    required this.title,
    required this.icon,
    required this.builder,
  });
}
