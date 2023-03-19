import 'package:flutter/material.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/pages/SignUpPage.dart';
import 'package:supplychain/pages/LogInPage.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/utils/constants.dart';
import 'services/supplyController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/services/Authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Authentication.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SupplyController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Supply Chain",
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              user = snapshot.data!;
              return HomePage();
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
