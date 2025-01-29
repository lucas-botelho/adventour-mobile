import 'package:adventour/components/row/custom_row_divider.dart';
import 'package:adventour/components/form/sign_up_form.dart';
import 'package:flutter/material.dart';

class RegistrationStepOne extends StatelessWidget {
  const RegistrationStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the left
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 42),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("< Back"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 22, left: 15),
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 26),
          ),
        ),
        const Center(
          child: SignUpForm(),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RowDivider(),
            Text("OR"),
            RowDivider(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration_step_two');
              },
              child: const Text("Sign Up with Google"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration_step_two');
              },
              child: const Text("Sign Up with Google"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child:
                  const Text("Log In", style: TextStyle(color: Colors.black)),
            ),
          ],
        )
      ],
    ));
  }
}
