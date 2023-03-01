import 'package:flutter/material.dart';

class AppTheme {
  // static Color primaryColor = Colors.deepPurple;
  static Color primaryColor = Colors.deepPurple;

  LinearGradient themeGradient = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.1, 0.5, 0.7, 0.9],
    colors: [
      Colors.deepPurple.shade600,
      Colors.indigo.shade600,
      Colors.indigo.shade500,
      Colors.blue.shade800,
    ],
  );
}
