import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleDigitInput extends StatelessWidget {
  final TextEditingController controller;
  const SingleDigitInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        style: const TextStyle(fontSize: 40),
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
