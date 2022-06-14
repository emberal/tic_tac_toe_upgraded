import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _setTheme() {}

  void _setDarkTheme() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: const Text("Dark theme"),
              children: [
                SimpleDialogOption(
                  onPressed: null, // TODO
                  child: Row(
                    children: [
                      const Icon(Icons.brightness_4),
                      Container(margin: const EdgeInsets.symmetric(horizontal: 10)),
                      const Text("Follow system"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: null, // TODO
                  child: Row(
                    children: [
                      const Icon(Icons.sunny),
                      Container(margin: const EdgeInsets.symmetric(horizontal: 10)),
                      const Text("Light theme"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: null, // TODO
                  child: Row(
                    children: [
                      const Icon(Icons.dark_mode),
                      Container(margin: const EdgeInsets.symmetric(horizontal: 10)),
                      const Text("dark theme"),
                    ],
                  ),
                ),
              ],
            ));
  }

  void _deleteData() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete data?"),
        content: const Text("Are you sure you want to delete all data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(onPressed: () => _delete(), child: const Text("Ok")),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    Navigator.pop(context);
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("games-played");
    prefs.remove("games-won");
    prefs.remove("time-played");
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Settings",
      body: SettingsList(
        //darkTheme: SettingsThemeData(),
        sections: [
          SettingsSection(
            title: const Text("Theme"),
            tiles: [
              // Change theme
              SettingsTile.navigation(
                title: const Text("Change theme"),
                leading: const Icon(Icons.color_lens),
                onPressed: null, // TODO
              ),
              // Toggle dark theme
              SettingsTile(
                title: const Text("Dark theme"),
                leading: const Icon(Icons.dark_mode),
                onPressed: (context) => _setDarkTheme(),
              ),
            ],
          ),
          // Delete all data
          SettingsSection(
            title: const Text("Other"),
            tiles: [
              SettingsTile(
                title: const Text("Delete all data"),
                leading: const Icon(Icons.delete),
                onPressed: (context) => _deleteData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
