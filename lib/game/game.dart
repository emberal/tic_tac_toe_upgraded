import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/objects/player_red.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';

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
        showDialog(
          context: context,
          builder: (BuildContext context) => const CompleteAlert(
            title: "Congratulations",
            text: "You win!",
          ),
        );
      }
    }
  }

  /// Sets the next number to be used on the board
  void setActiveNumber(int value) {
    _activeNumber = value;
  }

  /// Checks if a player has three in a row, or both players have used all moves
  bool isComplete() {
    return _isCompleteHorizontal() ||
        _isCompleteVertical() ||
        _isCompleteDiagonal();
  }

  /// Checks if at least one horizontal row is complete
  bool _isCompleteHorizontal() {
    for (int i = 0; i < _board.length; i += 3) {
      // First column
      bool complete = false;
      for (int j = i + 1; j % 3 != 0; j++) {
        // Second and third column
        complete = _board[i].player != Player.none &&
            _board[i].player == _board[j].player;
      }
      if (complete) {
        return true;
      }
    }
    return false;
  }

  /// Checks if at least one vertical column is complete
  bool _isCompleteVertical() {
    for (int i = 0; i < _board.length / 3; i++) {
      // First row
      bool complete = false;
      for (int j = i + 3; j < _board.length; j += 3) {
        // Second and third row
        complete = _board[i].player != Player.none &&
            _board[i].player == _board[j].player;
      }
      if (complete) {
        return true;
      }
    }
    return false;
  }

  /// Checks if one of the diagonals are complete
  bool _isCompleteDiagonal() {
    var space = 4; // The space between the squares
    for (int i = 0; i < _board.length / 3; i += 2) {
      // Switches between the 2 top corners
      bool complete = false;
      for (int j = i + space; j < _board.length - i * space / 2; j += space) {
        // Iterates through the diagonals, first round the space is 4, then 2 (0-4-8, then 2-4-6)
        complete = _board[i].player != Player.none &&
            _board[i].player == _board[j].player;
      }
      if (complete) {
        return true;
      }
      space = 2; // half on the second iteration
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
