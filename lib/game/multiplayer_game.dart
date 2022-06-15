import 'package:flutter/material.dart';

import '../widgets/layout.dart';

class MultiplayerGame extends StatefulWidget {
  const MultiplayerGame({super.key});

  @override
  State<MultiplayerGame> createState() => _MultiplayerGameState();
}

class _MultiplayerGameState extends State<MultiplayerGame> {
  @override
  Widget build(BuildContext context) {
    return const Layout(
      title: "Multiplayer game",
    );
  }
}
