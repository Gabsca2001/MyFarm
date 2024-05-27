import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_farm/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Farm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: GoogleFonts.montserrat(
            fontSize: 24,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontSize: 20,
          ),
          titleSmall: GoogleFonts.montserrat(
            fontSize: 16,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 18,
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 16,
          ),
          bodySmall: GoogleFonts.montserrat(
            fontSize: 14,
          ),
          labelLarge: GoogleFonts.montserrat(
            fontSize: 18,
          ),
          labelMedium: GoogleFonts.montserrat(
            fontSize: 16,
          ),
          labelSmall: GoogleFonts.montserrat(
            fontSize: 14,
          ),
        ),
        
      ),
      routerConfig: router,
    );
  }
}
