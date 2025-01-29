//Copied from flutter docs
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignUpFormState extends State<SignUpForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _signUpFormKey = GlobalKey<FormState>();

  //Controllers for password fields
  //Controllers are used to give control of the parent over the child
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          FormTextField(
            fieldName: "Name",
            regExp: RegExp(r'^[A-Za-z ]+$'),
          ),
          FormTextField(
            fieldName: "Phone Number",
            regExp: RegExp(r'^[0-9]{10}$'),
          ),
          FormPasswordField(
            fieldName: "Password",
            controller: _passwordController,
          ),
          FormPasswordField(
            fieldName: "Confirm Password",
            controller: _confirmPasswordController,
            passwordController: _passwordController,
            confirmPassword: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CTAButton(
              text: "Sign Up",
              onPressed: () {
                if (_signUpFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
            ),
          )
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}
