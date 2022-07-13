import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/game/local_multiplayer_game.dart';
import 'package:tic_tac_toe_upgraded/objects/shared_prefs.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/stats.dart';
import 'package:tic_tac_toe_upgraded/widgets/fullscreen_dialog.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

enum SettingsKey {
  rotate("rotate-lmp"),
  returnObject("return-object-lmp");

  const SettingsKey(this.key);

  final String key;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, this.themeModeCallback, this.colorPickerDialog});

  /// Changes the [ThemeMode] to 'light', 'dark' or 'system'
  final Function(ThemeMode)? themeModeCallback;

  /// changes various themes around the app
  final Function? colorPickerDialog;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _setTheme() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => FullScreenDialog(
            title: "Change theme", colorPickerDialog: widget.colorPickerDialog),
        fullscreenDialog: true,
      ),
    );
  }

  void _setDarkTheme() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Dark theme"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back"),
          ),
        ],
        content: Container(
          constraints: const BoxConstraints(),
          width: 200,
          child: ListView(
            shrinkWrap: true,
            children: [
              _DialogOption(
                onChanged: widget.themeModeCallback,
                value: ThemeMode.system,
                text: "Follow system",
                icon: Icons.brightness_4,
              ),
              _DialogOption(
                onChanged: widget.themeModeCallback,
                value: ThemeMode.light,
                text: "Light theme",
                icon: Icons.sunny,
              ),
              _DialogOption(
                onChanged: widget.themeModeCallback,
                value: ThemeMode.dark,
                text: "Dark theme",
                icon: Icons.dark_mode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteData() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete data", style: TextStyle(color: Colors.red)),
        content: const Text("Are you sure you want to delete all data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                MyPrefs.remove(
                    keys: SettingsKey.values.map((e) => e.key).toList());
                MyPrefs.remove(
                    keys: GameType.values.map((e) => e.gamesWon).toList());
                MyPrefs.remove(
                    keys: GameType.values.map((e) => e.gamesPlayed).toList());
                MyPrefs.remove(
                    keys: GameType.values.map((e) => e.timePlayed).toList());
                MyPrefs.remove(
                    keys: ThemeId.values
                        .map((e) => e.both != null ? e.both! : "")
                        .toList());
                MyPrefs.remove(
                    keys: ThemeId.values
                        .map((e) => e.light != null ? e.light! : "")
                        .toList());
                MyPrefs.remove(
                    keys: ThemeId.values
                        .map((e) => e.dark != null ? e.dark! : "")
                        .toList());
                if (widget.themeModeCallback != null) {
                  // Immediately resets darkMode to system
                  widget.themeModeCallback!(ThemeMode.system);
                }
              },
              child: const Text("Ok")),
        ],
      ),
    );
  }

  void _toggleRotation() {
    setState(() {
      LocalMultiplayerGame.rotateGlobal = !LocalMultiplayerGame.rotateGlobal;
    });
    MyPrefs.setBool(SettingsKey.rotate.key, LocalMultiplayerGame.rotateGlobal);
  }

  void _toggleReturnToPlayer() {
    setState(() {
      LocalMultiplayerGame.returnObjectToPlayer =
          !LocalMultiplayerGame.returnObjectToPlayer;
    });
    MyPrefs.setBool(SettingsKey.returnObject.key,
        LocalMultiplayerGame.returnObjectToPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Settings",
      showMenuButton: false,
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Theme"),
            tiles: [
              // Change theme
              SettingsTile.navigation(
                title: const Text("Change theme"),
                leading: const Icon(Icons.color_lens),
                onPressed: (context) => _setTheme(),
              ),
              // Toggle dark theme
              SettingsTile(
                title: const Text("Dark theme"),
                leading: const Icon(Icons.dark_mode),
                onPressed: (context) => _setDarkTheme(),
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Local multiplayer"),
            tiles: [
              SettingsTile.switchTile(
                title: const Text("Rotate between turns"),
                leading: const Icon(Icons.change_circle),
                initialValue: LocalMultiplayerGame.rotateGlobal,
                onToggle: (context) => _toggleRotation(),
                activeSwitchColor: MyTheme.isDark(context)
                    ? MyTheme.primaryColorsDark.color
                    : MyTheme.primaryColorsLight.color,
              ),
              SettingsTile.switchTile(
                title: const Text(
                  "Return object to player if opponent takes it",
                ),
                leading: const Icon(Icons.lock_reset),
                initialValue: LocalMultiplayerGame.returnObjectToPlayer,
                onToggle: (context) => _toggleReturnToPlayer(),
                activeSwitchColor: MyTheme.isDark(context)
                    ? MyTheme.primaryColorsDark.color
                    : MyTheme.primaryColorsLight.color,
              ),
            ],
          ),
          // Delete all data
          SettingsSection(
            title: const Text("Other"),
            tiles: [
              SettingsTile(
                title: const Text(
                  "Delete all data",
                  style: TextStyle(color: Colors.red),
                ),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: (context) => _deleteData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialogOption extends StatelessWidget {
  const _DialogOption(
      {this.onChanged, this.icon, this.text = "", required this.value});

  final Function(ThemeMode)? onChanged;
  final IconData? icon;
  final String text;
  final ThemeMode value;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onChanged != null ? () => onChanged!(value) : null,
      child: Row(
        children: [
          Icon(icon),
          Radio(
            value: value,
            groupValue: MyTheme.globalTheme,
            onChanged: (v) => onChanged!(value),
            activeColor: MyTheme.isDark(context)
                ? MyTheme.primaryColorsDark.color
                : MyTheme.primaryColorsLight.color,
          ),
          Text(text),
        ],
      ),
    );
  }
}
