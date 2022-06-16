import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';
import 'package:tic_tac_toe_upgraded/widgets/layout.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
  const FullScreenDialog({super.key, this.title = "", this.colorPickerDialog});

  /// The [title] in the [AppBar]
  final String title;

  /// The [Function] that opens the [colorPickerDialog]
  final Function? colorPickerDialog;

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Change theme",
      showMenuButton: false,
      body: SettingsList(
        sections: [
          _SettingsSectionTheme(
            title: const Text("Light theme"),
            onPressed: widget.colorPickerDialog,
            tiles: const [],
          ),
          _SettingsSectionTheme(
            title: const Text("Dark theme"),
            onPressed: widget.colorPickerDialog,
            changeDark: true,
            tiles: const [],
          ),
          SettingsSection(
            title: const Text("Players"),
            tiles: [
              SettingsTile(
                title: const Text("Player1 colours"),
                leading: ColorIndicator(color: MyTheme.player1Color.object),
                onPressed: widget.colorPickerDialog != null
                    ? (context) =>
                        widget.colorPickerDialog!(MyTheme.player1Color, context)
                    : null,
              ),
              SettingsTile(
                title: const Text("Player2 colours"),
                leading: ColorIndicator(color: MyTheme.player2Color.object),
                onPressed: widget.colorPickerDialog != null
                    ? (context) =>
                        widget.colorPickerDialog!(MyTheme.player2Color, context)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
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

  /// The [Function] that will be called when one either option is pressed
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      tiles: [
        // SettingsTile(
        //   title: const Text("Appbar"),
        //   leading: ColorIndicator(
        //     color: changeDark
        //         ? MyTheme.appBarColorsDark.object
        //         : MyTheme.appBarColorsLight.object,
        //   ),
        //   onPressed: onPressed != null
        //       ? (context) => onPressed!(changeDark
        //           ? MyTheme.appBarColorsDark
        //           : MyTheme.appBarColorsLight, context)
        //       : null,
        // ),
        SettingsTile(
          title: const Text("Primary colours"),
          leading: ColorIndicator(
            color: changeDark
                ? MyTheme.primaryColorsDark.object
                : MyTheme.primaryColorsLight.object,
          ),
          onPressed: onPressed != null
              ? (context) => onPressed!(
                  changeDark
                      ? MyTheme.primaryColorsDark
                      : MyTheme.primaryColorsLight,
                  context)
              : null,
        ),
        // SettingsTile(
        //   title: const Text("Background"),
        //   leading: ColorIndicator(
        //     color:
        //         changeDark ? MyTheme.backgroundDark.object : MyTheme.backgroundLight.object,
        //   ),
        //   onPressed: onPressed != null
        //       ? (context) => onPressed!(
        //           changeDark ? MyTheme.backgroundDark : MyTheme.backgroundLight, context)
        //       : null,
        // ),
        ...tiles
      ],
    );
  }
}
