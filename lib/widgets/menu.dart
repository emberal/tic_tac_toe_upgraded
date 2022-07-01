import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, this.menus});

  /// A [List] containing a [Map] of [String] with two keys, "page" and "text"
  /// where "page" contains the route to a page and "text" is the text that's diplayed
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
                  Navigator.pushNamed(context, (item["page"] ?? "/")),
              child: Text(item["text"] ??= ""),
              style: ElevatedButton.styleFrom(minimumSize: const Size(300, 40)),
            ),
          ),
        ),
      ],
    );
  }
}
