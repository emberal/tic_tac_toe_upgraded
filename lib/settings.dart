import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Settings",
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Theme"),
            tiles: [
              SettingsTile.navigation(
                title: const Text("Change theme"),
                leading: const Icon(Icons.color_lens),
                onPressed: null, // TODO
              ),
              SettingsTile.switchTile(
                title: const Text("Dark theme"),
                leading: const Icon(Icons.dark_mode),
                initialValue: false,
                onToggle: null, // TODO
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Other"),
            tiles: [
              SettingsTile(
                title: const Text("Delete all data"),
                leading: const Icon(Icons.delete),
                onPressed: null, // TODO
              ),
            ],
          ),
        ],
      ),
    );
  }
}
