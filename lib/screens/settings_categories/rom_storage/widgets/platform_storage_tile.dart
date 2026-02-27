import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../utils/format_utils.dart';
import '../../../../widgets/common/gamepad_button_indicator.dart';

class PlatformStorageTile extends StatelessWidget {
  final String platform;
  final List<File> roms;
  final bool isForever;
  final bool isExpanded;
  final bool isSelected;
  final bool isGamepadConnected;
  final Function(bool) onExpansionChanged;
  final Widget Function(File) romBuilder;

  const PlatformStorageTile({
    super.key,
    required this.platform,
    required this.roms,
    required this.isForever,
    required this.isExpanded,
    required this.isSelected,
    required this.isGamepadConnected,
    required this.onExpansionChanged,
    required this.romBuilder,
  });

  @override
  Widget build(BuildContext context) {
    int totalSize = 0;
    for (var rom in roms) {
      totalSize += rom.lengthSync();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          leading: _buildLeading(context),
          title: Text(
            platform.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          subtitle: Text('${roms.length} ROMs • ${formatBytes(totalSize)}'),
          children: roms.map((rom) => romBuilder(rom)).toList(),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          isForever ? Icons.cloud_done : Icons.access_time,
          color: isForever ? Colors.green : Colors.orange,
        ),
        if (isGamepadConnected && isSelected)
          const Positioned(
            bottom: -4,
            child: GamepadButtonIndicator(button: GamepadButton.a, size: 12),
          ),
      ],
    );
  }
}
