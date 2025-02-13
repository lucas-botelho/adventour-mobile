import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  const ArrowBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("< Back"),
      ),
    );
  }
}
