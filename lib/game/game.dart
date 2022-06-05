import 'package:flutter/material.dart';

import '../widgets/layout.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Layout(

      ),
    );
  }
}
