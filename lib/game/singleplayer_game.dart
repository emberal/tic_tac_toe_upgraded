import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/player_ai.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/stats.dart';
import 'package:tic_tac_toe_upgraded/widgets/complete_alert.dart';
import 'package:tic_tac_toe_upgraded/widgets/select_buttons.dart';

import '../objects/player.dart';
import '../widgets/board.dart';
import '../widgets/layout.dart';
import '../objects/square_object.dart';

class SinglePlayerGamePage extends StatefulWidget {
  const SinglePlayerGamePage({super.key});

  @override
  State<SinglePlayerGamePage> createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage>
    implements Game {
  @override
  List<SquareObject> board =
      List.generate(GameUtils.boardLength, (index) => SquareObject(index: index));

  late Player _player;
  late PlayerAI _playerAI;
  final _time = Stopwatch(); // Used to time the matches

  _SinglePlayerGamePageState() {
    _player = Player(
        name: "Player1", color: MyTheme.player1Color.color, isTurn: true);
    _playerAI = PlayerAI(
        handleMove: handlePress, name: "AI", color: MyTheme.player2Color.color);
    _time.start();
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

      player.usedValues[value - 1] = true;
      player.activeNumber = -1;

      if (GameUtils.isComplete(
          board, _player.usedValues, _playerAI.usedValues)) {
        _time.stop();

        // TODO mark the winning area
        final winner = player;
        GameUtils.setData(winner == _player, _time,
            gamesPlayed: StatData.gamesPlayed.sp,
            gamesWon: StatData.gamesWon.sp,
            timePlayed: StatData.timePlayed.sp);

        showDialog(
          context: context,
          builder: (BuildContext context) => CompleteAlert(
            title: winner != _playerAI ? "Congratulations" : "You lost",
            text: winner != _playerAI ? "You win!" : "Better luck next time",
            navigator: Nav.sp.route,
          ),
        );
      } else {
        GameUtils.switchTurn(_player, _playerAI);
        if (_playerAI.isTurn) {
          _playerAI.nextMove(board); // Starts the other players move
        }
      }
    }
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
                  activePlayer: _player.isTurn ? _player : _playerAI,
                  otherPlayer: _player.isTurn ? _playerAI : _player,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: SelectButtons(
              player: _player,
              offsetOnActivate: const Offset(0, -20),
            ),
          ),
        ],
      ),
    );
  }
}
