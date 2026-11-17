import 'package:flutter/material.dart';

final ColorScheme _scheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF0F766E),
  brightness: Brightness.light,
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _scheme,
  scaffoldBackgroundColor: _scheme.surface,
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 15, height: 1.45),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: _scheme.surface,
    foregroundColor: _scheme.onSurface,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: _scheme.surfaceContainerLow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: _scheme.outlineVariant),
    ),
    margin: EdgeInsets.zero,
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _scheme.surfaceContainerLowest,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _scheme.surfaceContainerLow,
    indicatorColor: _scheme.secondaryContainer,
  ),
);
