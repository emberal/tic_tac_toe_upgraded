import 'package:flutter/material.dart';

import '../widgets/layout.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  var board = ["00", "01", "02", "10", "11", "12", "20", "21", "22"]; // TODO add game_button to array

  void handlePress(int index) {
    setState(() => {
      board[index] += "Clicked"
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
                  children: board.map((value) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: TextButton(
                          child: Text("$value"),
                          onPressed: () => handlePress(0),
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
