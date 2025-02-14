import 'package:flutter/material.dart';
import 'package:adventour/components/cta/arrow_back_button.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountSetup extends StatelessWidget {
  const AccountSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 69, 70),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArrowBackButton(),
            const SizedBox(height: 50),

            // Title & Subtitle
            const _Header(),

            const SizedBox(height: 40),

            // Profile Picture Upload
            const Center(child: _ProfilePictureUpload()),

            const SizedBox(height: 40),

            // Username Input
            const _UsernameInput(),

            const SizedBox(height: 100),

            // Create Account Button
            const _CreateAccountButton(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Header Section
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Setup',
          style: GoogleFonts.maidenOrange(
            color: Colors.white,
            fontSize: 57,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Finish your account setup by uploading a profile picture and setting your username.',
          style: GoogleFonts.maidenOrange(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Profile Picture Upload
class _ProfilePictureUpload extends StatelessWidget {
  const _ProfilePictureUpload();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 65, 150, 157),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 100,
            color: Colors.black,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.download,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// Username Input Field
class _UsernameInput extends StatelessWidget {
  const _UsernameInput();

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.person_outline, size: 40, color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade200),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade100),
        ),
      ),
    );
  }
}

// Create Account Button
class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          // Add your account creation logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 65, 150, 157),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          'Create Account',
          style: GoogleFonts.maidenOrange(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
