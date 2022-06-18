import 'dart:math';

import 'package:flutter/material.dart';

import '../objects/game_button.dart';
import '../objects/player.dart';
import '../objects/theme.dart';

class Board extends StatelessWidget {
  const Board(
      {super.key,
      this.board,
      this.width = 3,
      this.pressHandler,
      this.activePlayer,
      this.rotate = false});

  /// A [List] of objects that will be placed on the [board]
  final List<dynamic>? board;

  /// The [width] of the [board]
  final int width;

  /// The [Function] that will be called upon pressing one of the buttons on the [board]
  final Function? pressHandler;

  /// The [Player] currently in control of the [board]
  final Player? activePlayer;

  final bool rotate;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: width,
      shrinkWrap: true,
      children: board!
          .map(
            (element) => _Square(
              object: element,
              activePlayer: activePlayer,
              onPressed: pressHandler,
              rotate: rotate,
            ),
          )
          .toList(),
    );
  }
}

class _Square extends StatefulWidget {
  const _Square(
      {super.key,
      required this.object,
      this.activePlayer,
      this.onPressed,
      this.rotate = false});

  final GameButton object;

  final Player? activePlayer;

  final Function? onPressed;

  /// Activate the rotate [Animation]
  final bool rotate;

  @override
  State<_Square> createState() => __SquareState();
}

class __SquareState extends State<_Square> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  var rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: pi).animate(_controller)
      ..addListener(() => setState(() => rotation = _animation.value));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotate) {
      _controller.forward();
    } else if (rotation == pi) {
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
          angle: rotation,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: widget.object.player?.color,
              minimumSize: const Size(50, 50),
              maximumSize: const Size(64, 64),
            ),
            child: Text(
              "${widget.object.value}",
              style: TextStyle(
                // TODO better dynamic background colour
                color: _isDark
                    ? Colors.white
                    : widget.object.player != null
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
  }
}
