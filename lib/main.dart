import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import './game/game.dart';
import './settings.dart';
import './stats.dart';
import 'widgets/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Upgraded',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary app colour
      ),
      darkTheme: ThemeData(
        // TODO
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(),
        "/game": (context) => const GamePage(),
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
            {"page": "/game", "text": "New single-player game"},
            // {"page": "null", "text": "New local multiplayer game"}, // TODO
            // {"page": "null", "text": "New multiplayer game"}, // TODO
            {"page": "/stats", "text": "Stats"},
            {"page": "/settings", "text": "Settings"},
          ],
        ),
      ),
    );
  }
}
