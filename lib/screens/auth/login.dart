import 'package:adventour/components/layout/auth_appbar.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/components/form/elements/text_with_action.dart';
import 'package:adventour/components/row/row_divider_with_text.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/registration_step_one.dart';
import 'package:adventour/screens/auth/registration_step_three.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registration_step_two.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final UserRepository userRepository;
  late final ErrorService errorService;
  late final FirebaseAuthService authService;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    errorService = context.read<ErrorService>();
    authService = context.read<FirebaseAuthService>();
    userRepository = context.read<UserRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        // Prevents overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              Center(
                child: loginForm(context),
              ),
              const RowDividerWithText(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  socialLoginGoogle(context),
                  // socialLoginGoogle(context),
                ],
              ),
              TextWithAction(
                label: "Don't have an account?",
                actionLabel: "Sign Up",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationStepOne(),
                    ),
                  )
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return const Padding(
      padding: EdgeInsets.only(top: 22),
      child: Text("Log In", style: TextStyle(fontSize: 26)),
    );
  }

  Widget socialLoginGoogle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => signInWithGoogle(),
            icon: Image.asset(
              'assets/images/google_icon.png',
              height: 20,
              width: 20,
            ),
            label: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Google",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CTAButton(
              text: "Log In",
              onPressed: () {
                signInWithEmailAndPassword();
              },
            ),
          )
        ],
      ),
    );
  }

  void signInWithGoogle() async {
    await authService.signInWithGoogle();
    login();
  }

  void signInWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return;

    await authService.signInWithEmail(
        _emailController.text, _passwordController.text);

    login();
  }

  void login() {
    userRepository.getUserData().then((response) {
      if (response == null || response.statusCode == 500) {
        errorService.displaySnackbarError(context, "Internal error.");
        return;
      }

      if (!response.success && response.statusCode == 404) {
        errorService.displaySnackbarError(
          context,
          "You are not registered. Please sign up.",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistrationStepOne(),
          ),
        );

        return;
      }

      if (response.success && response.statusCode == 200) {
        switch (response.data?.registrationStep ?? 0) {
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RegistrationStepTwo(
                  userId: response.data!.id,
                  pinToken: '',
                  email: response.data!.email,
                ),
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RegistrationStepThree(userId: response.data!.oauthId),
              ),
            );
            break;
          default:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AdventourMap(),
              ),
            );
        }
      }

      errorService.displaySnackbarError(context, "Failed to sign in.");
    }).catchError((error) {
      errorService.displaySnackbarError(context, "Unexpected error: $error");
    });
  }
}
