import 'package:flutter/material.dart';

class TitleWithText extends StatelessWidget {
  final String text;
  final String title;

  const TitleWithText({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 46),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}
