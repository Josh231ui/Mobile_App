import 'package:flutter/material.dart';

class C {
  static const navy = Color(0xFF0B1F4B);
  static const blue = Color(0xFF1E88E5);
  static const sky = Color(0xFF4FA8E0);
  static const teal = Color(0xFF26B5A3);
  static const green = Color(0xFF3BB273);
  static const orange = Color(0xFFF08A3C);
  static const yellow = Color(0xFFF5B83D);
  static const purple = Color(0xFF8E6FD8);
  static const red = Color(0xFFE5483F);
}

bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

Color cardColor(BuildContext c) =>
    isDark(c) ? const Color(0xFF1A2440) : Colors.white;

Color subText(BuildContext c) =>
    Theme.of(c).colorScheme.onSurface.withValues(alpha: 0.6);

ThemeData buildTheme(bool dark) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.blue,
      brightness: dark ? Brightness.dark : Brightness.light,
    ),
    scaffoldBackgroundColor:
        dark ? const Color(0xFF0E1526) : const Color(0xFFF2F6FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.navy,
      foregroundColor: Colors.white,
    ),
  );
}
