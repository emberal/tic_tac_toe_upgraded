import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/stats.dart';
import 'package:tic_tac_toe_upgraded/widgets/fullscreen_dialog.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';

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
          TextButton(onPressed: () => _delete(), child: const Text("Ok")),
        ],
      ),
    );
  }

  /// Deletes all [SharedPreferences] data
  Future<void> _delete() async {
    Navigator.pop(context);
    final prefs = await SharedPreferences.getInstance();

    for (var data in StatData.values) {
      prefs.remove(data.sp);
      prefs.remove(data.lmp);
      prefs.remove(data.mp);
    }
    for (var data in ThemeId.values) {
      if (data.both != null) {
        prefs.remove(data.both!);
      }
      if (data.light != null) {
        prefs.remove(data.light!);
      }
      if (data.dark != null) {
        prefs.remove(data.dark!);
      }
    }
    if (widget.themeModeCallback != null) {
      // Immediately resets darkMode to system
      widget.themeModeCallback!(ThemeMode.system);
    }
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
