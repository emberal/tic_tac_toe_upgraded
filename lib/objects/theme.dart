import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/objects/shared_prefs.dart';

enum ThemeId {
  global(both: "global-theme"),
  primaryColor(light: "primary-color-light", dark: "primary-color-dark"),
  player1(both: "player1-color"),
  player2(both: "player2-color");

  const ThemeId({this.light, this.dark, this.both});

  final String? light;
  final String? dark;
  final String? both;
}

abstract class MyTheme {
  static ThemeMode _globalTheme = ThemeMode.system;

  /// What [ThemeMode] the app is using, initial theme is [ThemeMode.system]
  static ThemeMode get globalTheme => _globalTheme;

  static void setGlobalTheme(ThemeMode mode) {
    _globalTheme = mode;
    if (ThemeId.global.both != null) {
      MyPrefs.setString(ThemeId.global.both!, mode.toString());
    }
  }

  static ColorWrapper primaryColorsLight =
          ColorWrapper(Colors.blue, id: ThemeId.primaryColor.light!),
      primaryColorsDark =
          ColorWrapper(Colors.blue, id: ThemeId.primaryColor.dark!),
      player1Color = ColorWrapper(Colors.blue, id: ThemeId.player1.both!),
      player2Color = ColorWrapper(Colors.red, id: ThemeId.player2.both!);

  static List<ColorWrapper> colors = [
    primaryColorsLight,
    primaryColorsDark,
    player1Color,
    player2Color
  ];

  /// Returns 'true' if the [globalTheme] is set to [ThemeMode.dark], or [ThemeMode.system] and is dark
  static bool isDark(BuildContext context) =>
      globalTheme == ThemeMode.dark ||
      globalTheme != ThemeMode.light &&
          MediaQuery.of(context).platformBrightness == Brightness.dark;

  static Color? contrast(Color? background) {
    if (background != null) {
      return background.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    }
    return null;
  }
}

/// A helper class used to wrap a [Color] object, so 'pass by pointer' can be used
class ColorWrapper {
  ColorWrapper(this.color, {String id = ""}) : _id = id;

  ColorWrapper.fromJSON(Map<String, dynamic> json)
      : color = Color(json["color"] ?? Colors.blue.value),
        _id = json["id"] ?? "";

  /// The [color] to be wrapped
  Color color;

  final String _id;

  /// A unique [id] that can be used to get this specific object from [SharedPreferences] for example
  String get id => _id;

  /// Converts [id] and [color.value] to a Map, that can be converted to [JSON] format
  Map<String, dynamic> toJSON() => {'id': _id, 'color': color.value};

  @override
  String toString() => "id=$id, object=$color";

  @override
  bool operator ==(Object other) {
    if (this == other) {
      return true;
    }
    if (other is! ColorWrapper) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
