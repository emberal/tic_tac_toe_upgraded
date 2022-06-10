import 'package:flutter/material.dart';

class CompleteAlert extends StatelessWidget {
  const CompleteAlert({super.key, required this.title, required this.text});

  final String title, text;

  @override
  Widget build(BuildContext context) {
    var _count = 0;

    return Container(child: AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), // TODO use named routes https://docs.flutter.dev/cookbook/navigation/named-routes
          child: const Text("Back"),
        ),
        TextButton(
          onPressed: null, // TODO
          child: const Text("New Game"),
        ),
      ],
    ));
  }

}
