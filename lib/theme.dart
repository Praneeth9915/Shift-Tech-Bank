import 'package:flutter/material.dart';

class AppTheme {
  static const Color seed = Color(0xFF1B5E9E);

  static ThemeData _build(Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: b),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);
}
