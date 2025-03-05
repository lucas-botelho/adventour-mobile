import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/form_passwordfield.dart';
import 'package:adventour/components/form/elements/form_textfield.dart';
import 'package:adventour/components/form/text_with_action.dart';
import 'package:adventour/components/row/row_divider_with_text.dart';
import 'package:adventour/models/requests/auth/user_registration.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/screens/auth/login.dart';
import 'package:adventour/screens/auth/registration_step_two.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationStepOne extends StatefulWidget {
  const RegistrationStepOne({super.key});

  @override
  State<RegistrationStepOne> createState() => _RegistrationStepOneState();
}

class _RegistrationStepOneState extends State<RegistrationStepOne> {
  final formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};
  final ErrorService errorService = ErrorService();
  final ApiService apiService = ApiService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

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
                child: signUpForm(context),
              ),
              const RowDividerWithText(),
              socialSignUpButtons(context),
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

  Widget title() {
    return const Padding(
      padding: EdgeInsets.only(top: 22),
      child: Text("Sign Up", style: TextStyle(fontSize: 26)),
    );
  }

  Widget socialSignUpButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => signInWithGoogle(),
            child: const Text("Sign Up with Google"),
          ),
          // SignUpWithGoogle(context, "Sign Up with Apple"),
        ],
      ),
    );
  }

  Form signUpForm(BuildContext context) {
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
                signInWithEmailAndPassword();
              },
            ),
          )
        ],
      ),
    );
  }

  void signInWithGoogle() async {
    register(
      await firebaseAuthService.signUpWithGoogle(),
    );
  }

  void signInWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return;

    register(
      await firebaseAuthService.signUpWithEmail(
          _emailController.text, _passwordController.text),
    );
  }

  void register(User? user) async {
    var token = await firebaseAuthService.getFirebaseIdToken();
    if (user == null || token == null) {
      ErrorService()
          // ignore: use_build_context_synchronously
          .displaySnackbarError(context, "Internal error signing up.");
      return;
    }

    try {
      final requestModel = UserRegistrationRequest(
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        oAuthId: user.uid,
      );

      final result = await apiService.post(
        token: token,
        endpoint: Authentication.user,
        headers: <String, String>{},
        body: requestModel.toJson(),
        fromJsonT: (json) => TokenResponse.fromJson(json),
      );

      if (result.success) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationStepTwo(
                userId: result.data!.userId, pinToken: result.data!.token),
          ),
        );
      } else {
        switch (result.statusCode) {
          case 400:
            // ignore: use_build_context_synchronously
            errorService.displayFieldErrors(context, result.errors, (errors) {
              setState(() {
                fieldErrors = errors;
              });
            });
            break;
          case 409:
          case 500:
            // ignore: use_build_context_synchronously
            errorService.displaySnackbarError(context, result.message);
            break;
          default:
            errorService.displaySnackbarError(context, null);
        }
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }
  }

  void pushToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}
