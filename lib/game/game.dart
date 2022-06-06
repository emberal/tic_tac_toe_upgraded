import 'package:flutter/material.dart';

import '../widgets/layout.dart';
import '../objects/game_button.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _board = [];

  _GameState() {
    for (int i = 0; i < 9; i++) {
      _board.add(BoardSqaure(index: i));
    }
  }

  void handlePress(int index) {
    setState(() => {
      _board[index].value += " Clicked"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: _board.map((element) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: TextButton(
                          child: Text(element.value),
                          onPressed: () => handlePress(element.index),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
