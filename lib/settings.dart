import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.themeModeCallback, this.themeCallback});

  /// Changes the [ThemeMode] to 'light', 'dark' or 'system'
  final Function(ThemeMode)? themeModeCallback;

  /// changes various themes around the app
  final Function? themeCallback;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _setTheme() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => FullScreenDialog(
            title: "Change theme", themeCallback: widget.themeCallback),
        fullscreenDialog: true,
      ),
    );
  }

  void _setDarkTheme() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Dark theme"),
        children: [
          _DialogOption(
            onPressed: widget.themeModeCallback != null
                ? () => widget.themeModeCallback!(ThemeMode.system)
                : null,
            text: "Follow system",
            icon: Icons.brightness_4,
          ),
          _DialogOption(
            onPressed: widget.themeModeCallback != null
                ? () => widget.themeModeCallback!(ThemeMode.light)
                : null,
            text: "Light theme",
            icon: Icons.sunny,
          ),
          _DialogOption(
            onPressed: widget.themeModeCallback != null
                ? () => widget.themeModeCallback!(ThemeMode.dark)
                : null,
            text: "Dark theme",
            icon: Icons.dark_mode,
          ),
        ],
      ),
    );
  }

  void _deleteData() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete data"),
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

    prefs.remove("games-played-sp");
    prefs.remove("games-won-sp");
    prefs.remove("time-played-sp");
    prefs.remove("games-played-lmp");
    prefs.remove("games-won-lmp");
    prefs.remove("time-played-lmp");
    prefs.remove("games-played-mp");
    prefs.remove("games-won-mp");
    prefs.remove("time-played-mp");
    prefs.remove("global-theme");
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Settings",
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

class _DialogOption extends StatelessWidget {
  const _DialogOption({this.onPressed, this.icon, this.text = ""});

  final Function? onPressed;
  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed != null ? () => onPressed!() : null,
      child: Row(
        children: [
          Icon(icon),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Text(text),
        ],
      ),
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  const FullScreenDialog({super.key, this.title = "", this.themeCallback});

  final String title;

  final Function? themeCallback;

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  Future<bool> colorPickerDialog(Color startColor) async {
    return ColorPicker(
      // Start color.
      color: startColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) => setState(() => startColor = color), // TODO call function
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Change theme",
      showMenuButton: false,
      body: SettingsList(
        sections: [
          _SettingsSectionTheme(
            title: const Text("Light theme"),
            onPressed: widget.themeCallback,
            tiles: const [],
          ),
          _SettingsSectionTheme(
            title: const Text("Dark theme"),
            changeDark: true,
            onPressed: widget.themeCallback,
            tiles: const [],
          ),
          SettingsSection(
            title: const Text("Players"),
            tiles: [
              SettingsTile(
                title: const Text("Player1 colours"),
                onPressed: widget.themeCallback != null
                    ? (context) => widget.themeCallback!(true,
                        player1: colorPickerDialog(MyTheme.player1Color))
                    : null,
              ),
              SettingsTile(
                title: const Text("Player2 colours"),
                onPressed: widget.themeCallback != null
                    ? (context) => widget.themeCallback!(true,
                        player2: colorPickerDialog(MyTheme.player2Color))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog();

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class _SettingsSectionTheme extends SettingsSection {
  const _SettingsSectionTheme(
      {super.title,
      required super.tiles,
      this.changeDark = false,
      this.onPressed});

  /// Whether or not this section is for changing dark mode settings
  final bool changeDark;

  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      tiles: [
        SettingsTile(
          title: const Text("Appbar"),
          onPressed: onPressed != null
              ? (context) => onPressed!(changeDark, appBar: Colors.green)
              : null,
        ),
        SettingsTile(
          title: const Text("Primary colours"),
          onPressed: onPressed != null
              ? (context) => onPressed!(changeDark, primary: Colors.green)
              : null,
        ),
        SettingsTile(
          title: const Text("Background"),
          onPressed: onPressed != null
              ? (context) => onPressed!(changeDark, background: Colors.green)
              : null,
        ),
        ...tiles
      ],
    );
  }
}
