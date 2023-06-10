import 'package:flutter/material.dart';

String themeModeToString(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return 'system';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
  }
}

ThemeMode stringToThemeMode(String themeModeString) {
  switch (themeModeString) {
    case 'system':
      return ThemeMode.system;
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

class AppState {
  final ThemeMode preferredMode;
  final bool isEditMode;
  final bool showCriteriaValidationError;

  AppState({
    required this.preferredMode,
    required this.isEditMode,
    required this.showCriteriaValidationError,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferredMode': themeModeToString(preferredMode),
      'isEditMode': isEditMode,
      'showCriteriaValidationError': showCriteriaValidationError
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    final themeModeString = json['preferredMode'];
    final themeMode = stringToThemeMode(themeModeString);
    return AppState(
        preferredMode: themeMode,
        isEditMode: json['isEditMode'],
        showCriteriaValidationError: json['showCriteriaValidationError']);
  }
}
