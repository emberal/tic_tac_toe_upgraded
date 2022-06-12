import 'package:flutter/material.dart';

enum Player {
  none(null),
  two(Colors.red),
  one(Colors.lightBlueAccent);

  const Player(this.color);

  final Color? color;
}
