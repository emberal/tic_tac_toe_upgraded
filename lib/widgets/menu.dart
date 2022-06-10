import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, this.menus});

  final List<Map<String, String>>? menus;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 150),
      child: Column(
        children: [
          ...(menus)!.map((item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, (item["page"] ??= "/")), // If null go to home page
                child: Text(item["text"] as String),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 40)
                ),
              )
          ))
        ],
      ),
    );
  }
}
