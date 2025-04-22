import 'package:adventour/firebase_options.dart';
import 'package:adventour/screens/main_screen.dart';
import 'package:flutter/material.dart'; //package with default components
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

//Starting function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

//custom widget
//type st and auto complete will give statefull of stateless options to create a new widget
//use StatelessWidget when the UI element does not have any internal data aka dumb widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //build method returns a widget and will be run everytime flutter needs to render the ui like when data changes
  @override
  Widget build(BuildContext context) {
    //MaterialApp is used as root of the app
    //allows to configure themes and routes
    return MaterialApp(
      title: "Adventour",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF134546),
          error: const Color(0xFFD32F2F), // Global error color
        ).copyWith(
          surface: const Color(0xFF134546),
        ),
        scaffoldBackgroundColor: const Color(0xFF134546),
        textTheme: TextTheme(
          bodyLarge:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 20),
          bodyMedium:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 16),
          bodySmall:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.maidenOrange(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
            foregroundColor: Colors.white, // Text color
            backgroundColor: const Color(0xFF41969D), // Button background color
            minimumSize: const Size(88, 36), // Minimum button size
            padding:
                const EdgeInsets.symmetric(horizontal: 16), // Button padding
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(20)), // Button shape
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              textStyle: GoogleFonts.maidenOrange(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
              foregroundColor: Colors.white),
        ),
      ),
      home: const Scaffold(
        body: InitialScreen(),
      ),
      // routes: ,
    );
  }
}
