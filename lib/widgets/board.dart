import 'package:flutter/material.dart';

import '../enums/player_enum.dart';
import '../objects/game_button.dart';

class Board extends StatelessWidget {
  const Board(
      {super.key,
      this.board,
      this.size = 3,
      this.pressHandler,
      this.activeNumber = -1});

  final List<GameButton>? board;
  final int size;
  final Function? pressHandler;
  final int activeNumber;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: size,
      children: board!
          .map(
            (element) => Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: element.index % 3 == 1
                        ? const BorderSide()
                        : BorderSide.none,
                    horizontal: element.index >= 3 && element.index <= 5
                        ? const BorderSide()
                        : BorderSide.none),
              ),
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: element.player != Player.blue
                        ? element.player.color
                        : Theme.of(context).primaryColor,
                    minimumSize: const Size(50, 50),
                    maximumSize: const Size(64, 64),
                  ),
                  child: Text(
                    "${element.value}",
                    style: TextStyle(
                        // TODO better dynamic background colour
                        color: element.player != Player.none
                            ? Colors.white
                            : Colors.black),
                  ),
                  onPressed: () => activeNumber == -1
                      ? null
                      : {
                          pressHandler!(
                              element.index, activeNumber, Player.blue),
                        },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
