import 'package:flutter/material.dart';

class RegistrationComplete extends StatelessWidget {
  final String userId;
  final String name;
  final String imageUrl;

  const RegistrationComplete(
      {super.key,
      required this.userId,
      required this.name,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Complete'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registration Complete!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome, $name!',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
