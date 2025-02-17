import 'dart:convert';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/profile_picture_upload.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:adventour/responses/base_api_response.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

class RegistrationStepThree extends StatefulWidget {
  final String email;

  const RegistrationStepThree({super.key, required this.email});

  @override
  State<RegistrationStepThree> createState() => _RegistrationStepThreeState();
}

class _RegistrationStepThreeState extends State<RegistrationStepThree> {
  final accountUpdateFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  io.File? profileImage;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void onImageSelected(io.File? image) {
    setState(() {
      profileImage = image;
    });
  }

  void submitForm() async {
    if (accountUpdateFormKey.currentState!.validate()) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${AppSettings.apiBaseUrl}/${Files.upload}'))
        ..files.add(http.MultipartFile.fromBytes(
            'File', profileImage!.readAsBytesSync(),
            filename: profileImage!.path))
        ..fields['UserEmail'] = widget.email;

      try {
        final response = await request.send();

        if (response.statusCode != 200) {
          final data = jsonDecode(await response.stream.bytesToString());
          final BaseApiResponse result =
              BaseApiResponse.fromJson(data, (json) => {});

          if (result.success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationComplete(email: widget.email),
              ),
            );
          }
        }
        //todo: feedback in case of failure
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'There was an error setting up your account please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildBackButton(),
          buildHeaderText(),
          ProfilePictureUpload(
            onImageSelected: onImageSelected,
          ),
          Form(
            key: accountUpdateFormKey,
            child: Column(
              children: [
                UnderlinedTextField(
                  controller: nameController,
                  hintText: "Username",
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: CTAButton(
              text: "Submit",
              onPressed: submitForm,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHeaderText() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Setup",
            style: TextStyle(fontSize: 46),
          ),
          Text(
            "Finish your account setup by uploading profile picture and set your username.",
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }

  Row buildBackButton() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: ArrowBackButton(),
        ),
      ],
    );
  }
}
