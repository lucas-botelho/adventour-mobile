import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:flutter/material.dart';

class HeaderImageWithText extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;

  const HeaderImageWithText({
    super.key,
    required this.title,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
          height: screenHeight / 2,
          width: double.infinity,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Colors.transparent],
                stops: [0.1, 1.0], // Adjust fade intensity
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const ArrowBackButton(),
        Positioned.fill(
          top: screenHeight / 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 36)),
                Text(text, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        )
      ],
    );
    ;
  }
}
