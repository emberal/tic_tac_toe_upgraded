import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

enum StatData {
  gamesPlayed("games-played-sp", "games-played-lmp", "games-played-mp"),
  gamesWon("games-won-sp", "games-won-lmp", "games-won-mp"),
  timePlayed("time-played-sp", "time-played-lmp", "time-played-mp");

  const StatData(this.sp, this.lmp, this.mp);

  final String sp;
  final String lmp;
  final String mp;
}

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
    _getData();
    super.initState();
  }

  /// Gets the data from the device's local-storage
  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gamesPlayedSp = prefs.getInt(StatData.gamesPlayed.sp) ?? 0;
      gamesWonSp = prefs.getInt(StatData.gamesWon.sp) ?? 0;
      timePlayedSp =
          Duration(seconds: prefs.getInt(StatData.timePlayed.sp) ?? 0);
      gamesPlayedLmp = prefs.getInt(StatData.gamesPlayed.lmp) ?? 0;
      gamesWonLmp = prefs.getInt(StatData.gamesWon.lmp) ?? 0;
      timePlayedLmp =
          Duration(seconds: prefs.getInt(StatData.timePlayed.lmp) ?? 0);
      gamesPlayedMp = prefs.getInt(StatData.gamesPlayed.mp) ?? 0;
      gamesWonMp = prefs.getInt(StatData.gamesWon.mp) ?? 0;
      timePlayedMp =
          Duration(seconds: prefs.getInt(StatData.timePlayed.mp) ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Stats",
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...?children,
          Divider(
            color: MyTheme.isDark(context) ? Colors.white : Colors.black,
          ),
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
