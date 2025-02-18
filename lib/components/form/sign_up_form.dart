//Copied from flutter docs
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/screens/auth/registration_step_two.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final signUpFormKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signUpFormKey,
      child: Column(
        children: <Widget>[
          StyledTextFormField(
            fieldName: "Name",
            regExp: RegExp(r'^[A-Za-z ]+$'),
            controller: _nameController,
            errorText: fieldErrors["Name"],
          ),
          StyledTextFormField(
            fieldName: "Email",
            regExp: RegExp(r'^[^@]+@[^@]+\.[^@]+$'),
            controller: _emailController,
            errorText: fieldErrors["Email"],
          ),
          StyledPasswordFormField(
            fieldName: "Password",
            controller: _passwordController,
            errorText: fieldErrors["Password"],
          ),
          StyledPasswordFormField(
            fieldName: "Confirm Password",
            controller: _confirmPasswordController,
            passwordController: _passwordController,
            errorText: fieldErrors["ConfirmPassword"],
            confirmPassword: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CTAButton(
              text: "Sign Up",
              onPressed: () {
                register(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    if (!signUpFormKey.currentState!.validate()) return;
    try {
      final requestModel = UserRegistrationRequest(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      final result = await ApiService().post(
        endpoint: Authentication.user,
        headers: <String, String>{},
        body: requestModel.toJson(),
        fromJsonT: (json) => TokenResponse.fromJson(json),
      );

      if (result.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationStepTwo(
                userId: result.data!.userId, token: result.data!.token),
          ),
        );
      } else {
        displayDefaultErrorMessage(context, errors: result.errors);
      }
    } catch (error) {
      displayDefaultErrorMessage(context);
    }
  }

  void displayDefaultErrorMessage(
    BuildContext context, {
    Map<String, List<String>>? errors,
  }) {
    if (errors == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
      return;
    } else {
      setState(() {
        fieldErrors =
            errors.map((key, value) => MapEntry(key, value.join(', ')));
      });
    }
  }
}
