import 'package:flutter/material.dart';

class ErrorService {
  void displaySnackbarError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? "An unexpected error occurred."),
      ),
    );
  }

  void displayFieldErrors(
      BuildContext context,
      Map<String, List<String>>? errors,
      Function(Map<String, String>) setFieldErrors) {
    if (errors != null) {
      setFieldErrors(
        errors.map((key, value) => MapEntry(key, value.join(', '))),
      );
    }
  }
}
