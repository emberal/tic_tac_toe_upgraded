import 'dart:math';

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
      this.offsetOnActivate = const Offset(0, 0),
      this.rotate = false});

  /// A [Function] that's called when one of the buttons are pressed
  final Function? setActiveNumber;

  /// The [Player] that will use the buttons
  final Player? player;

  final Offset offsetOnActivate;

  final bool rotate;

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
                  offset: widget.offsetOnActivate,
                  rotate: widget.rotate,
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
      this.offset = const Offset(0, 0),
      this.rotate = false});

  final Player? player;

  final int value;

  final bool activated;

  final Function? onPressed;

  final Offset offset;

  final bool rotate;

  @override
  State<_Button> createState() => __ButtonState();
}

class __ButtonState extends State<_Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  var _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: pi).animate(_controller)
      ..addListener(() => setState(() => _rotation = _animation.value));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotate) {
      _controller.forward();
    } else if (_rotation == pi) {
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
    return Transform.rotate(
      angle: _rotation,
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
            ? widget.offset
            : const Offset(0, 0),
      ),
    );
  }
}
