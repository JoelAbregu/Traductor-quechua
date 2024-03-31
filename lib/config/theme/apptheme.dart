import 'package:flutter/material.dart';

class AppTheme {
  Color color = const Color(0xFF364FFD);
  ThemeData getTheme() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.lightBlue);
  }
}
