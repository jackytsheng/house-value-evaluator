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
    // system won't be set in the entire app, as light is the default
    case 'system':
      return ThemeMode.system;
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.light;
  }
}

class AppState {
  ThemeMode preferredMode;
  bool isEditMode;

  AppState({
    this.preferredMode = ThemeMode.light,
    this.isEditMode = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferredMode': themeModeToString(preferredMode),
      'isEditMode': isEditMode,
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    final themeModeString = json['preferredMode'];
    final themeMode = stringToThemeMode(themeModeString);
    return AppState(preferredMode: themeMode, isEditMode: json['isEditMode']);
  }
}
