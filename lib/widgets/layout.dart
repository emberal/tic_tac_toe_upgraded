import 'package:flutter/material.dart';

/// The default [Layout] for this app
class Layout extends StatelessWidget {
  const Layout({this.body, this.title = "Tic-Tac-Toe Upgraded", this.showMenuButton = true, super.key});

  /// The [body] of the page, underneath the [AppBar]
  final Widget? body;

  /// The [title] of the page, displayed in the [AppBar]
  final String title;

  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: showMenuButton ? [
            const IconButton(
              // Menu
              onPressed: null, // TODO
              tooltip: 'Menu',
              icon: Icon(Icons.menu),
            ),
          ] : null
        ),
        body: body,
      ),
    );
  }
}
