import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/local_multiplayer_game.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import './game/singleplayer_game.dart';
import './settings.dart';
import './stats.dart';
import 'game/multiplayer_game.dart';
import 'widgets/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const boardLength = 9, values = 5;

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Upgraded',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary app colour
      ),
      // darkTheme: ThemeData(
      // TODO
      // ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(),
        "/sp_game": (context) => const SinglePlayerGamePage(),
        "/lmp_game": (context) => const LocalMultiplayerGame(),
        "/mp_game": (context) => const MultiplayerGame(),
        "/stats": (context) => const StatsPage(),
        "/settings": (context) => const SettingsPage(),
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
  @override
  Widget build(BuildContext context) {
    return const Layout(
      body: Center(
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
    );
  }
}
