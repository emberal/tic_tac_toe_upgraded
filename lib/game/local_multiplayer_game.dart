import 'dart:math' show Random;

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

  /// If 'true' rotation animations will be used when switching [Player]'s. 'true' by default
  static bool rotateGlobal = true;

  /// If 'true' will return an object that has been placed on the board, back to the [Player] if the opponent takes it
  static bool returnObjectToPlayer = false;

  @override
  State<LocalMultiplayerGame> createState() => _LocalMultiplayerGameState();
}

class _LocalMultiplayerGameState extends State<LocalMultiplayerGame>
    implements Game {
  @override
  List<SquareObject> board = List.generate(
      GameUtils.boardLength, (index) => SquareObject(index: index));

  late Player _playerOne, _playerTwo;

  /// The timer that counts the time
  final _time = Stopwatch();

  /// Activates the rotations on the board, [LocalMultiplayerGame.rotateGlobal] also needs to be 'true'
  bool _rotate = false;

  @override
  void initState() {
    super.initState();
    final starts = Random().nextBool();
    _rotate = !starts;
    _playerOne = Player(
        name: "Player1", color: MyTheme.player1Color.color, isTurn: starts);
    _playerTwo = Player(
        name: "Player2", color: MyTheme.player2Color.color, isTurn: !starts);
    _time.start();
  }

  @override
  void updateState([VoidCallback? fun]) => setState(() => fun);

  /// After the [Function] is called it will change the [bool] _rotate
  void rotate() => _rotate = !_rotate;

  @override
  void switchTurn() => GameUtils.switchTurn(_playerOne, _playerTwo);

  final _marginVertical = 30.0;
  final _offset = const Offset(0, -20); // TODO animate movement?

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Local multiplayer game",
      body: Column(
        children: [
          _playerTwo.isTurn ? Blur(color: _playerTwo.color) : const Blur(),
          Container(
            margin: EdgeInsets.symmetric(vertical: _marginVertical),
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
                updateState: updateState,
                switchTurn: switchTurn,
                rotateFun: rotate,
                activePlayer: _playerOne.isTurn ? _playerOne : _playerTwo,
                board: board,
                rotate: _rotate && LocalMultiplayerGame.rotateGlobal,
                navigator: Nav.lmp.route,
                squareSize: 100,
                time: _time,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: _marginVertical),
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
