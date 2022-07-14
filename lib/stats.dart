import 'package:flutter/material.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart' show GameType;
import 'package:tic_tac_toe_upgraded/objects/shared_prefs.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
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

  List<dynamic> _stats = [];

  @override
  void initState() {
    _getData();
    _stats = [
      [GameType.singlePlayer.name, gamesPlayedSp, gamesWonSp, timePlayedSp],
      [
        GameType.localMultiplayer.name,
        gamesPlayedLmp,
        gamesWonLmp,
        timePlayedLmp
      ],
      [GameType.multiplayer.name, gamesPlayedMp, gamesWonMp, timePlayedMp]
    ];
    super.initState();
  }

  /// Gets the data from the device's local-storage
  void _getData() {
    setState(() {
      gamesPlayedSp = MyPrefs.getInt(GameType.singlePlayer.gamesPlayed);
      gamesWonSp = MyPrefs.getInt(GameType.singlePlayer.gamesWon);
      timePlayedSp =
          Duration(seconds: MyPrefs.getInt(GameType.singlePlayer.timePlayed));
      gamesPlayedLmp = MyPrefs.getInt(GameType.localMultiplayer.gamesPlayed);
      gamesWonLmp = MyPrefs.getInt(GameType.localMultiplayer.gamesWon);
      timePlayedLmp = Duration(
          seconds: MyPrefs.getInt(GameType.localMultiplayer.timePlayed));
      gamesPlayedMp = MyPrefs.getInt(GameType.multiplayer.gamesPlayed);
      gamesWonMp = MyPrefs.getInt(GameType.multiplayer.gamesWon);
      timePlayedMp =
          Duration(seconds: MyPrefs.getInt(GameType.multiplayer.timePlayed));
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
            ..._stats
                .map(
                  (e) => _Section(
                    title: e[0],
                    children: [
                      _StatsText("Games played: ${e[1]}"),
                      _StatsText("Games won: ${e[2]}"),
                      _StatsText(
                          "Time played: ${e[3].inMinutes} minute${e[3].inMinutes != 1 ? "s" : ""}"),
                    ],
                  ),
                )
                .toList(),
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

  /// The text to be displayed
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
