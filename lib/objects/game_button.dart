import '../enums/player_enum.dart';

class GameButton {
  GameButton({required this.index, this.value = 0, this.player = Player.none});

  final int index;
  int value;
  Player player;
}

