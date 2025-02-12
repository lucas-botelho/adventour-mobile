//Copied from flutter docs
import 'dart:convert';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/responses/base_api_response.dart';
import 'package:adventour/screens/registration_step_two.dart';
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
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
    return Form(
      key: _signUpFormKey,
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationStepTwo(userId: response.UserId),
        ),
      );
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
    return _signUpFormKey.currentState!.validate();
  }

  Future<UserRegistrationResponse> registerUser(String name, String email,
      String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${AppSettings.apiBaseUrl}/${Authentication.register}'),
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
        final BaseApiResponse<UserRegistrationResponse> result =
            BaseApiResponse<UserRegistrationResponse>.fromJson(
                data, (json) => UserRegistrationResponse.fromJson(json));

        return result.data;
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('error: $e');
    }
  }
}

class UserRegistrationRequest {
  final String name;
  final String email;
  final String confirmPassword;
  final String password;

  UserRegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class UserRegistrationResponse {
  final String UserId;

  UserRegistrationResponse({required this.UserId});

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UserRegistrationResponse(
      UserId: json['userId'],
    );
  }
}
