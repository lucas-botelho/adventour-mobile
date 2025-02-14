import 'package:flutter/material.dart';

class UnderlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const UnderlinedTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon:
            const Icon(Icons.person_outline, size: 40, color: Colors.black),
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
