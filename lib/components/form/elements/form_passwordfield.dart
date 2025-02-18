import 'package:flutter/material.dart';

class StyledPasswordFormField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final TextEditingController? passwordController;
  final bool confirmPassword;
  final String? errorText;

  const StyledPasswordFormField({
    super.key,
    required this.fieldName,
    required this.controller,
    this.passwordController,
    this.confirmPassword = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              fieldName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
            obscureText: true,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${fieldName.toLowerCase()}';
              }

              final regex = RegExp(r'^[A-Za-z0-9!@#\$%^&*()_+]{8,}$');
              if (!regex.hasMatch(value)) {
                return 'Please enter a valid ${fieldName.toLowerCase()}';
              }

              if (confirmPassword && value != passwordController?.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: Color(0xFF67A1A6)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                borderSide: BorderSide(color: Color(0xFF67A1A6)),
              ),
              fillColor: const Color(0xFF67A1A6),
              filled: true,
              errorText: errorText, // Display error message here
            ),
          ),
        ],
      ),
    );
  }
}
