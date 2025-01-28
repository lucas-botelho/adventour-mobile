//Copied from flutter docs
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/form_textfield.dart';
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
          FormTextField(
            fieldName: "Password",
            regExp: RegExp(r'^[A-Za-z0-9!@#\$%^&*()_+]{8,}$'),
          ),
          FormTextField(
            fieldName: "Confirm Password",
            regExp: RegExp(r'^[A-Za-z0-9!@#\$%^&*()_+]{8,}$'),
          ),
          CTAButton(
            text: "Sign Up",
            onPressed: () {},
          )
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}
