import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/animated_lucide_icon.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for configuring web-specific settings.
///
/// Only shown when running on the web platform (kIsWeb).
/// Allows users to configure:
/// - CORS proxy URL for ROM downloads
class WebSettingsScreen extends StatefulWidget {
  const WebSettingsScreen({super.key});

  @override
  State<WebSettingsScreen> createState() => _WebSettingsScreenState();
}

class _WebSettingsScreenState extends State<WebSettingsScreen>
    with
        GamepadPollingMixin<WebSettingsScreen>,
        ScreenNavigationMixin<WebSettingsScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  late final TextEditingController _corsProxyController;

  bool _isSaving = false;
  bool _isTesting = false;
  String? _testResult;
  bool? _testSuccess;

  // Navigation state
  int _selectedIndex = 0;
  static const int _totalItems = 3; // URL field, Test button, Save button

  @override
  void initState() {
    super.initState();
    _corsProxyController = TextEditingController();
    _loadSettings();
    startGamepadPolling(_handleGamepadInput);
  }

  Future<void> _loadSettings() async {
    final corsProxy = await _configService.getCorsProxyUrl();
    if (mounted) {
      setState(() {
        _corsProxyController.text = corsProxy ?? '';
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _corsProxyController.dispose();
    super.dispose();
  }

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      setState(() {
        if (direction == 'up') {
          _selectedIndex = (_selectedIndex - 1) % _totalItems;
          if (_selectedIndex < 0) _selectedIndex = _totalItems - 1;
        } else if (direction == 'down') {
          _selectedIndex = (_selectedIndex + 1) % _totalItems;
        }
      });
    }

    if (gamepad.isSelectPressed()) {
      _activateSelectedItem();
    } else if (gamepad.isBackPressed()) {
      safePop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedItem() {
    switch (_selectedIndex) {
      case 0: // URL field (focus it)
        _focusNode.unfocus();
        break;
      case 1: // Test button
        if (!_isTesting) _testProxy();
        break;
      case 2: // Save button
        if (!_isSaving) _saveSettings();
        break;
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _totalItems;
      });
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1) % _totalItems;
        if (_selectedIndex < 0) _selectedIndex = _totalItems - 1;
      });
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedItem();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Test the CORS proxy by fetching a small known file through it.
  Future<void> _testProxy() async {
    final proxyUrl = _corsProxyController.text.trim();
    if (proxyUrl.isEmpty) {
      setState(() {
        _testResult = AppLocalizations.of(context)!.noProxyUrlConfigured;
        _testSuccess = false;
      });
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = null;
    });

    try {
      // Test with a small, reliable external URL
      const testTarget = 'https://httpbin.org/get';
      final base = proxyUrl.endsWith('/') ? proxyUrl : '$proxyUrl/';
      final testUrl = '$base?url=${Uri.encodeComponent(testTarget)}';

      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _testResult = AppLocalizations.of(
              context,
            )!.proxyWorking(response.statusCode);
            _testSuccess = true;
          });
        } else {
          setState(() {
            _testResult = AppLocalizations.of(
              context,
            )!.proxyReturnedHttp(response.statusCode);
            _testSuccess = false;
          });
        }
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _testResult = AppLocalizations.of(context)!.connectionTimedOut;
          _testSuccess = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _testResult = 'Error: $e';
          _testSuccess = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);

    try {
      final proxyUrl = _corsProxyController.text.trim();

      // Save to SharedPreferences
      await _configService.setCorsProxyUrl(proxyUrl.isEmpty ? null : proxyUrl);

      // Update the running WebEmulatorService instance.
      // This import is conditional (web only), so we go through
      // the config service. The actual runtime update happens
      // via the singleton. We can't import WebEmulatorService here
      // because this file may be compiled for non-web, but this
      // screen is only ever shown on web (guarded by kIsWeb in
      // settings_screen.dart). However, to avoid the import issue
      // we just save to prefs and note it takes effect on next
      // app start, OR we can use a callback.
      //
      // For immediate effect, we'll try a dynamic approach:
      // The caller (settings_screen) should reload the proxy URL
      // into WebEmulatorService after this screen pops.

      if (mounted) {
        AppSnackBar.success(
          context,
          AppLocalizations.of(context)!.corsProxySettingsSaved,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorSavingSettings} $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
          title: Text(AppLocalizations.of(context)!.webSettings),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.webSettingsDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.65),
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Info card explaining CORS proxy
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.corsProxyWhyNeeded,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.corsProxyExplanation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // CORS Proxy URL field
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selectedIndex == 0
                                  ? Colors.white.withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.08),
                              width: _selectedIndex == 0 ? 1.5 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.corsProxyUrl,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _corsProxyController,
                                decoration: InputDecoration(
                                  hintText:
                                      'https://your-worker.your-subdomain.workers.dev/',
                                  border: const OutlineInputBorder(),
                                  helperText: AppLocalizations.of(
                                    context,
                                  )!.corsProxyHelperText,
                                  helperMaxLines: 2,
                                ),
                                keyboardType: TextInputType.url,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Test button
                        Material(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.white.withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.08),
                              width: _selectedIndex == 1 ? 1.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: _isTesting ? null : _testProxy,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      AnimatedLucideIcon(
                                        type: AnimatedLucideIconType.globe,
                                        size: 20,
                                        animate:
                                            _selectedIndex == 1 || _isTesting,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.8),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _isTesting
                                              ? AppLocalizations.of(
                                                  context,
                                                )!.testingProxy
                                              : AppLocalizations.of(
                                                  context,
                                                )!.testProxyConnection,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      if (_isTesting)
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (_testResult != null) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          _testSuccess == true
                                              ? Icons.check_circle_rounded
                                              : Icons.error_rounded,
                                          color: _testSuccess == true
                                              ? const Color(0xFF30D158)
                                              : const Color(0xFFFF453A),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _testResult!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: _testSuccess == true
                                                  ? const Color(0xFF30D158)
                                                  : const Color(0xFFFF453A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Deployment instructions card
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.rocket_launch_outlined,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.75),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.quickDeploy,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.corsProxyDeploySteps,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.75),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Save button
                        Container(
                          decoration: _selectedIndex == 2
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  ),
                                )
                              : null,
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSaving ? null : _saveSettings,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: _isSaving
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          AppLocalizations.of(context)!.saving,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.saveSettings,
                                    ),
                            ),
                          ),
                        ),
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
                  label: AppLocalizations.of(context)!.navigate,
                  keyboardKey: '\u2191\u2193',
                  gamepadButton: 'D-pad',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.select,
                  keyboardKey: 'Enter',
                  gamepadButton: 'A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
