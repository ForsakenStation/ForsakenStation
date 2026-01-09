import 'package:flutter/material.dart';

class ConfigurationErrorScreen extends StatelessWidget {
  const ConfigurationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Configuration Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please create a .env file in the project root with at least one ROM source:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Option 1 - JSONL ROMs:\nJSONL_ROMS_PATH=/path/to/jsonl\nMEDIA_PATH=/path/to/media\n\nOption 2 - File-based ROMs:\nROMS_PATH=/path/to/roms\nMEDIA_PATH=/path/to/media',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'See .env.example for more details',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
