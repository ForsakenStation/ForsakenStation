import 'package:flutter/material.dart';

/// Result of app initialization
class AppInitResult {
  final Widget? homeScreen;
  final String? errorMessage;

  AppInitResult({this.homeScreen, this.errorMessage});
}
