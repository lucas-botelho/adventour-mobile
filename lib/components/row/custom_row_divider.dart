import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 2,
        color: Colors.white,
      ),
    );
  }
}
