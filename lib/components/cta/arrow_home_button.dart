import 'package:flutter/material.dart';

class ArrowHomeButton extends StatelessWidget {
  const ArrowHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 42, 0, 20),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("< Back"),
          ),
        ),
      ],
    );
  }
}
