import 'package:adventour/firebase_options.dart';
import 'package:adventour/global_state.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/respositories/files_respository.dart';
import 'package:adventour/respositories/itinerary_repository.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/auth.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/services/geolocation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'respositories/map_respository.dart';

//Starting function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GlobalAppState()),

    //Providers that don't depend on other providers should be listed first
    Provider<ApiService>(create: (_) => ApiService()),
    Provider<ErrorService>(create: (_) => ErrorService()),
    Provider<GeolocationService>(create: (_) => GeolocationService()),
    //Providers that depend on Providers
    ProxyProvider<ApiService, FirebaseAuthService>(
      update: (_, apiService, authService) =>
          FirebaseAuthService(apiService: apiService),
    ),

    ProxyProvider2<ApiService, FirebaseAuthService, UserRepository>(
      update: (_, apiService, authService, __) =>
          UserRepository(apiService: apiService, authService: authService),
    ),

    ProxyProvider2<ApiService, FirebaseAuthService, ItineraryRepository>(
      update: (_, apiService, authService, __) =>
          ItineraryRepository(apiService: apiService, authService: authService),
    ),

    ProxyProvider2<ApiService, FirebaseAuthService, FileRepository>(
      update: (_, apiService, authService, __) =>
          FileRepository(apiService: apiService, authService: authService),
    ),

    ProxyProvider2<ApiService, FirebaseAuthService, MapRepository>(
      update: (_, apiService, authService, __) =>
          MapRepository(apiService: apiService, authService: authService),
    ),

    ProxyProvider3<ApiService, FirebaseAuthService, UserRepository,
        AttractionRepository>(
      update: (_, apiService, authService, userRepo, __) =>
          AttractionRepository(
        apiService: apiService,
        authService: authService,
        userRepository: userRepo,
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Adventour",
      theme: buildTheme(),
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return const AdventourMap(); // Authenticated
            } else {
              return const AuthScreen(); // Not authenticated
            }
          },
        ),
      ),
      // routes: ,
    );
  }

  ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF134546),
        error: const Color(0xFFD32F2F), // Global error color
      ).copyWith(
        surface: const Color(0xFF134546),
      ),
      scaffoldBackgroundColor: const Color(0xFF134546),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.maidenOrange(color: Colors.white, fontSize: 20),
        bodyMedium: GoogleFonts.maidenOrange(color: Colors.white, fontSize: 16),
        bodySmall: GoogleFonts.maidenOrange(color: Colors.white, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.maidenOrange(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          foregroundColor: Colors.white,
          // Text color
          backgroundColor: const Color(0xFF41969D),
          // Button background color
          minimumSize: const Size(88, 36),
          // Minimum button size
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Button padding
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)), // Button shape
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: GoogleFonts.maidenOrange(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
            foregroundColor: Colors.white),
      ),
    );
  }
}
