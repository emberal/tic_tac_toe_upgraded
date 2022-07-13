import 'package:flutter/material.dart';

import '../main.dart';

/// The default [Layout] for this app
class Layout extends StatelessWidget {
  const Layout(
      {this.body,
      this.title = "Tic-Tac-Toe Upgraded",
      this.showMenuButton = true,
      super.key});

  /// The [body] of the page, underneath the [AppBar]
  final Widget? body;

  /// The [title] of the page, displayed in the [AppBar]
  final String title;

  /// Wheter the menu button in the [AppBar] is shown
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            actions: showMenuButton
                ? [
                    PopupMenuButton(
                      tooltip: 'Menu',
                      onSelected: (value) {
                        Navigator.pushNamed(context, Navigate.settings.route);
                      },
                      icon: const Icon(Icons.menu),
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Settings"),
                            value: "/settings",
                          ),
                        ];
                      },
                    ),
                  ]
                : null),
        body: body,
      ),
    );
  }
}
