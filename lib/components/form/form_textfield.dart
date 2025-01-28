import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String fieldName;
  final RegExp regExp;

  const FormTextField({
    super.key,
    required this.fieldName,
    required this.regExp,
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
          SizedBox(
            height: 39,
            child: TextFormField(
              validator: (value) {
                if (value != null && !regExp.hasMatch(value)) {
                  return 'Please enter a valid ${fieldName.toLowerCase()}';
                }
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Color(0xFF67A1A6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  borderSide: BorderSide(color: Color(0xFF67A1A6)),
                ),
                // labelText: 'Name',
                fillColor: Color(0xFF67A1A6),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
