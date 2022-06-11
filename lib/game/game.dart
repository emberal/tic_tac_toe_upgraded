import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/player_red.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';

import '../enums/player_enum.dart';
import '../widgets/layout.dart';
import '../objects/game_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _board = [];
  final _values = [
    // TODO change to regular List<bool>
    {"value": 1, "used": false},
    {"value": 2, "used": false},
    {"value": 3, "used": false},
    {"value": 4, "used": false},
    {"value": 5, "used": false}
  ];

  int _activeNumber = -1; // Is '-1' when no number is active
  PlayerRed? playerRed;
  Player winner = Player.none;

  _GamePageState() {
    for (int i = 0; i < 9; i++) {
      _board.add(GameButton(index: i));
    }
    playerRed = PlayerRed(handlePress);
  }

  void handlePress(int index, int value, Player p) {
    if (index != -1 &&
        p != _board[index].player &&
        _board[index].value < value) {
      setState(() {
        _board[index].value = value;
        _board[index].player = p;
      });

      if (p == Player.blue) {
        _values[value - 1]["used"] = true;
        _activeNumber = -1;
      }

      if (isComplete()) {
        // TODO mark the winning area, update stats
        if (_fullBoard()) {
          winner = Player.red;
        } else {
          winner = p;
        }
        setData(winner == Player.blue);
        showDialog(
          context: context,
          builder: (BuildContext context) => CompleteAlert(
            title: winner == Player.blue ? "Congratulations" : "You lost",
            text: winner == Player.blue ? "You win!" : "Better luck next time",
          ),
        );
      } else {
        if (p == Player.blue) {
          playerRed!.nextMove(_board); // Starts the other players move
        }
      }
    }
  }

  /// Saves the data to the local-storage, if [won] also updates "games-won"
  Future<void> setData(bool won) async { // TODO update time spent
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("games-played", (prefs.getInt("games-played") ?? 0) + 1);
    if (won) {
      prefs.setInt("games-won", (prefs.getInt("games-won") ?? 0) + 1);
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
        _isCompleteDiagonal() ||
        _fullBoard();
  }

  /// returns 'true' if all the squares on the board are used
  bool _fullBoard() {
    return _board.every((element) => element.value != 0);
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
        if (!complete) {
          // If the first 2 are false, the entire row i false
          break;
        }
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
        if (!complete) {
          break;
        }
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
        if (!complete) {
          break;
        }
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
                              onPressed: () => _activeNumber == -1
                                  ? null
                                  : {
                                      handlePress(element.index, _activeNumber,
                                          Player.blue),
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
