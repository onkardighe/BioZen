import 'package:flutter/material.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/pages/SignUpPage.dart';
import 'package:supplychain/pages/LogInPage.dart';
import 'package:provider/provider.dart';
import 'services/supplyController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/services/Authentication.dart';

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
  @override
  Widget build(BuildContext context) {
    

    return ChangeNotifierProvider(
      create: (_) => NoteController(),
      child: MaterialApp(
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
          // HomePage()
        },
      ),
    );
  }
}
