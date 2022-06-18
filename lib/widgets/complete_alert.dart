import 'package:flutter/material.dart';

class CompleteAlert extends StatelessWidget {
  const CompleteAlert(
      {super.key,
      required this.title,
      required this.text,
      this.navigator = "/"});

  final String title, text, navigator;

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
            // Empties the stack then adds a new game to the stack
            Navigator.of(context)
                .pushNamedAndRemoveUntil(navigator, (route) => route.isFirst),
          },
          child: const Text("New Game"),
        ),
      ],
    );
  }
}
