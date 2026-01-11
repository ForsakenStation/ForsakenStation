import 'package:flutter/material.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';

/// Helper class for generating bottom bar actions
class RomsScreenBottomBarActions {
  /// Get bottom bar actions based on current view mode and context
  static List<BottomBarAction> getActions({
    required bool isListView,
    required bool isAtRoot,
  }) {
    final actions = <BottomBarAction>[
      const BottomBarAction(
        label: 'Select',
        keyboardKey: 'Enter',
        gamepadButton: 'A',
        icon: Icons.check,
      ),
      const BottomBarAction(
        label: 'Back',
        keyboardKey: 'Esc',
        gamepadButton: 'B',
      ),
      const BottomBarAction(
        label: 'Refresh',
        keyboardKey: 'R',
        gamepadButton: 'Y',
        icon: Icons.shuffle,
      ),
      const BottomBarAction(
        label: 'View',
        keyboardKey: 'V',
        gamepadButton: 'R3',
        icon: Icons.view_carousel,
      ),
      const BottomBarAction(
        label: 'Search',
        keyboardKey: 'S',
        gamepadButton: 'X',
        icon: Icons.search,
      ),
      const BottomBarAction(
        label: 'Media',
        keyboardKey: 'M',
        gamepadButton: 'L1',
        icon: Icons.photo_library,
      ),
      const BottomBarAction(
        label: 'Settings',
        keyboardKey: 'Tab',
        gamepadButton: 'Start',
        icon: Icons.settings,
      ),
    ];

    // Add platform navigation for list view at root
    if (isListView && isAtRoot) {
      actions.insert(
        1,
        const BottomBarAction(
          label: 'Platforms',
          keyboardKey: 'Q/E',
          gamepadButton: 'L1/R1',
          icon: Icons.swap_horiz,
        ),
      );
    }

    return actions;
  }
}
