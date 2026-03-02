import 'package:flutter/material.dart';
import '../../models/language_info.dart';

/// Widget that displays language flags from LanguageInfo
class LanguageFlags extends StatelessWidget {
  final LanguageInfo? languageInfo;
  final double size;
  final double spacing;

  const LanguageFlags({
    super.key,
    required this.languageInfo,
    this.size = 24.0,
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    if (languageInfo == null || !languageInfo!.hasLanguages) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: languageInfo!.languageCodes.map((code) {
        final flag = LanguageInfo.getFlag(code);
        final name = LanguageInfo.getLanguageName(code);

        return Tooltip(
          message: name,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: flag != null
                ? Text(
                    flag,
                    style: TextStyle(
                      fontSize: size * 0.8,
                      fontFamily: 'Noto Color Emoji',
                      fontFamilyFallback: const [
                        'Apple Color Emoji',
                        'Segoe UI Emoji',
                        'Noto Color Emoji',
                        'Twemoji Mozilla',
                      ],
                    ),
                  )
                : Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      code.toUpperCase(),
                      style: TextStyle(
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
