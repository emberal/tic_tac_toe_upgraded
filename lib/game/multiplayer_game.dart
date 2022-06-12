import 'package:flutter/material.dart';

import '../widgets/layout.dart';

class MultiplayerGame extends StatefulWidget {
  const MultiplayerGame({Key? key}) : super(key: key);

  @override
  State<MultiplayerGame> createState() => _MultiplayerGameState();
}

class _MultiplayerGameState extends State<MultiplayerGame> {
  @override
  Widget build(BuildContext context) {
    return Layout();
  }
}