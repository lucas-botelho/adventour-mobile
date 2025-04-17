import 'package:flutter/material.dart';

class TextWithAction extends StatelessWidget {
  final String label;
  final String actionLabel;
  final VoidCallback onPressed;

  const TextWithAction({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel, style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
