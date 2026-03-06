import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../widgets/common/controls_bottom_bar.dart';

/// Helper class for generating bottom bar actions
class RomsScreenBottomBarActions {
  /// Get bottom bar actions based on current view mode and context
  static List<BottomBarAction> getActions({
    required BuildContext context,
    required bool isListView,
    required bool isAtRoot,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final actions = <BottomBarAction>[
      BottomBarAction(
        label: l10n.select,
        keyboardKey: 'Enter',
        gamepadButton: 'A',
        icon: Icons.check,
      ),
      BottomBarAction(label: l10n.back, keyboardKey: 'Esc', gamepadButton: 'B'),
      BottomBarAction(
        label: l10n.refresh,
        keyboardKey: 'R',
        gamepadButton: 'Y',
        icon: Icons.shuffle,
      ),
      BottomBarAction(
        label: l10n.view,
        keyboardKey: 'V',
        gamepadButton: 'R3',
        icon: Icons.view_carousel,
      ),
      BottomBarAction(
        label: l10n.search,
        keyboardKey: 'S',
        gamepadButton: 'X',
        icon: Icons.search,
      ),
      BottomBarAction(
        label: l10n.media,
        keyboardKey: 'M',
        gamepadButton: 'L1',
        icon: Icons.photo_library,
      ),
      BottomBarAction(
        label: l10n.settings,
        keyboardKey: 'Tab',
        gamepadButton: 'Start',
        icon: Icons.settings,
      ),
    ];

    // Add platform navigation for list view at root
    if (isListView && isAtRoot) {
      actions.insert(
        1,
        BottomBarAction(
          label: l10n.platforms,
          keyboardKey: 'Q/E',
          gamepadButton: 'L1/R1',
          icon: Icons.swap_horiz,
        ),
      );
    }

    return actions;
  }
}
