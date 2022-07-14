import 'package:flutter/material.dart' show BuildContext;
import 'package:tic_tac_toe_upgraded/objects/square_object.dart';
import 'package:tic_tac_toe_upgraded/objects/player.dart';

class PlayerAI extends Player {
  PlayerAI({
    this.handleMove,
    this.context,
    super.name,
    super.color,
    super.activeNumber,
    super.isTurn,
  });

  /// The [Function] that will be called from the [PlayerAI]
  Function? handleMove;

  BuildContext? context;

  /// Finds an unused value and a spot to place it, then calls [handleMove]
  void nextMove(List<SquareObject> board) {
    // TODO improve """AI"""
    int useValue = 0, index = -1;

    for (int i = 0; i < super.usedValues.length; i++) {
      if (!super.usedValues[i]) {
        useValue = i + 1;
        super.usedValues[i] = true;
        break;
      }
    }

    for (int i = 0; i < board.length; i++) {
      if (board[i].value < useValue && board[i].player != this) {
        index = i;
        break;
      }
    }
    if (handleMove != null && context != null) {
      handleMove!(index, useValue, this, context!);
    }
  }
}
