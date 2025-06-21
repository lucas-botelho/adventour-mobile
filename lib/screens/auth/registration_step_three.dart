import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/styled_image_picker.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:adventour/components/text/title_with_text.dart';
import 'package:adventour/respositories/files_respository.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/layout/auth_appbar.dart';
import 'dart:io' as io;
import 'package:adventour/globals.dart' as globals;
import 'package:provider/provider.dart';

class RegistrationStepThree extends StatefulWidget {
  final String userId;

  const RegistrationStepThree({super.key, required this.userId});

  @override
  State<RegistrationStepThree> createState() => _RegistrationStepThreeState();
}

class _RegistrationStepThreeState extends State<RegistrationStepThree> {
  final accountUpdateFormKey = GlobalKey<FormState>();
  late final UserRepository userRepository;
  late final ErrorService errorService;
  late final FirebaseAuthService authService;
  var nameController = TextEditingController();
  io.File? profileImage;

  late final FileRepository fileRepository;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    errorService = context.read<ErrorService>();
    authService = context.read<FirebaseAuthService>();
    userRepository = context.read<UserRepository>();
    fileRepository = context.read<FileRepository>();
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
                        const SizedBox(height: 20),
                        const TitleWithText(
                          title: "Account Setup",
                          text:
                          "Finish your account setup by uploading profile picture and set your username.",
                        ),
                        const SizedBox(height: 20),
                        StyledImagePicker(
                          onImageSelected: (onImageSelected),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: accountUpdateFormKey,
                          child: UnderlinedTextField(
                            controller: nameController,
                            hintText: "Username",
                          ),
                        ),
                        const SizedBox(height: 40),
                        CTAButton(
                          text: "Submit",
                          onPressed: submitForm,
                        ),
                        const SizedBox(height: 40),
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
      final result = await userRepository.updateUserPublicData(
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
      final response = await fileRepository.uploadSingleFile(
        file: profileImage!,
      );
      if (response.success) {
        return response.data!.publicUrl;
      } else {
        // ignore: use_build_context_synchronously
        errorService.displaySnackbarError(context, response.message);
      }
        } catch (e) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }

    return null;
  }
}
