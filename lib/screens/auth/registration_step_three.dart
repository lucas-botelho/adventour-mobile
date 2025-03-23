import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/styled_image_picker.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:adventour/components/text/title_with_text.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'dart:io' as io;
import 'package:adventour/globals.dart' as globals;

class RegistrationStepThree extends StatefulWidget {
  final String userId;

  const RegistrationStepThree({super.key, required this.userId});

  @override
  State<RegistrationStepThree> createState() => _RegistrationStepThreeState();
}

class _RegistrationStepThreeState extends State<RegistrationStepThree> {
  final accountUpdateFormKey = GlobalKey<FormState>();
  final firebaseService = FirebaseAuthService();
  final errorService = ErrorService();
  final userRepsository = UserRepository();
  var nameController = TextEditingController();
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
    if (!accountUpdateFormKey.currentState!.validate()) return;

    final profilePictureUrl = await uploadProfilePicture();

    if (profilePictureUrl == null) {
      errorService.displaySnackbarError(
          // ignore: use_build_context_synchronously
          context,
          "Please upload a valid profile picture.");

      return;
    }

    try {
      final result = await userRepsository.updateUserPublicData(
          widget.userId, nameController.text, profilePictureUrl);

      if (result != null) {
        if (result.success) {
          globals.photoUrl = profilePictureUrl;

          Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationComplete(
                  imageUrl: profilePictureUrl, name: nameController.text),
            ),
            (route) => false,
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

  Future<String?> uploadProfilePicture() async {
    try {
      final response = await userRepsository.uploadProfilePicture(
        profileImage!,
      );
      if (response != null) {
        if (response.success) {
          return response.data!.publicUrl;
        } else {
          // ignore: use_build_context_synchronously
          errorService.displaySnackbarError(context, response.message);
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }

    return null;
  }
}
