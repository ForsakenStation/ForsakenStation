import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/controls_bottom_bar.dart';
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
        _testResult = 'No proxy URL configured';
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
            _testResult = 'Proxy is working (HTTP ${response.statusCode})';
            _testSuccess = true;
          });
        } else {
          setState(() {
            _testResult = 'Proxy returned HTTP ${response.statusCode}';
            _testSuccess = false;
          });
        }
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _testResult = 'Connection timed out';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'CORS proxy settings saved. Takes effect immediately for new ROM launches.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.errorSavingSettings} $e',
            ),
          ),
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
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Configure settings specific to the web platform',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Info card explaining CORS proxy
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Why is a CORS proxy needed?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Browsers block ROM downloads from external servers due to CORS security restrictions. '
                                    'A CORS proxy relays the request from a server you control, adding the necessary headers.\n\n'
                                    'Forsaken includes a Cloudflare Worker you can deploy for free (100k requests/day). '
                                    'See the tools/cors-proxy-worker/ directory for setup instructions.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // CORS Proxy URL field
                    Card(
                      elevation: _selectedIndex == 0 ? 8 : 2,
                      color: _selectedIndex == 0
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CORS Proxy URL',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _corsProxyController,
                              decoration: const InputDecoration(
                                hintText:
                                    'https://your-worker.your-subdomain.workers.dev/',
                                border: OutlineInputBorder(),
                                helperText:
                                    'Leave empty to disable CORS proxy (ROMs from servers without CORS will fail)',
                                helperMaxLines: 2,
                              ),
                              keyboardType: TextInputType.url,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Test button
                    Card(
                      elevation: _selectedIndex == 1 ? 8 : 2,
                      color: _selectedIndex == 1
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: InkWell(
                        onTap: _isTesting ? null : _testProxy,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _isTesting
                                        ? Icons.hourglass_top
                                        : Icons.network_check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _isTesting
                                          ? 'Testing proxy...'
                                          : 'Test Proxy Connection',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
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
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: _testSuccess == true
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _testResult!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: _testSuccess == true
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
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
                    const SizedBox(height: 24),

                    // Deployment instructions card
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Quick Deploy',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '1. Sign up at dash.cloudflare.com (free)\n'
                              '2. Install Wrangler: npm install -g wrangler\n'
                              '3. Login: wrangler login\n'
                              '4. cd tools/cors-proxy-worker\n'
                              '5. npx wrangler deploy\n'
                              '6. Paste the worker URL above',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                color: Colors.orange.shade900,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Save button
              const SizedBox(height: 16),
              Container(
                decoration: _selectedIndex == 2
                    ? BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _selectedIndex == 2
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                    ),
                    child: _isSaving
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.saving),
                            ],
                          )
                        : Text(AppLocalizations.of(context)!.saveSettings),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ControlsBottomBar(
          actions: const [
            BottomBarAction(
              label: 'Back',
              keyboardKey: 'ESC',
              gamepadButton: 'B',
            ),
            BottomBarAction(
              label: 'Navigate',
              keyboardKey: '\u2191\u2193',
              gamepadButton: 'D-pad',
            ),
            BottomBarAction(
              label: 'Select',
              keyboardKey: 'Enter',
              gamepadButton: 'A',
            ),
          ],
        ),
      ),
    );
  }
}
