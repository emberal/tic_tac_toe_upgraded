import 'package:flutter/material.dart';

import '../objects/player.dart';
import '../objects/theme.dart';

class Board extends StatelessWidget {
  const Board(
      {super.key,
      this.board,
      this.width = 3,
      this.pressHandler,
      this.activePlayer,
      this.rotation = 0});

  /// A [List] of objects that will be placed on the [board]
  final List<dynamic>? board;

  /// The [width] of the [board]
  final int width;

  /// The [Function] that will be called upon pressing one of the buttons on the [board]
  final Function? pressHandler;

  /// The [Player] currently in control of the [board]
  final Player? activePlayer;

  final double rotation;

  @override
  Widget build(BuildContext context) {
    // Is true if [globalTheme] is [dark] or it's [system] and [system] is dark
    bool _isDark = MyTheme.isDark(context);
    return GridView.count(
      crossAxisCount: width,
      shrinkWrap: true,
      children: board!
          .map(
            (element) => Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: element.index % 3 == 1
                        ? BorderSide(
                            color: _isDark ? Colors.white : Colors.black)
                        : BorderSide.none,
                    horizontal: element.index >= 3 && element.index <= 5
                        ? BorderSide(
                            color: _isDark ? Colors.white : Colors.black)
                        : BorderSide.none),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: rotation,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: element.player?.color,
                      minimumSize: const Size(50, 50),
                      maximumSize: const Size(64, 64),
                    ),
                    child: Text(
                      "${element.value}",
                      style: TextStyle(
                        // TODO better dynamic background colour
                        color: _isDark
                            ? Colors.white
                            : element.player != null
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    onPressed: () =>
                        activePlayer != null && activePlayer!.activeNumber == -1
                            ? null
                            : pressHandler!(element.index,
                                activePlayer?.activeNumber, activePlayer),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
