import 'package:flutter/material.dart';

class UnderlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const UnderlinedTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username cannot be empty.';
          }
          return null;
        },
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          prefixIcon:
              const Icon(Icons.person_outline, size: 40, color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
