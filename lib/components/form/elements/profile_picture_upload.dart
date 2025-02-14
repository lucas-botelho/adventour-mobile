import 'package:flutter/material.dart';

class ProfilePictureUpload extends StatelessWidget {
  const ProfilePictureUpload();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 65, 150, 157),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 100,
            color: Colors.black,
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
            child: const Icon(
              Icons.download,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
