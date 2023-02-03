import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBZEufvyP1WDZ5i5bcxQ5HgN6c87yHnaEk",
          authDomain: "biofuels-supplychain.firebaseapp.com",
          projectId: "biofuels-supplychain",
          storageBucket: "biofuels-supplychain.appspot.com",
          messagingSenderId: "1095588800639",
          appId: "1:1095588800639:web:256654ec2722f7f957374a",
          measurementId: "G-SPBBZ1NZJV"),
    );

    // TODO: Add auto login logic

    return firebaseApp;
  }





  //???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////
//???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???//////////////////////////////////////////////???////////////////////////////////////////////


  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context)
              .showSnackBar(Authentication.customSnackBar(
            content: 'The account already exists with a different credential.',
          ));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}


class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            )
          : TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                // TODO: Add a method call to the Google Sign-In authenticationrs
                  User? user =
                      await Authentication.signInWithGoogle(context: context);
                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => UserInfoScreen(
                          user: user,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      _isSigningIn = false;
                    });
                  }
                

                setState(() {
                  _isSigningIn = false;
                });
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/64/281/281764.png'),
              ),
            ),
    );
  }
}





class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LogInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("Supply Chain"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: Colors.grey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _user.displayName!,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 16.0),
              _isSigningOut
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context)
                            .pushReplacement(_routeToSignInScreen());
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
