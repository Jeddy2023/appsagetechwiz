import 'package:flutter/material.dart';
import 'package:appsagetechwiz/theme/dark_color_scheme.dart';
import 'package:appsagetechwiz/theme/light_color_scheme.dart';
import 'package:appsagetechwiz/theme/light_theme_text.dart';
import 'package:appsagetechwiz/theme/dark_theme_text.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green[800],
  fontFamily: 'Lato',
  textTheme: lightTextTheme,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white, // Light mode fill color
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.green[800],
  fontFamily: 'Lato',
  textTheme: darkTextTheme,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: const Color(0xFF1B1C1E),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey.shade900, // Dark mode fill color
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black), // Black when focused
    ),
  ),
);
