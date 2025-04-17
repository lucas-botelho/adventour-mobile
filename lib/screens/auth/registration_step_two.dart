import 'package:adventour/components/form/elements/single_digit.dart';
import 'package:adventour/components/media/header_image_with_text.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/text_with_action.dart';
import 'package:adventour/screens/auth/registration_step_three.dart';
import 'package:adventour/services/error_service.dart';

class RegistrationStepTwo extends StatefulWidget {
  final String userId;
  final String pinToken;
  const RegistrationStepTwo(
      {required this.userId, required this.pinToken, super.key});

  @override
  State<RegistrationStepTwo> createState() => _RegistrationStepTwoState();
}

class _RegistrationStepTwoState extends State<RegistrationStepTwo> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();
  final ErrorService errorService = ErrorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderImageWithText(
            title: "Verify Your Identity",
            text: "We have just sent a verification code to 938794423",
            imagePath: 'assets/images/step_two_image.jpg',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 90),
                          child: TextWithAction(
                            label: "Didn't receive the code?",
                            actionLabel: "Resend Code",
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 20),
                        CTAButton(
                            text: "Verification", onPressed: confirmEmail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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

      var result = await UserRepository()
          .confirmEmail(widget.userId, code, widget.pinToken);

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
}
