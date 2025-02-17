import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureUpload extends StatefulWidget {
  final Function(File?)
      onImageSelected; // Callback to pass image to parent widget

  const ProfilePictureUpload({super.key, required this.onImageSelected});

  @override
  State<ProfilePictureUpload> createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  File? selectedImage; // Holds the selected image

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });

      // Pass the selected image to the parent
      widget.onImageSelected(selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage, // Open gallery when tapped
      child: Stack(
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 65, 150, 157),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: selectedImage != null
                  ? Image.file(selectedImage!, fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 100, color: Colors.black),
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
              child: const Icon(Icons.upload, size: 30, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
