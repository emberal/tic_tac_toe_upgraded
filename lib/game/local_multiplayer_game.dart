import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/game_button.dart';
import 'package:tic_tac_toe_upgraded/widgets/board.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../objects/player.dart';
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

  late Player _playerOne, _playerTwo;
  final _time = Stopwatch();

  _LocalMultiplayerGameState() {
    _playerOne = Player(name: "Player1", color: Colors.blue, isTurn: true);
    _playerTwo = Player(name: "Player2", color: Colors.red);
    _time.start();
  }

  @override
  void setActiveNumber(int value, Player? player) {
    setState(() => player?.activeNumber = value);
  }

  @override
  void handlePress(int index, int newValue, Player player) {
    if (index != -1 &&
        player != board[index].player &&
        player.isTurn &&
        board[index].value < newValue) {
      setState(() {
        board[index].value = newValue;
        board[index].player = player;
      });

      player.usedValues[newValue - 1] = true;
      player.activeNumber = -1;

      if (GameUtils.isComplete(
          board, _playerOne.usedValues, _playerTwo.usedValues)) {
        _time.stop();

        if (!(GameUtils.fullBoard(board) ||
            GameUtils.isNoMoreMoves(_playerOne.usedValues) &&
                GameUtils.isNoMoreMoves(_playerTwo.usedValues))) {
          player.winner = true;
        }

        String winner = player.winner ? player.toString() : "No one";

        // TODO Who won? if board isFull the both lost!
        GameUtils.setData(false, _time); // TODO
        showDialog(
            context: context,
            builder: (BuildContext context) => CompleteAlert(
                  title: "$winner won the match",
                  text: "Rematch?",
                  navigator: "/lmp_game",
                ));
      } else {
        GameUtils.switchTurn(_playerOne, _playerTwo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Local multiplayer game",
      body: Column(
        children: [
          _playerTwo.isTurn
              ? const Icon(Icons.arrow_upward_sharp)
              : const Text(""), // TODO Improve
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: SelectButtons(
              setActiveNumber: setActiveNumber,
              values: _playerTwo.usedValues,
              buttonColor: _playerTwo.color,
              player: _playerTwo,
              offsetUp: false,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Board(
                pressHandler: handlePress,
                activeNumber: _playerOne.isTurn
                    ? _playerOne.activeNumber
                    : _playerTwo.activeNumber,
                activePlayer: _playerOne.isTurn ? _playerOne : _playerTwo,
                board: board,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: SelectButtons(
              setActiveNumber: setActiveNumber,
              values: _playerOne.usedValues,
              player: _playerOne,
            ),
          ),
          _playerOne.isTurn
              ? const Icon(Icons.arrow_downward_sharp)
              : const Text(""), // TODO Improve
        ],
      ),
    );
  }
}
