import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  const Blur({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: color != null
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(color: color!, blurRadius: 40, spreadRadius: 10)
              ],
            )
          : null,
      child: const SizedBox(
        height: 40,
        width: double.infinity,
      ),
    );
  }
}
