import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:tic_tac_toe_upgraded/objects/player_ai.dart';

import '../objects/player.dart';

// TODO drag and drop buttons to the correct position

class SelectButtons extends StatefulWidget {
  const SelectButtons(
      {super.key,
      this.setActiveNumber,
      this.player,
      this.offsetUp = true,
      this.rotation = 0});

  /// A [Function] that's called when one of the buttons are pressed
  final Function? setActiveNumber;

  /// The [Player] that will use the buttons
  final Player? player;

  /// Whether the selected button will be pushed up or down, if 'true' it will be pushed up, otherwise down
  final bool offsetUp;

  final double rotation;

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...?widget.player?.usedValues
            .mapIndexed(
              (index, value) => Container(
                margin: const EdgeInsets.all(10),
                child: _Button(
                  value: index + 1,
                  activated: value,
                  player: widget.player,
                  onPressed: widget.setActiveNumber,
                  offsetUp: widget.offsetUp,
                  rotation: widget.rotation,
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

class _Button extends StatefulWidget {
  const _Button(
      {super.key,
      this.player,
      this.activated = true,
      this.onPressed,
      this.value = 0,
      this.offsetUp = true,
      this.rotation = 0});

  final Player? player;

  final int value;

  final bool activated;

  final Function? onPressed;

  final bool offsetUp;

  final double rotation;

  @override
  State<_Button> createState() => __ButtonState();
}

class __ButtonState extends State<_Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 3.14).animate(_controller)
      ..addStatusListener((status) {
        print("$status");
      });
    //_controller.forward(); // TODO setup logic to run animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.rotation,
      child: Transform.translate(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 50),
            maximumSize: const Size(64, 64),
            primary: widget.player?.color,
          ),
          // If a value has been used already, do nothing
          onPressed: widget.player == null ||
                  widget.player! is PlayerAI ||
                  widget.activated
              ? null
              : () => widget.onPressed!(widget.value, widget.player),
          child: Text("${widget.value}"),
        ),
        offset: widget.player?.activeNumber == widget.value
            ? Offset(0, widget.offsetUp ? -20 : 20)
            : const Offset(0, 0),
      ),
    );
  }
}
