import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/form/elements/profile_picture_upload.dart';
import 'package:adventour/components/form/elements/underlined_textfield.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final accountUpdateFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountUpdateFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArrowBackButton(),
            const SizedBox(height: 50),
            const Header(),
            const SizedBox(height: 40),
            const Center(child: ProfilePictureUpload()),
            const SizedBox(height: 40),
            UnderlinedTextField(
                controller: _nameController, hintText: "Username"),
            const SizedBox(height: 100),
            CTAButton(text: "Create Account", onPressed: () => {}),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Setup',
          style: TextStyle(fontSize: 57),
        ),
        SizedBox(height: 15),
        Text(
            'Finish your account setup by uploading a profile picture and setting your username.',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22)),
      ],
    );
  }
}
