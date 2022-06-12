import 'package:flutter/material.dart';

import '../enums/player_enum.dart';

class SelectButtons extends StatefulWidget {
  const SelectButtons({super.key, this.values, this.setActiveNumber, this.buttonColor, this.player = Player.none});

  final List<Map<String, Object>>? values;
  final Function? setActiveNumber;
  final Color? buttonColor;
  final Player player;

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...widget.values!
            .map(
              (value) => Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    maximumSize: const Size(64, 64),
                    primary: widget.buttonColor,
                  ),
                  // If a value has been used already, do nothing
                  onPressed: widget.player == Player.none || value[widget.player.toString()] as bool
                      ? null
                      : () => widget.setActiveNumber!(value["value"] as int, widget.player), // TODO use correct player
                  child: Text("${value["value"]}"),
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
