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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AuthAppBar(),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 42),
                        child: TitleWithText(
                          title: "Register Complete!",
                          text: "You have successfully created your account.",
                        ),
                      ),
                      const SizedBox(height: 32),
                      CircularPicture(url: imageUrl),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 26),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 60,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: CTAButton(
                            text: 'Enjoy',
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdventourMap(),
                                ),
                                    (route) => false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
