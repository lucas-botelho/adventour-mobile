import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/styled_image_picker.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:adventour/components/text/title_with_text.dart';
import 'package:adventour/models/requests/auth/patch_public_data.dart';
import 'package:adventour/models/responses/auth/patch_public_data.dart';
import 'package:adventour/models/responses/files/file_upload.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'dart:io' as io;

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
  final ErrorService errorService = ErrorService();

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
          const ArrowBackButton(),
          const TitleWithText(
            title: "Account Setup",
            text:
                "Finish your account setup by uploading profile picture and set your username.",
          ),
          StyledImagePicker(
            onImageSelected: (onImageSelected),
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
    if (profilePictureUrl != null) patchUserPublicData(profilePictureUrl);
  }

  void patchUserPublicData(String profilePictureUrl) async {
    if (!accountUpdateFormKey.currentState!.validate() ||
        profilePictureUrl.isEmpty) return;

    try {
      final requestModel = PatchUserPublicDataRequest(
        userName: nameController.text,
        imagePublicUrl: profilePictureUrl,
        userId: widget.userId,
      );

      final result = await ApiService().patch(
          endpoint: '${Authentication.user}/${widget.userId}',
          headers: <String, String>{},
          body: requestModel.toJson(),
          fromJsonT: (json) => PatchUserPublicDataResponse.fromJson(json),
          token: widget.token);

      if (result.success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationComplete(
                token: widget.token,
                userId: widget.userId,
                imageUrl: profilePictureUrl,
                name: nameController.text),
          ),
          (route) => false,
        );
      } else {
        errorService.displaySnackbarError(context, result.message);
      }
    } catch (e) {
      errorService.displaySnackbarError(context, null);
    }
  }

  Future<String?> uploadProfilePicture() async {
    try {
      final response = await ApiService().uploadFile(
        endpoint: Files.upload,
        file: profileImage!,
        token: widget.token,
        fromJsonT: (json) => FileUploadResponse.fromJson(json),
      );

      if (response.success) {
        return response.data!.publicUrl;
      } else {
        errorService.displaySnackbarError(context, response.message);
      }
    } catch (e) {
      errorService.displaySnackbarError(context, null);
    }

    return null;
  }
}
