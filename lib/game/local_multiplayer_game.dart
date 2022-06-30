import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/square_object.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/stats.dart';
import 'package:tic_tac_toe_upgraded/widgets/board.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../objects/player.dart';
import '../widgets/blur.dart';
import 'game.dart';

class LocalMultiplayerGame extends StatefulWidget {
  const LocalMultiplayerGame({super.key});

  static bool rotateGlobal = true;

  @override
  State<LocalMultiplayerGame> createState() => _LocalMultiplayerGameState();
}

class _LocalMultiplayerGameState extends State<LocalMultiplayerGame>
    implements Game {
  @override
  List<SquareObject> board = List.generate(
      GameUtils.boardLength, (index) => SquareObject(index: index));

  late Player _playerOne, _playerTwo;
  final _time = Stopwatch();
  bool _rotate = false;

  // TODO random player starts

  _LocalMultiplayerGameState() {
    _playerOne = Player(
        name: "Player1", color: MyTheme.player1Color.color, isTurn: true);
    _playerTwo = Player(name: "Player2", color: MyTheme.player2Color.color);
    _time.start();
  }

  @override
  void handlePress(int index, num newValue, Player player) {
    if (index != -1 &&
        player != board[index].player &&
        player.isTurn &&
        board[index].value < newValue) {
      setState(() {
        board[index].value = newValue;
        board[index].player = player;
      });

      player.usedValues[(newValue as int) - 1] = true;
      player.activeNumber = -1;

      if (GameUtils.isComplete(
          board, _playerOne.usedValues, _playerTwo.usedValues)) {
        _time.stop();

        late final Player? winner;
        // TODO Mark the winning area
        if (GameUtils.isThreeInARow(board)) {
          winner = player;
        } else {
          winner = null;
        }

        String winnerString = winner != null ? player.toString() : "No one";

        GameUtils.setData(winner == _playerOne, _time,
            timePlayed: StatData.timePlayed.lmp,
            gamesWon: StatData.gamesWon.lmp,
            gamesPlayed: StatData.gamesPlayed.lmp);
        showDialog(
            context: context,
            builder: (BuildContext context) => CompleteAlert(
                  title: "$winnerString won the match",
                  text: "Rematch?",
                  navigator: Nav.lmp.route,
                ));
      } else {
        GameUtils.switchTurn(_playerOne, _playerTwo);
        setState(() => _rotate = !_rotate);
      }
    }
  }

  final marginVertical = 30.0;
  final _offset = const Offset(0, -20); // TODO animate movement

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Local multiplayer game",
      body: Column(
        children: [
          _playerTwo.isTurn ? Blur(color: _playerTwo.color) : const Blur(),
          Container(
            margin: EdgeInsets.symmetric(vertical: marginVertical),
            child: SelectButtons(
              player: _playerTwo,
              rotate: _rotate && LocalMultiplayerGame.rotateGlobal,
              offsetOnActivate: _offset,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Board(
                onPressed: handlePress,
                activePlayer: _playerOne.isTurn ? _playerOne : _playerTwo,
                board: board,
                rotate: _rotate && LocalMultiplayerGame.rotateGlobal,
                squareSize: 100,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: marginVertical),
            child: SelectButtons(
              player: _playerOne,
              rotate: _rotate && LocalMultiplayerGame.rotateGlobal,
              offsetOnActivate: _offset,
            ),
          ),
          _playerOne.isTurn ? Blur(color: _playerOne.color) : const Blur(),
        ],
      ),
    );
  }
}
