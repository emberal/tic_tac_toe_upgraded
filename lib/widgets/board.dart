import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/objects/player_ai.dart';

import '../game/local_multiplayer_game.dart';
import '../objects/square_object.dart';
import '../objects/player.dart';
import '../objects/theme.dart';
import '../stats.dart';
import 'complete_alert.dart';

class Board extends StatelessWidget {
  const Board(
      {super.key,
      this.board,
      this.width = 3,
      this.updateState,
      this.switchTurn,
      this.rotateFun,
      this.activePlayer,
      this.ai,
      this.rotate = false,
      this.squareSize = 50,
      this.time,
      this.navigator = "/"});

  /// A [List] of objects that will be placed on the [board]
  final List<dynamic>? board;

  /// The [width] of the [board]
  final int width;

  /// A [Function] that when called, will update the state of the widget it's in, and it's children
  final Function? updateState;

  /// A [Function] that's called at the end of the round, must be used to change whoose [Player]'s turn it is
  final VoidCallback? switchTurn;

  /// A [Function] used to change the [rotate] variable
  final VoidCallback? rotateFun;

  /// The [Player] currently in control of the [board]
  final Player? activePlayer;

  /// If one of the [Player]'s is an AI, this must be set, so that the AI may call the handlePress [Function] and get's the correct [context]
  final PlayerAI? ai;

  /// If 'true' all the squares in the board will rotate 180 degrees immediately
  final bool rotate;

  /// The size of a single square in the grid
  final double squareSize;

  /// The timer used for the game
  final Stopwatch? time;

  /// Where to navigate the user to if he / she chooses a new game
  final String navigator;

  /// The [Function] is called when a [player] presses a button on the board, or drops a [Draggable]
  /// The [index] refers to the index position on the [Board], from 0 - 8, if [index] is -1, no square has been selected
  /// The [value] refers to the given value of the [Button] that will be placed on the [Board]. The value
  /// is only placed on the board if the existing value is 0 or lower than the new value and placed by a different [player]
  void handlePress(int index, num newValue, Player player, BuildContext context) {
    assert(board != null);

    final square = board![index];
    if (index != -1 && player != square.player && square.value < newValue) {
      if (updateState != null) {
        updateState!(() {});
      }
      if (LocalMultiplayerGame.returnObjectToPlayer && // TODO only use this condition if it's a lmp game
          square.player != null) {
        square.player!.usedValues[(square.value as int) - 1] = false;
      }
      square.value = newValue;
      square.player = player;

      player.usedValues[(newValue as int) - 1] = true;
      player.activeNumber = -1;

      if (GameUtils.isComplete(
          board as List<SquareObject>, // TODO
          activePlayer!.usedValues,
          activePlayer!.usedValues)) {
        // TODO mark as complete if there are more objects but nowhere to place them, eg a player has only 1 left
        if (time != null) {
          time!.stop(); // TODO check if timer is running!
        }

        late final Player? winner;
        // TODO Mark the winning area
        if (GameUtils.isThreeInARow(board as List<SquareObject>)) {
          winner = player;
        } else {
          winner = null;
        }

        String winnerString = winner != null ? player.toString() : "No one";

        // TODO update correct data, depending on what game is played!
        GameUtils.setData(winner!.name == "player1", time ?? Stopwatch(),
            timePlayed: StatData.timePlayed.lmp,
            gamesWon: StatData.gamesWon.lmp,
            gamesPlayed: StatData.gamesPlayed.lmp);
        showDialog(
          context: context,
          builder: (BuildContext context) => CompleteAlert(
            title: "$winnerString won the match",
            text: "Rematch?",
            navigator: navigator,
          ),
        );
      } else {
        if (switchTurn != null) {
          switchTurn!();
        }
        if (switchTurn != null && rotateFun != null) {
          rotateFun!();
          updateState!(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if (ai != null) {
      ai!.handleMove = handlePress;
      ai!.context = context;
    }

    List<List<dynamic>> _rows = [];
    if (board != null) {
      int i = 0;
      for (; i < board!.length; i += width) {
        if (i + width > board!.length) {
          _rows.add(board!.sublist(i, board!.length));
        } else {
          _rows.add(board!.sublist(i, i + width));
        }
      }
    }

    /// The [Function] is called when a [player] presses a button on the board, or drops a [Draggable]
    /// The [index] refers to the index position on the [Board], from 0 - 8, if [index] is -1, no square has been selected
    /// The [value] refers to the given value of the [Button] that will be placed on the [Board]. The value
    /// is only placed on the board if the existing value is 0 or lower than the new value and placed by a different [player]
    void _handlePress(int index, num newValue, Player player) {
      return handlePress(index, newValue, player, context);
    }

    final _deviceHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: (squareSize + _deviceHeight * 0.015) * 3,
      height: (squareSize + _deviceHeight * 0.001) * 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._rows.map(
            (list) => Row(
              children: [
                ...list.map(
                  (object) => SizedBox(
                    width: squareSize + _deviceHeight * 0.015,
                    height: squareSize + _deviceHeight * 0.001,
                    child: _Square(
                      object: object,
                      onPressed: _handlePress,
                      activePlayer: activePlayer,
                      rotate: rotate,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Square extends StatefulWidget {
  const _Square(
      {required this.object,
      this.activePlayer,
      this.onPressed,
      this.rotate = false});

  /// An [object] containing data of the square
  final SquareObject object;

  /// The currently playing [Player]
  final Player? activePlayer;

  /// The [Function] that's called when a square is pressed, or a [Draggable] is dropped on it
  final Function? onPressed;

  /// Activate the rotate [Animation]
  final bool rotate;

  @override
  State<_Square> createState() => __SquareState();
}

class __SquareState extends State<_Square> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: GameUtils.rotationAnimation),
    );
    _animation = Tween(begin: 0.0, end: pi).animate(_controller)
      ..addListener(() => setState(() => _animation.value));
    _rotateWidget();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rotateWidget();
  }

  void _rotateWidget() {
    if (widget.rotate) {
      _controller.forward();
    } else if (_animation.value == pi) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Is true if [globalTheme] is [dark] or it's [system] and [system] is dark
    bool _isDark = MyTheme.isDark(context);
    return DragTarget(
      builder: (BuildContext context, List<dynamic> accepted,
          List<dynamic> rejected) {
        return Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: widget.object.index % 3 == 1
                    ? BorderSide(color: _isDark ? Colors.white : Colors.black)
                    : BorderSide.none,
                horizontal: widget.object.index >= 3 && widget.object.index <= 5
                    ? BorderSide(color: _isDark ? Colors.white : Colors.black)
                    : BorderSide.none),
          ),
          child: Center(
            child: Transform.rotate(
              angle: _animation.value,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: widget.object.player?.color,
                  minimumSize: const Size(50, 50),
                  maximumSize: const Size(64, 64),
                ),
                child: Text(
                  "${widget.object.value}",
                  style: TextStyle(
                    color: widget.object.player != null
                        ? MyTheme.contrast(widget.object.player!.color)
                        : _isDark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onPressed: () => widget.activePlayer != null &&
                        widget.activePlayer!.activeNumber == -1
                    ? null
                    : widget.onPressed!(widget.object.index,
                        widget.activePlayer?.activeNumber, widget.activePlayer),
              ),
            ),
          ),
        );
      },
      onWillAccept: (data) => [1, 2, 3, 4, 5].any((element) => element == data),
      onAccept: widget.onPressed != null
          ? (data) =>
              widget.onPressed!(widget.object.index, data, widget.activePlayer)
          : null,
    );
  }
}
