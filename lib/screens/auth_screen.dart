import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/screens/custommap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adventour/screens/registration_step_one.dart';
// import 'package:google_fonts/google_fonts.dart'

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 310,
                height: 450,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/login_image.jpg'),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              Text(
                "If not now when?",
                style: GoogleFonts.nanumBrushScript(fontSize: 48),
              ),
              CTAButton(
                text: "Login",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationStepOne()),
                  );
                },
              ),
              CTAButton(
                text: "mapsd",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomMap()),
                  );
                },
              ),
              CTAButton(
                color: const Color(0xFF37787E),
                text: "Sign Up",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
