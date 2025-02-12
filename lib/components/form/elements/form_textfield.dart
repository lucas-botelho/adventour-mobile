import 'package:flutter/material.dart';

class StyledTextFormField extends StatelessWidget {
  final String fieldName;
  final RegExp regExp;
  final TextEditingController? controller;

  const StyledTextFormField(
      {super.key,
      required this.fieldName,
      required this.regExp,
      this.controller});

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
          TextFormFieldStyling(context),
        ],
      ),
    );
  }

  TextFormField TextFormFieldStyling(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value != null && !regExp.hasMatch(value)) {
          return 'Please enter a valid ${fieldName.toLowerCase()}';
        }
        return null;
      },
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
          color: Theme.of(context)
              .colorScheme
              .error, // Automatically gets error color
        ),
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
        // labelText: 'Name',
        fillColor: const Color(0xFF67A1A6),
        filled: true,
      ),
    );
  }
}
