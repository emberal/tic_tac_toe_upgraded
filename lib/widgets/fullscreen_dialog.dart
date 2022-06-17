import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../objects/theme.dart';
import 'layout.dart';

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
                leading: ColorIndicator(color: MyTheme.player1Color.color),
                onPressed: widget.colorPickerDialog != null
                    ? (context) =>
                        widget.colorPickerDialog!(MyTheme.player1Color, context)
                    : null,
              ),
              SettingsTile(
                title: const Text("Player2 colours"),
                leading: ColorIndicator(color: MyTheme.player2Color.color),
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

  /// The [Function] that will be called when one of the options are pressed
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      tiles: [
        SettingsTile(
          title: const Text("Primary colours"),
          leading: ColorIndicator(
            color: changeDark
                ? MyTheme.primaryColorsDark.color
                : MyTheme.primaryColorsLight.color,
          ),
          onPressed: onPressed != null
              ? (context) => onPressed!(
                  changeDark
                      ? MyTheme.primaryColorsDark
                      : MyTheme.primaryColorsLight,
                  context)
              : null,
        ),
        ...tiles
      ],
    );
  }
}
