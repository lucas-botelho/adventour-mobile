import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/auth.dart';
import 'package:adventour/screens/auth/registration_complete.dart';
import 'package:adventour/screens/auth/registration_step_three.dart';
import 'package:adventour/screens/auth/registration_step_two.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainRouter extends StatelessWidget {
  const MainRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<UserRepository>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: repo.getUserData(),
            builder: (_, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final userData = userSnapshot.data?.data;
              final step = userData?.registrationStep ?? 0;

              switch (step) {
                case 1:
                  return RegistrationStepTwo(
                    userId: userData!.id,
                    pinToken: '',
                    email: userData.email,
                  );
                case 2:
                  return RegistrationStepThree(userId: userData?.oauthId ?? '');
                default:
                  return const AdventourMap();
              }
            },
          );
        } else {
          return const AuthScreen();

        }
      },
    );
  }
}
