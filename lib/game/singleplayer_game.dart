import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/player_red.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../enums/player_enum.dart';
import '../widgets/board.dart';
import '../widgets/layout.dart';
import '../objects/game_button.dart';

class SinglePlayerGamePage extends StatefulWidget {
  const SinglePlayerGamePage({super.key});

  @override
  State<SinglePlayerGamePage> createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage> implements Game {
  @override
  List<GameButton> board = List.generate(MyApp.boardLength, (index) => GameButton(index: index));
  @override
  Player winner = Player.none;

  final _time = Stopwatch(); // Used to time the matches
  final _values = [
    {"value": 1, Player.one.toString(): false},
    {"value": 2, Player.one.toString(): false},
    {"value": 3, Player.one.toString(): false},
    {"value": 4, Player.one.toString(): false},
    {"value": 5, Player.one.toString(): false}
  ];

  int _activeNumber = -1; // Is '-1' when no number is active
  PlayerRed? playerRed;

  _SinglePlayerGamePageState() {
    _time.start();
    playerRed = PlayerRed(handlePress);
  }

  @override
  void handlePress(int index, int value, Player player) {
    if (index != -1 &&
        player != board[index].player &&
        board[index].value < value) {
      setState(() {
        board[index].value = value;
        board[index].player = player;
      });

      if (player == Player.one) {
        _values[value - 1][Player.one.toString()] = true;
        _activeNumber = -1;
      }

      if (GameUtils.isComplete(board)) {
        _time.stop();
        // TODO mark the winning area
        if (GameUtils.fullBoard(board)) {
          winner = Player.two;
        } else {
          winner = player;
        }
        GameUtils.setData(winner == Player.one, _time);
        showDialog(
          context: context,
          builder: (BuildContext context) => CompleteAlert(
            title: winner == Player.one ? "Congratulations" : "You lost",
            text: winner == Player.one ? "You win!" : "Better luck next time",
            navigator: "/sp_game",
          ),
        );
      } else {
        if (player == Player.one) {
          playerRed!.nextMove(board); // Starts the other players move
        }
      }
    }
  }

  /// Sets the next number to be used on the board
  @override
  void setActiveNumber(int value, Player player) {
    setState(() {
      _activeNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Single-player game",
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Board(
                  board: board,
                  pressHandler: handlePress,
                  activeNumber: _activeNumber,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: SelectButtons(
              values: _values,
              setActiveNumber: setActiveNumber,
              player: Player.one,
            ),
          ),
        ],
      ),
    );
  }
}
