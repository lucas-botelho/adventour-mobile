import 'dart:convert';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/auth/confirm_email.dart';
import 'package:adventour/models/responses/auth/token.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/text_with_action.dart';
import 'package:adventour/screens/auth/registration_step_three.dart';
import 'package:http/http.dart' as http;

class RegistrationStepTwo extends StatefulWidget {
  final String userId;
  final String token;
  const RegistrationStepTwo(
      {required this.userId, required this.token, super.key});

  @override
  State<RegistrationStepTwo> createState() => _RegistrationStepTwoState();
}

class _RegistrationStepTwoState extends State<RegistrationStepTwo> {
  final _emailConfirmationFormKey = GlobalKey<FormState>();
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          imageWithText(screenHeight),
          confirmationCode(),
        ],
      ),
    );
  }

  Expanded confirmationCode() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Form(
                    key: _emailConfirmationFormKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        codeInputField(_codeController1),
                        codeInputField(_codeController2),
                        codeInputField(_codeController3),
                        codeInputField(_codeController4),
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
                  CTAButton(text: "Verification", onPressed: confirmEmail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmEmail() async {
    try {
      if (_emailConfirmationFormKey.currentState!.validate()) {
        final response = await http.post(
          Uri.parse('${AppSettings.apiBaseUrl}/${Authentication.confirmEmail}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode(
            EmailConfirmationRequest(
              userId: widget.userId,
              pin: _codeController1.text +
                  _codeController2.text +
                  _codeController3.text +
                  _codeController4.text,
            ).toJson(),
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final BaseApiResponse<TokenResponse> result =
              BaseApiResponse<TokenResponse>.fromJson(
                  data, (json) => TokenResponse.fromJson(json));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationStepThree(
                  userId: widget.userId, token: result.data.token),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Verification failed. Please check your details and try again.'),
        ),
      );
    }
  }

  Stack imageWithText(double screenHeight) {
    return Stack(
      children: [
        SizedBox(
          height: screenHeight / 2,
          width: double.infinity,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Colors.transparent],
                stops: [0.1, 1.0], // Adjust fade intensity
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: Image.asset(
              'assets/images/step_two_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const ArrowBackButton(),
        Positioned.fill(
          top: screenHeight / 3,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verify Your Identity", style: TextStyle(fontSize: 36)),
                Text(
                  "We have just sent a verification code to 938794423",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget codeInputField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        style: const TextStyle(fontSize: 40),
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
