import '../enums/player_enum.dart';
import '../objects/game_button.dart';

abstract class Game {

  late final List<GameButton> board;
  late Player winner;

  /// Used to set a [Player]'s selected value
  void setActiveNumber(int value, Player player);

  /// Used to set the action after a [Player] selects a square on the [Board]
  void handlePress(int index, int value, Player player);
}