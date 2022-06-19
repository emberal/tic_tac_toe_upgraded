import '../objects/player.dart';

class SquareObject {
  SquareObject({required this.index, this.value = 0, this.player});

  /// The [index] of the square
  final int index;

  /// The [value] of the square
  num value;

  /// The [player] currently occupying the square
  Player? player;
}
