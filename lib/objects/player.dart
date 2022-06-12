import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/main.dart';

class Player { // TODO switch enum with this
  Player({this.color, this.activeNumber = -1, this.winner = false});

  late final Color? color;
  int activeNumber;
  bool winner;

  final List<bool> usedValues = List.filled(MyApp.values, false);

}