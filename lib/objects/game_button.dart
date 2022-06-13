import '../objects/player.dart';

class GameButton {
  GameButton({required this.index, this.value = 0, this.player});

  final int index;
  int value;
  Player? player;
}

