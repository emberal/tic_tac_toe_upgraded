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
    prefs.setString(
        "global-theme", mode.toString()); // TODO save as JSON format
  }

  static Future<String> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("global-theme") ?? ThemeMode.system.toString();
  }

  static Future<void> saveMaterial(Wrapper<Color> material) async {
    final prefs = await SharedPreferences.getInstance();
    //TODO save
  }

  // TODO see which ones are usable
  static Wrapper<Color> appBarColorsLight = Wrapper(Colors.blue),
      appBarColorsDark = Wrapper(const Color(0xff121212)),
      primaryColorsLight = Wrapper(Colors.blue, id: "primary-color-dark"),
      primaryColorsDark = Wrapper(Colors.blue, id: "primary-color-light"),
      backgroundLight = Wrapper(Colors.white),
      backgroundDark = Wrapper(const Color(0xff121212)),
      player1Color = Wrapper(Colors.blue, id: "player1-color"),
      player2Color = Wrapper(Colors.red, id: "player2-color");

  /// Returns 'true' if the [globalTheme] is set to [ThemeMode.dark], either forced or with system set to dark
  static bool isDark(BuildContext context) =>
      globalTheme == ThemeMode.dark ||
      globalTheme != ThemeMode.light &&
          MediaQuery.of(context).platformBrightness == Brightness.dark;
}

/// A helper class used to wrap an object or a primitive type, so 'pass by pointer' can be used
class Wrapper<T> {
  Wrapper(this.object, {String id = ""}) : _id = id;
  T object;

  final String _id;

  /// A unique [id] that can be used to get this specific object from [SharedPreferences] for example
  String get id => _id;

  @override
  bool operator ==(Object other) {
    if (this == other) {
      return true;
    }
    if (other is! Wrapper) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
