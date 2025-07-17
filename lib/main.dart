import 'package:flutter/material.dart';
import 'Main_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Reservation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a classy color scheme
        primaryColor: const Color(0xFF3E2723), // Deep Brown
        primaryColorDark: const Color(0xFF211A18), // Even darker brown
        primaryColorLight: const Color(0xFF5D4037), // Lighter brown
        hintColor: const Color(0xFFD4AF37), // Gold accent
        scaffoldBackgroundColor: const Color(0xFFF5F5DC), // Creamy background
        cardColor: Colors.white, // White cards
        dividerColor: const Color(0xFFD4AF37), // Gold divider

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3E2723), // Deep Brown
          foregroundColor: Colors.white, // White text
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia', // Elegant font
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Text Theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Georgia', fontSize: 57, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          displayMedium: TextStyle(fontFamily: 'Georgia', fontSize: 45, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          displaySmall: TextStyle(fontFamily: 'Georgia', fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          headlineLarge: TextStyle(fontFamily: 'Georgia', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          headlineMedium: TextStyle(fontFamily: 'Georgia', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          headlineSmall: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          titleLarge: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          titleMedium: TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
          titleSmall: TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
          bodyLarge: TextStyle(fontFamily: 'Arial', fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.black87),
          bodySmall: TextStyle(fontFamily: 'Arial', fontSize: 12, color: Colors.black54),
          labelLarge: TextStyle(fontFamily: 'Arial', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          labelMedium: TextStyle(fontFamily: 'Arial', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          labelSmall: TextStyle(fontFamily: 'Arial', fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
        ),

        // Card Theme
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(8),
        ),

        // Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37), // Gold button
            foregroundColor: Colors.white, // White text
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFFD4AF37), // Gold FAB
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF3E2723), // Deep Brown text
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF3E2723), // Deep Brown text
            side: const BorderSide(color: Color(0xFF3E2723)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF3E2723)),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: Color(0xFF3E2723), // Deep Brown icons
        ),
      ),
      home: const MainScreen(),
    );
  }
}


