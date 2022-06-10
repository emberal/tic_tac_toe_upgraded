import '../enums/player_enum.dart';

class PlayerRed {
  var _used;
  final Function? handleMove;

  PlayerRed(this.handleMove) {
    _used = List.filled(5, false);
  }

  void nextMove() {
    int useValue = 0;
    for (int i = 0; i < _used.length; i++) {
      if (!_used[i]) {
        useValue = i;
        break;
      }
    }
    handleMove!(useValue, Player.red); // TODO fix errors
  }
}