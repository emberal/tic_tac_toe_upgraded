import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, this.menus});

  final List<Map<String, String>>? menus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...?menus?.map(
          (item) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              // If null go to home page
              onPressed: () =>
                  Navigator.pushNamed(context, (item["page"] ??= "/")),
              child: Text(item["text"] as String),
              style: ElevatedButton.styleFrom(minimumSize: const Size(300, 40)),
            ),
          ),
        ),
      ],
    );
  }
}
