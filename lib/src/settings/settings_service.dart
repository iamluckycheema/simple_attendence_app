import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeModeKey = 'themeMode';

  // Create a getter method for the theme mode
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeModeKey) ?? 0;
    return ThemeMode.values[index];
  }

  // Create a setter method for the theme mode
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    final index = theme.index;
    await prefs.setInt(_themeModeKey, index);
  }
}
