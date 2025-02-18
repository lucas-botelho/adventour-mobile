//Copied from flutter docs
import 'dart:convert';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/screens/auth/registration_step_two.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final signUpFormKey = GlobalKey<FormState>();

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
          ),
          StyledTextFormField(
            fieldName: "Email",
            regExp: RegExp(r'^[^@]+@[^@]+\.[^@]+$'),
            controller: _emailController,
          ),
          StyledPasswordFormField(
            fieldName: "Password",
            controller: _passwordController,
          ),
          StyledPasswordFormField(
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
                register(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    if (!isValidForm()) return;

    try {
      final response = await registerUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationStepTwo(
                userId: response.data.userId, token: response.data.token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Registration failed. Please check your details and try again.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registration failed. Please check your details and try again.'),
        ),
      );
    }
  }

  bool isValidForm() {
    return signUpFormKey.currentState!.validate();
  }

  Future<BaseApiResponse<TokenResponse>> registerUser(String name, String email,
      String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${AppSettings.apiBaseUrl}/${Authentication.user}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          UserRegistrationRequest(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          ).toJson(),
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final BaseApiResponse<TokenResponse> result =
            BaseApiResponse<TokenResponse>.fromJson(
                data, (json) => TokenResponse.fromJson(json));

        return result;
      }
    } catch (e) {
      print(e);
    }

    return BaseApiResponse<TokenResponse>(
      success: false,
      message: 'Registration failed. Please check your details and try again.',
      data: TokenResponse(token: '', expiresIn: 0, userId: ''),
    );
  }
}
