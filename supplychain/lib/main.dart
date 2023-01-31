import 'package:flutter/material.dart';
import 'package:supplychain/SignUpPage.dart';
import 'package:supplychain/LogInPage.dart';

void main() {
  runApp(MaterialApp(
    title: "Supply Chain",
    home: LogInPage(),
    routes: {
      "/LoginPage": (context) => LogInPage(),
      "/SignUpPage": (context) => SignUpPage(),
    },
  ));
}
