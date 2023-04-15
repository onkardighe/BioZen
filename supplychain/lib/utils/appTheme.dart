import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Color.fromRGBO(31, 102, 12, 1);
  static Color secondaryColor = Color.fromRGBO(146, 182, 104, 1);
  static Color primaryDark = Color.fromRGBO(31, 102, 12, 1);
  static Color secondaryDark = Color.fromRGBO(61, 131, 11, 1);
  static Color shadowColor = Colors.green.shade900;

  LinearGradient themeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      // Color.fromRGBO(146, 182, 104, 1),
      Color.fromRGBO(78, 144, 29, 1),
      Color.fromRGBO(61, 131, 11, 1),
      Color.fromRGBO(31, 102, 12, 1),
    ],
  );

  //////////////////////// Temp Purple Theme //////////////////////////////////

  // static Color primaryColor = Colors.deepPurple.shade600;
  // static Color secondaryColor = Colors.indigo.shade600;
  // static Color primaryDark = Colors.indigo.shade500;
  // static Color secondaryDark = Colors.blue.shade800;
  // static Color shadowColor = Colors.blue.shade800;

  // LinearGradient themeGradient = LinearGradient(
  //   begin: Alignment.bottomRight,
  //   end: Alignment.topLeft,
  //   stops: [0.1, 0.5, 0.7, 0.9],
  //   colors: [
  //     Colors.deepPurple.shade600,
  //     Colors.indigo.shade600,
  //     Colors.indigo.shade500,
  //     Colors.blue.shade800,
  //   ],
  // );
}
