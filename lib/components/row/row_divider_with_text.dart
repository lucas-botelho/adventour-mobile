import 'package:adventour/components/row/custom_row_divider.dart';
import 'package:flutter/material.dart';

class RowDividerWithText extends StatelessWidget {
  const RowDividerWithText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RowDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("OR"),
        ),
        RowDivider(),
      ],
    );
  }
}
