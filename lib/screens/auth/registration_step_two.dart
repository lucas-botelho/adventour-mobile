import 'package:adventour/components/form/elements/single_digit.dart';
import 'package:adventour/components/layout/auth_appbar.dart';
import 'package:adventour/components/media/header_image_with_text.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/text_with_action.dart';
import 'package:adventour/screens/auth/registration_step_three.dart';
import 'package:adventour/services/error_service.dart';
import 'package:provider/provider.dart';

class RegistrationStepTwo extends StatefulWidget {
  final String userId;
  final String pinToken;
  final String email;

  const RegistrationStepTwo(
      {required this.userId,
      required this.pinToken,
      required this.email,
      super.key});

  @override
  State<RegistrationStepTwo> createState() => _RegistrationStepTwoState();
}

class _RegistrationStepTwoState extends State<RegistrationStepTwo> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();
  late final ErrorService errorService;
  late final UserRepository userRepository;
  late final FirebaseAuthService authService;
  String? resentVerificationCode;

  @override
  void initState() {
    super.initState();
    errorService = context.read<ErrorService>();
    userRepository = context.read<UserRepository>();
    authService = context.read<FirebaseAuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeaderImageWithText(
                          title: "Verify Your Identity",
                          text:
                          "We have just sent a verification code to ${widget.email}",
                          imagePath: 'assets/images/step_two_image.jpg',
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SingleDigitInput(controller: _codeController1),
                              SingleDigitInput(controller: _codeController2),
                              SingleDigitInput(controller: _codeController3),
                              SingleDigitInput(controller: _codeController4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextWithAction(
                          label: "Didn't receive the code?",
                          actionLabel: "Resend Code",
                          onPressed: resendEmail,
                        ),
                        const SizedBox(height: 40),
                        CTAButton(
                          text: "Verification",
                          onPressed: confirmEmail,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }

  void confirmEmail() async {
    if (!formKey.currentState!.validate()) return;
    try {
      List<String> code = [
        _codeController1.text,
        _codeController2.text,
        _codeController3.text,
        _codeController4.text
      ];

      var result = await userRepository.confirmEmail(
          widget.userId,
          code,
          resentVerificationCode != null
              ? resentVerificationCode!
              : widget.pinToken);

      if (result != null) {
        if (result.success) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RegistrationStepThree(userId: widget.userId),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          errorService.displaySnackbarError(context, result.message);
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }
  }

  void resendEmail() async {
    try {
      var user = authService.getUser();

      if (user == null) {
        // ignore: use_build_context_synchronously
        errorService.displaySnackbarError(
            context, "Your session has expired. Please sign up again.");
        return;
      }

      final result = await userRepository.resendCode(user);

      if (result != null) {

        resentVerificationCode = result.data?.token ?? null;

        errorService.displaySnackbarError(context, result.message);
      } else {
        // ignore: use_build_context_synchronously
        errorService.displaySnackbarError(
            context, "Internal error, please try again later.");
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }
  }
}
