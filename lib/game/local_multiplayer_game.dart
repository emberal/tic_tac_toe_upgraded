import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/game_button.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/board.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../objects/player.dart';
import '../widgets/blur.dart';
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
      List.generate(GameUtils.boardLength, (index) => GameButton(index: index));

  late Player _playerOne, _playerTwo;
  final _time = Stopwatch();

  _LocalMultiplayerGameState() {
    _playerOne = Player(name: "Player1", color: MyTheme.player1Color, isTurn: true);
    _playerTwo = Player(name: "Player2", color: MyTheme.player2Color);
    _time.start();
  }

  @override
  void setActiveNumber(int value, Player? player) {
    if (player != null && player.isTurn) {
      setState(() => player.activeNumber = value);
    }
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

        late final Player? winner;
        // TODO Mark the winning area
        if (GameUtils.isThreeInARow(board)) {
          winner = player;
        }
        else {
          winner = null;
        }

        String winnerString = winner != null ? player.toString() : "No one";

        GameUtils.setData(winner == _playerOne, _time,
            timePlayed: "time-played-lmp",
            gamesWon: "games-won-lmp",
            gamesPlayed: "games-played-lmp");
        showDialog(
            context: context,
            builder: (BuildContext context) => CompleteAlert(
                  title: "$winnerString won the match",
                  text: "Rematch?",
                  navigator: "/lmp_game",
                ));
      } else {
        GameUtils.switchTurn(_playerOne, _playerTwo);
      }
    }
  }

  final marginVertical = 30.0;

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
              setActiveNumber: setActiveNumber,
              player: _playerTwo,
              offsetUp: false,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Board(
                pressHandler: handlePress,
                activePlayer: _playerOne.isTurn ? _playerOne : _playerTwo,
                board: board,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: marginVertical),
            child: SelectButtons(
              setActiveNumber: setActiveNumber,
              player: _playerOne,
            ),
          ),
          _playerOne.isTurn ? Blur(color: _playerOne.color) : const Blur(),
        ],
      ),
    );
  }
}
