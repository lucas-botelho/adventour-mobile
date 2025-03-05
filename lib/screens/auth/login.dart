import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/components/form/text_with_action.dart';
import 'package:adventour/components/row/row_divider_with_text.dart';
import 'package:adventour/screens/auth/registration_step_one.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};
  final ErrorService errorService = ErrorService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              title(),
              Center(
                child: loginForm(context),
              ),
              const RowDividerWithText(),
              socialLoginButtons(context),
              TextWithAction(
                label: "Don't have an account?",
                actionLabel: "Sign Up",
                onPressed: () => pushToSignUp(context),
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

  Widget socialLoginButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => signInWithGoogle(),
            child: const Text("Log In with Google"),
          ),
          // LogInWithGoogle(context, "Log In with Apple"),
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
    var user = await firebaseAuthService.signInWithGoogle();
    if (user != null) {
      pushToAdventourMap();
    } else {
      errorService.displaySnackbarError(
          context, "Failed to sign in with Google.");
    }
  }

  void pushToAdventourMap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AdventourMap(),
      ),
      (route) => false,
    );
  }

  void signInWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return;

    var user = await firebaseAuthService.signUpWithEmail(
        _emailController.text, _passwordController.text);

    if (user != null) {
      pushToAdventourMap();
    } else {
      errorService.displaySnackbarError(
          context, "Failed to sign in with email and password.");
    }
  }

  void pushToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationStepOne(),
      ),
    );
  }
}
