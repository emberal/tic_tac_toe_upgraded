import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/game_button.dart';
import 'package:tic_tac_toe_upgraded/widgets/board.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../enums/player_enum.dart';
import 'game.dart';

class LocalMultiplayerGame extends StatefulWidget {
  const LocalMultiplayerGame({Key? key}) : super(key: key);

  @override
  State<LocalMultiplayerGame> createState() => _LocalMultiplayerGameState();
}

class _LocalMultiplayerGameState extends State<LocalMultiplayerGame>
    implements Game {
  @override
  List<GameButton> board =
      List.generate(MyApp.boardLength, (index) => GameButton(index: index));
  @override
  Player winner = Player.none, turn = Player.one;
  final _time = Stopwatch();
  final _values = [
    {"value": 1, Player.one.toString(): false, Player.two.toString(): false},
    {"value": 2, Player.one.toString(): false, Player.two.toString(): false},
    {"value": 3, Player.one.toString(): false, Player.two.toString(): false},
    {"value": 4, Player.one.toString(): false, Player.two.toString(): false},
    {"value": 5, Player.one.toString(): false, Player.two.toString(): false}
  ];
  int _activePlayerOne = -1, _activePlayerTwo = -1;

  _LocalMultiplayerGameState() {
    _time.start();
  }

  @override
  void setActiveNumber(int value, Player player) {
    setState(() {
      if (player == Player.one) {
        _activePlayerOne = value;
      } else {
        _activePlayerTwo = value;
      }
    });
  }

  @override
  void handlePress(int index, int newValue, Player player) {
    if (index != -1 &&
        player != board[index].player &&
        player == turn &&
        board[index].value < newValue) {
      setState(() {
        board[index].value = newValue;
        board[index].player = player;
      });

      if (player == Player.one) {
        _values[newValue - 1][Player.one.toString()] = true;
        _activePlayerOne = -1;
        turn = Player.two;
      } else {
        _values[newValue - 1][Player.two.toString()] = true;
        _activePlayerTwo = -1;
        turn = Player.one;
      }

      if (GameUtils.isComplete(board)) {
        _time.stop();

        Player winner = player;

        // TODO Who won? if board isFull the both lost!
        GameUtils.setData(false, _time); // TODO
        showDialog(
            context: context,
            builder: (BuildContext context) => CompleteAlert(
                  title: "$winner won the match",
                  text: "Rematch?",
                  navigator: "/lmp_game",
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Local multiplayer game",
      body: Column(
        children: [
          SelectButtons(
            setActiveNumber: setActiveNumber,
            values: _values,
            buttonColor: Player.two.color,
            player: Player.two,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Board(
                pressHandler: handlePress,
                activeNumber:
                    turn == Player.one ? _activePlayerOne : _activePlayerTwo,
                activePlayer: turn,
                board: board,
              ),
            ),
          ),
          SelectButtons(
            setActiveNumber: setActiveNumber,
            values: _values,
            player: Player.one,
          )
        ],
      ),
    );
  }
}
