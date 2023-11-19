import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider themeProvider = Provider((ref) => ThemeProvider(ref));

class ThemeProvider {
  final ProviderRef ref;
  ThemeProvider(this.ref);

  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
  }
}

class Themes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 87, 86, 86),
    colorScheme: const ColorScheme
        .dark(), // this sets the text-color to white(since its dark theme)
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color.fromARGB(255, 89, 38, 124),
      colorScheme: const ColorScheme.light(),
      fontFamily: 'Jost');
}
