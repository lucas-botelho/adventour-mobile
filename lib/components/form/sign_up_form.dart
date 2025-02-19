//Copied from flutter docs
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/screens/auth/registration_step_two.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:adventour/services/error_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};
  final ErrorService errorService = ErrorService();

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
      key: formKey,
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

  void register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
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
        switch (result.statusCode) {
          case 400:
            errorService.displayFieldErrors(context, result.errors, (errors) {
              setState(() {
                fieldErrors = errors;
              });
            });
            break;
          case 409:
          case 500:
            errorService.displaySnackbarError(context, result.message);
            break;
          default:
            errorService.displaySnackbarError(context, null);
        }
      }
    } catch (error) {
      errorService.displaySnackbarError(context, null);
    }
  }
}
