import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';

class Player {
  Player({this.name, this.color, this.activeNumber = -1, this.isTurn = false});

  /// The [name] of the [Player]
  String? name;

  /// The [color] of the [Player]
  Color? color;

  /// The [Player]'s selected number
  num activeNumber;

  /// If it's the [Player]'s turn
  bool isTurn;

  /// A [List] describing which values have been used, if 'true', the value is already used
  final List<bool> usedValues = List.filled(GameUtils.numberOfValues, false);

  @override
  String toString() => "$name";
}
