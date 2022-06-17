import 'dart:convert';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/game/local_multiplayer_game.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import './game/singleplayer_game.dart';
import './settings.dart';
import './stats.dart';
import 'game/multiplayer_game.dart';
import 'widgets/menu.dart';

void main() {
  runApp(const MyApp());
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
        MyTheme.saveMaterial(material);
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
  void _setMaterial(ColorWrapper material, bool hasData, String? data) {
    if (hasData && data != null) {
      material.color = ColorWrapper.fromJSON(
        json.decode(data),
      ).color;
      // Should not be necessary to change [id]
    }
  }

  // TODO get themes before the app loads
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyTheme.getSavedTheme(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        ThemeMode theme = ThemeMode.system;
        if (snapshot.hasData) {
          if (snapshot.data == ThemeMode.light.toString()) {
            theme = ThemeMode.light;
          } else if (snapshot.data == ThemeMode.dark.toString()) {
            theme = ThemeMode.dark;
          }
          MyTheme.setGlobalTheme(theme);
        }
        return FutureBuilder(
          future: GameUtils.getSavedStrings([
            "primary-color-light",
            "primary-color-dark",
            "player1-color",
            "player2-color"
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
            _setMaterial(MyTheme.primaryColorsLight, snapshot.hasData,
                snapshot.data?[0]);
            _setMaterial(
                MyTheme.primaryColorsDark, snapshot.hasData, snapshot.data?[1]);
            _setMaterial(
                MyTheme.player1Color, snapshot.hasData, snapshot.data?[2]);
            _setMaterial(
                MyTheme.player2Color, snapshot.hasData, snapshot.data?[3]);
            return MaterialApp(
              title: 'Tic-Tac-Toe Upgraded',
              debugShowCheckedModeBanner: false,
              themeMode: theme,
              theme: ThemeData(
                colorScheme: ColorScheme.light(
                  primary: MyTheme.primaryColorsLight.color,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: MyTheme.primaryColorsDark.color,
                ),
              ),
              initialRoute: "/",
              routes: {
                "/": (context) => const MyHomePage(),
                "/sp_game": (context) => const SinglePlayerGamePage(),
                "/lmp_game": (context) => const LocalMultiplayerGame(),
                "/mp_game": (context) => const MultiplayerGame(),
                "/stats": (context) => const StatsPage(),
                "/settings": (context) => SettingsPage(
                    themeModeCallback: changeTheme,
                    colorPickerDialog: colorPickerDialog),
              },
            );
          },
        );
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
          const Center(
            child: Menu(
              menus: [
                {"page": "/sp_game", "text": "New single-player game"},
                {"page": "/lmp_game", "text": "New local multiplayer game"},
                {"page": "/mp_game", "text": "New multiplayer game"},
                {"page": "/stats", "text": "Stats"},
                {"page": "/settings", "text": "Settings"},
              ],
            ),
          ),
          // Version number
          FutureBuilder(
            future: _getPackageInfo(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              return Text(
                  "Version: ${snapshot.hasData ? snapshot.data?.version : "null"}");
            },
          ),
        ],
      ),
    );
  }
}
