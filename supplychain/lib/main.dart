import 'package:flutter/material.dart' show MaterialApp, runApp;
import 'package:supplychain/SignUpPage.dart';
import 'package:supplychain/LogInPage.dart';
import 'package:supplychain/OtpVerifyPage.dart';
import 'package:supplychain/ProfileChooserPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Supply Chain",
    home: LogInPage(),
    routes: {
      "/LoginPage": (context) => LogInPage(),
      "/SignUpPage": (context) => SignUpPage(),
      "/OtpVerifyPage": (context) => OtpVerifyPage(),
      "/ProfileChooserPage": (context) => ProfileChooserPage(),
    },
  ));
}
