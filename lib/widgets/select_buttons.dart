import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:tic_tac_toe_upgraded/main.dart';
import 'package:tic_tac_toe_upgraded/objects/player_ai.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';

import '../objects/player.dart';

// TODO drag and drop buttons to the correct position

class SelectButtons extends StatefulWidget {
  const SelectButtons(
      {super.key,
      this.values,
      this.setActiveNumber,
      this.buttonColor,
      this.player,
      this.offsetUp = true});

  /// A [List] of [bool] describing which values have been used
  @Deprecated("Unnecessary")
  final List<bool>? values;

  /// A [Function] that's called when one of the buttons are pressed
  final Function? setActiveNumber;

  /// The [Color] of the buttons
  @Deprecated("Unnecessary")
  final Color? buttonColor;

  /// The [Player] that will use the buttons
  final Player? player;

  /// Whether the selected button will be pushed up or down, if 'true' it will
  /// be pushed up, otherwise down
  final bool offsetUp;

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...?widget.player?.usedValues
            .mapIndexed(
              (index, value) => Container(
                margin: const EdgeInsets.all(10),
                child: Transform.translate(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                      maximumSize: const Size(64, 64),
                      primary: widget.player?.color,
                    ),
                    // If a value has been used already, do nothing
                    onPressed: widget.player == null ||
                            widget.player! is PlayerAI ||
                            value
                        ? null
                        : () =>
                            widget.setActiveNumber!(index + 1, widget.player),
                    child: Text("${index + 1}"),
                  ),
                  offset: widget.player?.activeNumber == index + 1
                      ? Offset(0, widget.offsetUp ? -20 : 20)
                      : const Offset(0, 0),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
