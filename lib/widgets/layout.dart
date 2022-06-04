import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({this.body, this.title = "Tic Tac Toe Upgraded", Key? key}) : super(key: key);

  final Widget? body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(title),
            actions: const [
              //Expanded(child: title),
              IconButton( // Menu
                onPressed: null, // TODO
                tooltip: 'Menu',
                icon: Icon(Icons.menu),
              ),
            ],
          ),
          body: body,
    ));
  }
}
