import 'dart:convert';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/styled_image_picker.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:adventour/components/text/title_with_text.dart';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/auth/patch_public_data.dart';
import 'package:adventour/models/responses/auth/patch_public_data.dart';
import 'package:adventour/models/responses/files/file_upload.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

class RegistrationStepThree extends StatefulWidget {
  final String userId;
  final String token;

  const RegistrationStepThree(
      {super.key, required this.userId, required this.token});

  @override
  State<RegistrationStepThree> createState() => _RegistrationStepThreeState();
}

class _RegistrationStepThreeState extends State<RegistrationStepThree> {
  final accountUpdateFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  io.File? profileImage;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ArrowBackButton(),
          const TitleWithText(
            title: "Account Setup",
            text:
                "Finish your account setup by uploading profile picture and set your username.",
          ),
          StyledImagePicker(
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

  void onImageSelected(io.File? image) {
    setState(() {
      profileImage = image;
    });
  }

  void submitForm() async {
    final profilePictureUrl = await uploadProfilePicture();
    await patchUserPublicData(profilePictureUrl);
  }

  Future<void> patchUserPublicData(String profilePictureUrl) async {
    if (accountUpdateFormKey.currentState!.validate() &&
        profilePictureUrl.isNotEmpty) {
      try {
        final response = await http.patch(
          Uri.parse(
              '${AppSettings.apiBaseUrl}/${Authentication.user}/${widget.userId}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode(
            PatchUserPublicDataRequest(
              userName: nameController.text,
              imagePublicUrl: profilePictureUrl,
              userId: widget.userId,
            ).toJson(),
          ),
        );

        if (response.statusCode == 200) {
          // final data = jsonDecode(response.body);
          // final BaseApiResponse<PatchUserPublicDataResponse> result =
          //     BaseApiResponse<PatchUserPublicDataResponse>.fromJson(
          //         data, (json) => PatchUserPublicDataResponse.fromJson(json));

          // if (result.success && result.data!.updated) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => RegistrationComplete(
          //           token: widget.token,
          //           userId: widget.userId,
          //           imageUrl: profilePictureUrl,
          //           name: nameController.text),
          //     ),
          //   );
          // }
        }
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

  Future<String> uploadProfilePicture() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${AppSettings.apiBaseUrl}/${Files.upload}'))
      ..files.add(http.MultipartFile.fromBytes(
          'File', profileImage!.readAsBytesSync(),
          filename: profileImage!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // final data = jsonDecode(await response.stream.bytesToString());
        // final BaseApiResponse<FileUploadResponse> result =
        //     BaseApiResponse<FileUploadResponse>.fromJson(
        //         data, (json) => FileUploadResponse.fromJson(json));

        // if (result.success) {
        //   return result.data!.publicUrl;
        // }
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

    return '';
  }
}
