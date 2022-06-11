import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  int gamesPlayed = 0, gamesWon = 0; // Implied games lost
  Duration timePlayed = const Duration();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  /// Gets the data from the device's local-storage
  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gamesPlayed = prefs.getInt("games-played") ?? 0;
      gamesWon = prefs.getInt("games-won") ?? 0;
      timePlayed = Duration(seconds: prefs.getInt("time-played") ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatsText(
              "Games played: $gamesPlayed",
            ),
            _StatsText(
              "Games won: $gamesWon",
            ),
            _StatsText(
              "Time played: ${timePlayed.inMinutes} minutes",
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsText extends StatelessWidget {
  const _StatsText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(fontSize: 20),
    );
  }
}
