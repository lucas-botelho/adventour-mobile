import 'dart:io';
import 'package:flutter/material.dart';

class CircularPicture extends StatelessWidget {
  const CircularPicture({
    super.key,
    this.file,
    this.url,
  });

  final File? file;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 65, 150, 157),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: buildImage(),
      ),
    );
  }

  Widget buildImage() {
    if (file != null) {
      return Image.file(file!, fit: BoxFit.cover);
    } else if (url != null) {
      return Image.network(url!, fit: BoxFit.cover);
    } else {
      return const Icon(Icons.person, size: 100, color: Colors.black);
    }
  }
}
