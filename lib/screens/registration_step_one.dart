import 'package:adventour/components/row/custom_row_divider.dart';
import 'package:adventour/components/form/sign_up_form.dart';
import 'package:flutter/material.dart';

class RegistrationStepOne extends StatelessWidget {
  const RegistrationStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Prevents overflow
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20), // Uniform spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              _buildTitle(),
              const Center(child: SignUpForm()),
              _buildDivider(),
              _buildSocialSignUpButtons(context),
              _buildLoginPrompt(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("< Back"),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 22),
      child: Text("Sign Up", style: TextStyle(fontSize: 26)),
    );
  }

  Widget _buildDivider() {
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

  Widget _buildSocialSignUpButtons(BuildContext context) {
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


  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: const Text("Log In", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
