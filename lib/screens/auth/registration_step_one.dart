import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:adventour/components/form/text_with_action.dart';
import 'package:adventour/components/row/custom_row_divider.dart';
import 'package:adventour/components/form/sign_up_form.dart';
import 'package:adventour/screens/auth/login.dart';
import 'package:flutter/material.dart';

class RegistrationStepOne extends StatelessWidget {
  const RegistrationStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Prevents overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ArrowBackButton(),
              buildTitle(),
              const Center(child: SignUpForm()),
              buildDivider(),
              buildSocialSignUpButtons(context),
              TextWithAction(
                label: "Already have an account?",
                actionLabel: "Log In",
                onPressed: () => pushToLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  Widget buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 22),
      child: Text("Sign Up", style: TextStyle(fontSize: 26)),
    );
  }

  Widget buildDivider() {
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

  Widget buildSocialSignUpButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSocialButton(context, "Sign Up with Google"),
          _buildSocialButton(context, "Sign Up with Apple"),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/registration_step_two'),
      child: Text(text),
    );
  }
}
