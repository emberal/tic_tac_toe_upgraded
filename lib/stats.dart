import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

class Stats extends StatelessWidget {
  const Stats({this.gamesPlayed = 0, this.gamesWon = 0, this.timePlayed = 0, super.key});

  final int gamesPlayed, gamesWon, timePlayed; // Implied games lost

  @override
  Widget build(BuildContext context) {
    return const Layout(

    );
  }
}
