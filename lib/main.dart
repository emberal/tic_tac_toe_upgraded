import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import './game/game.dart';
import './settings.dart';
import './stats.dart';
import './menu.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary app colour
      ),
      home: const MyHomePage(title: 'Tic Tac Toe Upgraded'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
                {"page": Game(), "text": "New Game"},
                {"page": Stats(), "text": "Stats"},
                {"page": Settings(), "text": "Settings"}
              ]
          )
      )
    );
  }
}
