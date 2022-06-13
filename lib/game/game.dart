import '../objects/player.dart';
import '../objects/game_button.dart';

abstract class Game {
  /// The values of the [board] where the game is played
  late final List<GameButton> board;

  /// Sets a [player]'s chosen value
  void setActiveNumber(int value, Player? player);

  /// Used to set the action after a [player] selects a square on the [board]
  void handlePress(int index, int value, Player player);
}
