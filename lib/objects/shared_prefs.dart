import 'dart:convert' show json;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';

abstract class MyPrefs {
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefs;

  static Future<SharedPreferences?> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  static bool isInitialized() {
    return _prefs != null;
  }

  static String? getString(String key, [String? defaultValue]) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  static bool getBool(String key, [bool defaultValue = true]) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    prefs.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _instance;
    prefs.setBool(key, value);
  }

  static Future<void> saveMaterial(ColorWrapper material) async {
    final prefs = await _instance;
    prefs.setString(material.id, json.encode(material.toJSON()));
  }

  static Future<void> remove({String? key, List<String>? keys}) async {
    final prefs = await _instance;
    if (key != null) {
      prefs.remove(key);
    }
    if (keys != null) {
      for (var key in keys) {
        prefs.remove(key);
      }
    }
  }
}
