import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/gamepad_service.dart';

/// Action item for the bottom bar
class BottomBarAction {
  final String label;
  final String keyboardKey;
  final String gamepadButton;
  final IconData? icon;

  const BottomBarAction({
    required this.label,
    required this.keyboardKey,
    required this.gamepadButton,
    this.icon,
  });
}

/// Translucent bottom bar showing available actions with keyboard/gamepad controls
class ControlsBottomBar extends StatefulWidget {
  final List<BottomBarAction> actions;
  final String? counterText;

  const ControlsBottomBar({super.key, required this.actions, this.counterText});

  @override
  State<ControlsBottomBar> createState() => _ControlsBottomBarState();
}

class _ControlsBottomBarState extends State<ControlsBottomBar> {
  final _gamepadService = GamepadService.instance;

  @override
  Widget build(BuildContext context) {
    final isGamepadConnected = _gamepadService.isGamepadConnected;
    final isMobile = MediaQuery.of(context).size.width < 600;

    // On mobile without gamepad, only show counter
    final showActions = !isMobile || isGamepadConnected;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withValues(alpha: 0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Actions (only show on desktop or if gamepad is connected)
                if (showActions)
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.actions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final action = widget.actions[index];
                        return _buildActionItem(action, isGamepadConnected);
                      },
                    ),
                  ),
                // Spacer for mobile without gamepad (center counter)
                if (!showActions) const Spacer(),
                // Counter text (if provided) - moved to the right
                if (widget.counterText != null) ...[
                  if (showActions) const SizedBox(width: 16),
                  if (showActions)
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  if (showActions) const SizedBox(width: 16),
                  Text(
                    widget.counterText!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                // Spacer for mobile without gamepad (center counter)
                if (!showActions) const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(BottomBarAction action, bool useGamepad) {
    final key = useGamepad ? action.gamepadButton : action.keyboardKey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon (optional)
        if (action.icon != null) ...[
          Icon(action.icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
        ],
        // Key/Button indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            key,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Action label
        Text(
          action.label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
