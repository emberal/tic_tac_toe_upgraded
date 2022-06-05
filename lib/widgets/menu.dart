import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, this.menus});

  final List<Map<String, Object>>? menus;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 150),
      child: Column(
        children: [
          ...(menus)!.map((item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () => Navigator.push( // Pushes the page to the navigator
                    context,
                    MaterialPageRoute(
                        builder: (context) => item["page"] as Widget
                    )
                ),
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
