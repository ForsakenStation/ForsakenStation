import 'package:flutter/material.dart';

/// A simple virtual keyboard for text input on console-like devices
class VirtualKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onClose;

  const VirtualKeyboard({super.key, required this.controller, this.onClose});

  @override
  State<VirtualKeyboard> createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  bool _isUpperCase = false;

  final List<List<String>> _keyboardLayout = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  void _onKeyPressed(String key) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (_isUpperCase && key.length == 1) {
      key = key.toUpperCase();
    }

    final newText = text.replaceRange(selection.start, selection.end, key);

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + key.length),
    );
  }

  void _onBackspace() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.start > 0) {
      final newText = text.replaceRange(selection.start - 1, selection.end, '');
      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start - 1),
      );
    }
  }

  void _onSpace() {
    _onKeyPressed(' ');
  }

  void _onShift() {
    setState(() {
      _isUpperCase = !_isUpperCase;
    });
  }

  Widget _buildKey(String key, {double flex = 1, VoidCallback? onPressed}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: onPressed ?? () => _onKeyPressed(key),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            _isUpperCase && key.length == 1 ? key.toUpperCase() : key,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(
    IconData icon,
    VoidCallback onPressed, {
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_hide),
                onPressed: widget.onClose,
                tooltip: 'Hide keyboard',
              ),
            ],
          ),
          // Number row
          Row(
            children: _keyboardLayout[0].map((key) => _buildKey(key)).toList(),
          ),
          // QWERTY row
          Row(
            children: _keyboardLayout[1].map((key) => _buildKey(key)).toList(),
          ),
          // ASDF row
          Row(
            children: _keyboardLayout[2].map((key) => _buildKey(key)).toList(),
          ),
          // ZXCV row
          Row(
            children: [
              _buildSpecialKey(
                _isUpperCase ? Icons.arrow_upward : Icons.arrow_downward,
                _onShift,
                flex: 1.5,
              ),
              ..._keyboardLayout[3].map((key) => _buildKey(key)),
              _buildSpecialKey(Icons.backspace, _onBackspace, flex: 1.5),
            ],
          ),
          // Space bar row
          Row(
            children: [
              _buildKey('.'),
              _buildSpecialKey(Icons.space_bar, _onSpace, flex: 6),
              _buildKey('-'),
              _buildKey('_'),
            ],
          ),
        ],
      ),
    );
  }
}
