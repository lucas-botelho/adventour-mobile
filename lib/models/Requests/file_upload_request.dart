import 'dart:convert';
import 'dart:io';

class FileUploadRequest {
  final File? file;
  final String email;

  FileUploadRequest({required this.file, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'file': file != null ? base64Encode(file!.readAsBytesSync()) : null,
      'email': email,
    };
  }
}
