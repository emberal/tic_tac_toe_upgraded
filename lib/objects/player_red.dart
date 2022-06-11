import '../enums/player_enum.dart';

class PlayerRed {
  var _used;
  final Function? handleMove;

  PlayerRed(this.handleMove) {
    _used = List.filled(5, false);
  }

  void nextMove(List<dynamic> board) {
    // TODO improve """AI"""
    int useValue = 0, index = -1;

    for (int i = 0; i < _used.length; i++) {
      if (!_used[i]) {
        useValue = i + 1;
        _used[i] = true;
        break;
      }
    }

    for (int i = 0; i < board.length; i++) {
      if (board[i].value < useValue && board[i].player != Player.red) {
        index = i;
        break;
      }
    }
    handleMove!(index, useValue, Player.red);
  }
}
