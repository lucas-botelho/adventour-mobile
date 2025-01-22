import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart'

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              ElevatedButton(
                onPressed: () {
                  //do something
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
