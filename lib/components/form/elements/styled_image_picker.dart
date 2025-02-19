import 'dart:io';
import 'package:adventour/components/form/elements/images/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StyledImagePicker extends StatefulWidget {
  final Function(File?)
      onImageSelected; // Callback to pass image to parent widget

  const StyledImagePicker({super.key, required this.onImageSelected});

  @override
  State<StyledImagePicker> createState() => _StyledImagePickerState();
}

class _StyledImagePickerState extends State<StyledImagePicker> {
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
          CircularPicture(
            file: selectedImage,
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
