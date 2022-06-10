import 'package:flutter/material.dart';

class CompleteAlert extends StatelessWidget {
  const CompleteAlert({super.key, required this.title, required this.text});

  final String title, text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Text("Back"),
        ),
        TextButton(
          onPressed: () => {
            // empties the stack then adds a new game to the stack
            Navigator.of(context).popUntil((route) => route.isFirst),
            Navigator.pushNamed(context, "/game"),
          },
          child: const Text("New Game"),
        ),
      ],
    );
  }
}
