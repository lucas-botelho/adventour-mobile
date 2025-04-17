import 'package:flutter/material.dart';

class ReviewTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isMultiline;
  final int maxChars;
  final String? errorText;

  const ReviewTextInput(
      {super.key,
      required this.controller,
      required this.label,
      this.isMultiline = true,
      this.maxChars = 1000,
      this.errorText});

  @override
  State<ReviewTextInput> createState() => _ReviewTextInputState();
}

class _ReviewTextInputState extends State<ReviewTextInput> {
  late String _currentText;

  @override
  void initState() {
    super.initState();
    _currentText = widget.controller.text;

    widget.controller.addListener(() {
      setState(() {
        _currentText = widget.controller.text;
      });
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;

    const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Rambla',
        fontWeight: FontWeight.w700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textStyle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          maxLength: widget.maxChars,
          minLines: widget.isMultiline ? 5 : 1,
          maxLines: widget.isMultiline ? 8 : 1,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            counterText: "", // hide default counter
            // ⚠️ REMOVE errorText from here
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.errorText != null)
              Text(
                widget.errorText!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontFamily: 'Rambla',
                ),
              )
            else
              const SizedBox(), // Keeps height consistent even without error

            Text(
              "${_currentText.length}/${widget.maxChars} characters",
              style: baseStyle?.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),

      ],
    );
  }
}
