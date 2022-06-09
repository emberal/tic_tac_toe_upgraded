import 'package:flutter/material.dart';

enum Player {
  none(null),
  red(Colors.red),
  blue(Colors.lightBlueAccent);

  const Player(this.color);

  final Color? color;
}
