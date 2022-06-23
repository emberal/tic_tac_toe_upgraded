import 'dart:convert' show json;

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tic_tac_toe_upgraded/game/local_multiplayer_game.dart';
import 'package:tic_tac_toe_upgraded/objects/shared_prefs.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import './game/singleplayer_game.dart';
import './settings.dart';
import './stats.dart';
import 'game/multiplayer_game.dart';
import 'widgets/menu.dart';

void main() async {
  runApp(const MyApp());
  MyPrefs.init();
}

enum Nav {
  home("/"),
  sp("/sp_game"),
  lmp("/lmp_game"),
  mp("/mp_game"),
  stats("/stats"),
  settings("/settings");

  const Nav(this.route);

  final String route;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void changeTheme(ThemeMode mode) =>
      setState(() => MyTheme.setGlobalTheme(mode));

  /// Creates a [ColorPickerDialog] that can be used to change colours for certain materials
  Future<bool> colorPickerDialog(
      ColorWrapper material, BuildContext context) async {
    return ColorPicker(
      // Start color.
      color: material.color,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) {
        setState(() => material.color = color);
        MyPrefs.saveMaterial(material);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: false,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  /// If [data] exists, override the existing [color] in [material]
  void _setMaterial(ColorWrapper material, String? data) {
    if (data != null) {
      material.color = ColorWrapper.fromJSON(
        json.decode(data),
      ).color;
      // Should not be necessary to change [id]
    }
    // TODO else reset material to original when deleting data
  }

  @override
  Widget build(BuildContext context) {
    LocalMultiplayerGame.rotateGlobal = MyPrefs.getBool(SettingsKey.rotate.key);

    for (var element in MyTheme.colors) {
      if (element.id != "") {
        _setMaterial(element, MyPrefs.getString(element.id));
      }
    }

    late ThemeMode theme = ThemeMode.system;
    if (MyPrefs.isInitialized()) {
      final stringTheme = MyPrefs.getString(ThemeId.global.both ?? "") ?? "";
      if (stringTheme == ThemeMode.light.toString()) {
        theme = ThemeMode.light;
      } else if (stringTheme == ThemeMode.dark.toString()) {
        theme = ThemeMode.dark;
      }
      MyTheme.setGlobalTheme(theme);
    }

    return MaterialApp(
      title: 'Tic-Tac-Toe Upgraded',
      debugShowCheckedModeBanner: false,
      themeMode: MyTheme.globalTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: MyTheme.primaryColorsLight.color,
          onPrimary: MyTheme.contrast(MyTheme.primaryColorsLight.color) ??
              Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: MyTheme.primaryColorsDark.color,
          onPrimary:
              MyTheme.contrast(MyTheme.primaryColorsDark.color) ?? Colors.white,
        ),
      ),
      initialRoute: Nav.home.route,
      routes: {
        Nav.home.route: (context) => const MyHomePage(),
        Nav.sp.route: (context) => const SinglePlayerGamePage(),
        Nav.lmp.route: (context) => const LocalMultiplayerGame(),
        Nav.mp.route: (context) => const MultiplayerGame(),
        Nav.stats.route: (context) => const StatsPage(),
        Nav.settings.route: (context) => SettingsPage(
            themeModeCallback: changeTheme,
            colorPickerDialog: colorPickerDialog),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Returns the [PackageInfo] from [pubspec.yaml]
  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        children: [
          Center(
            child: Menu(
              menus: [
                {"page": Nav.sp.route, "text": "New single-player game"},
                {"page": Nav.lmp.route, "text": "New local multiplayer game"},
                {"page": Nav.mp.route, "text": "New multiplayer game"},
                {"page": Nav.stats.route, "text": "Stats"},
                {"page": Nav.settings.route, "text": "Settings"},
              ],
            ),
          ),
          // Version number
          FutureBuilder(
            future: _getPackageInfo(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              return Text("Version: ${snapshot.data?.version}");
            },
          ),
        ],
      ),
    );
  }
}
