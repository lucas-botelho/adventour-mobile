import 'package:flutter/material.dart'; //package with default components
import 'package:adventour/screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

//Starting function
void main() {
  //runApp is a global function that accepts a widget as its argument and inflates that widget to the screen of the device
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
        ).copyWith(
          surface: const Color(0xFF134546),
        ),
        scaffoldBackgroundColor: const Color(0xFF134546),
        textTheme: TextTheme(
          bodyLarge:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 16),
          bodyMedium:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 14),
          bodySmall:
              GoogleFonts.maidenOrange(color: Colors.white, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle:
                GoogleFonts.maidenOrange(color: Colors.white, fontSize: 16),
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
      ),
      home: const Scaffold(
        body: AuthScreen(),
      ),
      // routes: ,
    );
  }
}
