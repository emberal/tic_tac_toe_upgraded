import 'package:flutter/material.dart' show VoidCallback;

import '../objects/square_object.dart';

abstract class Game {
  /// The values of the [board] where the game is played
  late final List<SquareObject> board;

  /// A [Function] that have to update the state it's placed in
  void updateState([VoidCallback? fun]);

  /// Has to change the [isTurn] value in both [Player] objects
  void switchTurn();
}
