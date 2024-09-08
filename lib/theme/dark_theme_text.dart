import 'package:flutter/material.dart';
import 'package:appsagetechwiz/theme/dark_color_scheme.dart';

final TextTheme darkTextTheme = TextTheme(
  headlineMedium: TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface,
    letterSpacing: 0.25,
  ),
  headlineSmall: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface,
  ),
  titleLarge: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: darkColorScheme.onSurface.withOpacity(0.87),
    letterSpacing: 0.15,
  ),
  titleMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface.withOpacity(0.87),
    letterSpacing: 0.15,
  ),
  titleSmall: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: darkColorScheme.primary,
    letterSpacing: 0.1,
  ),
  bodyLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface.withOpacity(0.87),
    letterSpacing: 0.5,
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface.withOpacity(0.87),
    letterSpacing: 0.25,
  ),
  bodySmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSurface.withOpacity(0.87),
    letterSpacing: 0.4,
  ),
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: darkColorScheme.onSecondary,
    letterSpacing: 1.25,
  ),
  labelSmall: TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: darkColorScheme.onSecondary,
    letterSpacing: 1.5,
  ),
);
