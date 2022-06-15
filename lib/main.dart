import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  void changeColors(bool changeDarkMode,
      {Color? primary, Color? background, Color? player1, Color? player2}) {
    setState(() {
      if (changeDarkMode) {
        primary != null ? MyTheme.primaryColorsDark = primary : null;
        background != null ? MyTheme.backgroundDark = background : null;
      } else {
        primary != null ? MyTheme.primaryColorsLight = primary : null;
        background != null ? MyTheme.backgroundLight = background : null;
      }
      player1 != null ? MyTheme.player1Color = player1 : null;
      player2 != null ? MyTheme.player2Color = player2 : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyTheme.getSavedTheme(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return MaterialApp(
          title: 'Tic-Tac-Toe Upgraded',
          debugShowCheckedModeBanner: false,
          themeMode: snapshot.data == ThemeMode.light.toString()
              ? ThemeMode.light
              : snapshot.data == ThemeMode.dark.toString()
                  ? ThemeMode.dark
                  : ThemeMode.system,
          theme: ThemeData(
            colorScheme: ColorScheme.light(primary: MyTheme.primaryColorsLight),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(primary: MyTheme.primaryColorsDark),
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => const MyHomePage(),
            "/sp_game": (context) => const SinglePlayerGamePage(),
            "/lmp_game": (context) => const LocalMultiplayerGame(),
            "/mp_game": (context) => const MultiplayerGame(),
            "/stats": (context) => const StatsPage(),
            "/settings": (context) =>
                SettingsPage(themeModeCallback: changeTheme, themeCallback: changeColors),
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
