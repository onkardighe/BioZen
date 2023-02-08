import 'package:flutter/material.dart';
import 'package:supplychain/HomePage.dart';
import 'package:supplychain/SignUpPage.dart';
import 'package:supplychain/LogInPage.dart';
import 'package:supplychain/OtpVerifyPage.dart';
import 'package:supplychain/utils/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supplychain/utils/Authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Authentication.initializeFirebase();
  User thisUser;

  runApp(const myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  // var userType;

  // @override
  // void initState() {
  //   super.initState();
  // }

  // void getType(String uid) async {
  //   userType = await DatabaseService().getType(uid) ?? "";
  //   if (this.mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Supply Chain",
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(
                user: snapshot.data!, name: snapshot.data!.displayName);
          } else {
            return LogInPage();
          }
        }),
      ),
      routes: {
        "/LoginPage": (context) => LogInPage(),
        "/SignUpPage": (context) => SignUpPage(),
      },
    );
  }
}
