import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int gamesPlayedSp = 0,
      gamesWonSp = 0,
      gamesPlayedLmp = 0,
      gamesWonLmp = 0,
      gamesPlayedMp = 0,
      gamesWonMp = 0;
  late Duration timePlayedSp = const Duration(),
      timePlayedLmp = const Duration(),
      timePlayedMp = const Duration();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  /// Gets the data from the device's local-storage
  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gamesPlayedSp = prefs.getInt("games-played-sp") ?? 0;
      gamesWonSp = prefs.getInt("games-won-sp") ?? 0;
      timePlayedSp = Duration(seconds: prefs.getInt("time-played-sp") ?? 0);
      gamesPlayedLmp = prefs.getInt("games-played-lmp") ?? 0;
      gamesWonLmp = prefs.getInt("games-won-lmp") ?? 0;
      timePlayedLmp = Duration(seconds: prefs.getInt("time-played-lmp") ?? 0);
      gamesPlayedMp = prefs.getInt("games-played-mp") ?? 0;
      gamesWonMp = prefs.getInt("games-won-mp") ?? 0;
      timePlayedMp = Duration(seconds: prefs.getInt("time-played-mp") ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Stats",
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: "Singleplayer",
              children: [
                _StatsText("Games played: $gamesPlayedSp"),
                _StatsText("Games won: $gamesWonSp"),
                _StatsText("Time played: ${timePlayedSp.inMinutes} minutes"),
              ],
            ),
            _Section(
              title: "Local multiplayer",
              children: [
                _StatsText("Games played: $gamesPlayedLmp"),
                _StatsText("Games won: $gamesWonLmp"),
                _StatsText("Time played: ${timePlayedLmp.inMinutes} minutes"),
              ],
            ),
            _Section(
              title: "Multiplayer",
              children: [
                _StatsText("Games played: $gamesPlayedMp"),
                _StatsText("Games won: $gamesWonMp"),
                _StatsText("Time played: ${timePlayedMp.inMinutes} minutes"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({this.title = "", this.children});

  final String title;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(title, textAlign: TextAlign.left),
          ),
          ...?children,
          const Divider(color: Colors.black),
        ],
      ),
    );
  }
}

class _StatsText extends StatelessWidget {
  const _StatsText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        data,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
