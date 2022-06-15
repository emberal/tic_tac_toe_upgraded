import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/main.dart';

class Player {
  Player(
      {this.name,
      this.color,
      this.activeNumber = -1,
      this.isTurn = false});

  /// The [name] of the [Player]
  String? name;

  /// The [Color] of the [Player]
  Color? color;

  /// The current selected number
  int activeNumber;

  /// If it's the [Player]'s turn
  bool isTurn;

  /// A [List] of [bool] describing which values have been used
  final List<bool> usedValues = List.filled(GameUtils.numberOfValues, false);

  @override
  String toString() => "$name";

}
