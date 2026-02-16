import 'package:flutter/material.dart';

/// Web-specific home screen
/// This screen is shown on web platform and provides a simplified interface
/// for playing games directly in the browser
class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forsaken Emulator - Web'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videogame_asset, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Welcome to Forsaken Emulator',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Play classic games directly in your browser',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Quick test button for EmulatorJS
              ElevatedButton.icon(
                onPressed: _testEmulator,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Test Emulator'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Web emulation is in development.\nMore features coming soon!',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _testEmulator() {
    // Show a dialog with emulator test options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emulator Test'),
        content: const Text(
          'This will test the EmulatorJS integration.\n\n'
          'The web emulator uses EmulatorJS to run games directly in your browser.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchTestEmulator();
            },
            child: const Text('Launch Test'),
          ),
        ],
      ),
    );
  }

  void _launchTestEmulator() {
    // TODO: Navigate to web emulator screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emulator test - coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
