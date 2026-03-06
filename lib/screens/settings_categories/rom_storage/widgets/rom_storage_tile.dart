import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../utils/format_utils.dart';
import '../../../../widgets/common/gamepad_button_indicator.dart';
import '../../../../l10n/generated/app_localizations.dart';

class RomStorageTile extends StatelessWidget {
  final File file;
  final bool isSelected;
  final bool isGamepadConnected;
  final bool isForever;
  final VoidCallback onDelete;
  final VoidCallback? onSave;

  const RomStorageTile({
    super.key,
    required this.file,
    required this.isSelected,
    required this.isGamepadConnected,
    required this.isForever,
    required this.onDelete,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;
    final fileSize = file.lengthSync();

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
            )
          : null,
      child: ListTile(
        dense: true,
        leading: _buildLeading(),
        title: Text(
          fileName,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          formatBytes(fileSize),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: _buildActions(context),
      ),
    );
  }

  Widget _buildLeading() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.insert_drive_file, size: 20),
        if (isGamepadConnected && isSelected)
          const Positioned(
            bottom: -2,
            child: GamepadButtonIndicator(button: GamepadButton.a, size: 10),
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isForever && onSave != null)
          IconButton(
            icon: const Icon(Icons.save, size: 20),
            onPressed: onSave,
            tooltip: l10n.saveToPermanentStorage,
          ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: onDelete,
          tooltip: l10n.delete,
        ),
      ],
    );
  }
}
