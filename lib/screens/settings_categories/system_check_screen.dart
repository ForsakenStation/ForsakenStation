import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/system_check_service.dart';
import '../../services/keyboard_service.dart';

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error checking system: $e')));
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
          title: const Text('System Requirements'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isChecking ? null : _performCheck,
              tooltip: 'Re-check (R)',
            ),
          ],
        ),
        body: _isChecking
            ? const Center(child: CircularProgressIndicator())
            : _result == null
            ? const Center(child: Text('Failed to check system'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Status Card
                    Card(
                      color: _result!.allRequiredMet
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              _result!.allRequiredMet
                                  ? Icons.check_circle
                                  : Icons.warning,
                              size: 48,
                              color: _result!.allRequiredMet
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _result!.allRequiredMet
                                        ? 'All Required Tools Installed'
                                        : 'Missing Required Tools',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _result!.allRequiredMet
                                        ? 'Your system is ready to use the emulator'
                                        : 'Some required tools are missing',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
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

                    // Required Tools Section
                    const Text(
                      'Required Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These tools are required for downloading and extracting emulators',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    ..._buildToolList(
                      _systemCheckService.getRequiredTools(),
                      _result!.missingRequired,
                      isRequired: true,
                    ),

                    if (_result!.missingRequired.isNotEmpty) ...[
                      const SizedBox(height: 16),
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
                                    Icons.info,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Installation Instructions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _systemCheckService.getInstallInstructions(
                                  _result!.missingRequired,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _buildToolList(
    List<String> allTools,
    List<String> missingTools, {
    required bool isRequired,
  }) {
    return allTools.map((tool) {
      final isInstalled = !missingTools.contains(tool);
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(
            isInstalled ? Icons.check_circle : Icons.cancel,
            color: isInstalled ? Colors.green : Colors.red,
          ),
          title: Text(
            tool,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _systemCheckService.getToolDescription(tool),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          trailing: Chip(
            label: Text(
              isInstalled ? 'Installed' : 'Missing',
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: isInstalled
                ? Colors.green.shade100
                : Colors.red.shade100,
          ),
        ),
      );
    }).toList();
  }
}
