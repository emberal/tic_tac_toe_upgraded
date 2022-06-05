import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({this.body, this.title = "Tic Tac Toe Upgraded", super.key});

  final Widget? body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: const [
            IconButton(
              // Menu
              onPressed: null, // TODO
              tooltip: 'Menu',
              icon: Icon(Icons.menu),
            ),
          ],
        ),
        body: body,
      ),
    );
  }
}
