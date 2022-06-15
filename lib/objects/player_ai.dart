import 'package:tic_tac_toe_upgraded/objects/game_button.dart';
import 'package:tic_tac_toe_upgraded/objects/player.dart';

class PlayerAI extends Player {
  PlayerAI(
      {this.handleMove,
      super.name,
      super.color,
      super.activeNumber,
      super.isTurn,});

  /// The [Function] that will be called from the [PlayerAI]
  final Function? handleMove;

  /// Finds an unused value and a spot to place it, then calls [handleMove]
  void nextMove(List<GameButton> board) {
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
    handleMove!(index, useValue, this);
  }
}
