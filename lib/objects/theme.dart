import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MyTheme {
  /// What [ThemeMode] the app is using, initial theme is [ThemeMode.system]
  static ThemeMode _globalTheme = ThemeMode.system;

  static ThemeMode get globalTheme => _globalTheme;

  static void setGlobalTheme(ThemeMode mode) {
    _globalTheme = mode;
    _saveTheme(mode);
  }

  static Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("global-theme", mode.toString());
  }

  static Future<String> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("global-theme") ?? ThemeMode.system.toString();
  }

  static Color primaryColorsLight = Colors.blue;
  static Color primaryColorsDark = Colors.blue;
  static Color backgroundLight = Colors.white;
  static Color backgroundDark = const Color(0xff121212);
  static Color player1Color = Colors.blue;
  static Color player2Color = Colors.red;

  /// Returns 'true' if the [globalTheme] is set to [ThemeMode.dark], either forced or with system set to dark
  static bool isDark(BuildContext context) =>
      globalTheme == ThemeMode.dark ||
      globalTheme != ThemeMode.light &&
          MediaQuery.of(context).platformBrightness == Brightness.dark;
}
