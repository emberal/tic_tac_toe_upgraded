import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/objects/player_red.dart';

import '../enums/player_enum.dart';
import '../widgets/layout.dart';
import '../objects/game_button.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _board = [];
  final playerRed = PlayerRed();
  int? _activeNumber; // Is 'null' when no number is active

  final _values = [
    {"value": 1, "used": false},
    {"value": 2, "used": false},
    {"value": 3, "used": false},
    {"value": 4, "used": false},
    {"value": 5, "used": false}
  ];

  _GameState() {
    for (int i = 0; i < 9; i++) {
      _board.add(GameButton(index: i));
    }
  }

  void handlePress(int index, Player p) {
    if (_board[index].value < _activeNumber) {
      setState(() {
        _board[index].value = _activeNumber;
        _board[index].player = p;
      });
      _values[_activeNumber! - 1]["used"] = true;
      _activeNumber = null;

      if (isComplete()) {
        // TODO find winner, mark the winning area, update stats, modal popup asking for new game
        print("You won!");
      }
    } else {
      // TODO write message on screen
    }
  }

  /// Sets the next number to be used on the board
  void setActiveNumber(int value) {
    _activeNumber = value;
  }

  /// Checks if a player has three in a row, or both players have used all moves
  bool isComplete() {
    for (int i = 0; i < _board.length; i++) {
      _board[i] as GameButton;
      // TODO
    }
    return false;
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
                  children: _board
                      .map(
                        (element) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (element as GameButton).player.color,
                              ),
                              child: Text(
                                "${element.value}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              onPressed: () => _activeNumber == null
                                  ? null
                                  : {
                                      handlePress(element.index, Player.blue),
                                      playerRed.nextMove(),
                                      // PlayerRed does it's next move
                                    },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Row(
            // selectable values
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._values
                  .map(
                    (value) => TextButton(
                      // If a value has been used already, do nothing
                      onPressed: value["used"] as bool
                          ? null
                          : () => setActiveNumber(value["value"] as int),
                      child: Text("${value["value"]}"),
                    ),
                  )
                  .toList()
            ],
          ),
        ],
      ),
    );
  }
}
