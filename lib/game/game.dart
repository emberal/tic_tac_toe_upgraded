import '../objects/player.dart';
import '../objects/square_object.dart';

abstract class Game {
  /// The values of the [board] where the game is played
  late final List<SquareObject> board;

  /// Used to set the action after a [player] selects a square on the [board]
  void handlePress(int index, int value, Player player);
}
