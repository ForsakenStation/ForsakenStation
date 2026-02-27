import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageContent extends StatelessWidget {
  final String path;

  const FullScreenImageContent({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.file(File(path), key: ValueKey(path)),
      ),
    );
  }
}
