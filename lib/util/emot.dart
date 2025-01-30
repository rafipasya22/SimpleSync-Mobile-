import 'package:flutter/material.dart';

class Emot extends StatelessWidget {
  final String emoticonface;

  const Emot({
    super.key,
    required this.emoticonface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 162, 221),
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text(
          emoticonface,
          style: TextStyle(fontSize: 25),
        )));
  }
}
