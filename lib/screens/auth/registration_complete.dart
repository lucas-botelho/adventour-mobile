import 'package:adventour/components/layout/auth_appbar.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/images/circular_image.dart';
import 'package:adventour/components/text/title_with_text.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:flutter/material.dart';

class RegistrationComplete extends StatelessWidget {
  final String name;
  final String imageUrl;

  const RegistrationComplete({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: AuthAppBar(),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 42),
            child: TitleWithText(
                title: "Register Complete!",
                text: "You have successfully created your account."),
          ),
          CircularPicture(url: imageUrl),
          Text(
            name,
            style: const TextStyle(fontSize: 26),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: CTAButton(
              text: 'Enjoy',
              onPressed: () => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdventourMap(),
                  ),
                  (route) => false,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
