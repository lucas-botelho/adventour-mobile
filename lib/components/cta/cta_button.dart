import 'package:flutter/material.dart';

class CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double width;
  final double height;

  const CTAButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width = 308, // Default width
    this.height = 50, // Default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ??
                Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.backgroundColor
                    ?.resolve({}),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
