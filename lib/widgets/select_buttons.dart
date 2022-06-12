import 'package:flutter/material.dart';

class SelectButtons extends StatefulWidget {
  const SelectButtons({super.key, this.values, this.setActiveNumber});

  final List<Map<String, Object>>? values;
  final Function? setActiveNumber;

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...widget.values!
            .map(
              (value) => Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    maximumSize: const Size(64, 64),
                  ),
                  // If a value has been used already, do nothing
                  onPressed: value["used"] as bool
                      ? null
                      : () => widget.setActiveNumber!(value["value"] as int),
                  child: Text("${value["value"]}"),
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
