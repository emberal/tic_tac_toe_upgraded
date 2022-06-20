import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:tic_tac_toe_upgraded/game/game_utils.dart';
import 'package:tic_tac_toe_upgraded/objects/player_ai.dart';
import 'package:tic_tac_toe_upgraded/objects/theme.dart';

import '../objects/player.dart';

// TODO drag and drop buttons to the correct position

class SelectButtons extends StatelessWidget {
  const SelectButtons(
      {super.key,
      this.player,
      this.offsetOnActivate = const Offset(0, 0),
      this.rotate = false});

  /// The [Player] that will use the buttons
  final Player? player;

  /// [Offset] the activated button when [onPressed] is called
  final Offset offsetOnActivate;

  /// If the buttons should rotate 180 degrees on [build], if false and already rotated, the buttons will reverse
  final bool rotate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...?player?.usedValues
            .mapIndexed(
              (index, value) => Container(
                margin: const EdgeInsets.all(10),
                child: _Button(
                  value: index + 1,
                  activated: value,
                  player: player,
                  offsetOnActivate: offsetOnActivate,
                  rotate: rotate,
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
      this.value = 0,
      this.offsetOnActivate = const Offset(0, 0),
      this.rotate = false});

  /// The [Player] in control of the button
  final Player? player;

  /// The number value of the button
  final num value;

  /// Is 'true' if the button has already been used
  final bool activated;

  /// [Offset] the button when [onPressed] is called
  final Offset offsetOnActivate;

  /// If the button should rotate 180 degrees on [build], if false and already rotated, the button will reverse
  final bool rotate;

  @override
  State<_Button> createState() => __ButtonState();
}

class __ButtonState extends State<_Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _setActiveNumber() {
    if (widget.player != null && widget.player!.isTurn) {
      setState(() => widget.player!.activeNumber = widget.value);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: GameUtils.rotationAnimation));
    _animation = Tween(begin: 0.0, end: pi).animate(_controller)
      ..addListener(() => setState(() => _animation.value));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotate) {
      _controller.forward();
    } else if (_animation.value == pi) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(50, 50),
          maximumSize: const Size(64, 64),
          primary: widget.player?.color,
          onPrimary: widget.player != null
              ? MyTheme.contrast(widget.player!.color)
              : null,
        ),
        // If a value has been used already, do nothing
        onPressed: widget.player == null ||
                widget.player! is PlayerAI ||
                widget.activated
            ? null
            : _setActiveNumber,
        child: Text("${widget.value}"));
    return Transform.rotate(
      angle: _animation.value,
      child: Transform.translate(
        child: Draggable(
          ignoringFeedbackSemantics: false,
          feedback: button,
          child: button,
          childWhenDragging: Container(),
          data: widget.value,
          maxSimultaneousDrags: 1,
        ),
        offset: widget.player?.activeNumber == widget.value
            ? widget.offsetOnActivate
            : const Offset(0, 0),
      ),
    );
  }
}
