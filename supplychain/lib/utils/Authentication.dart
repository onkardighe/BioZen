import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplychain/ProfileChooserPage.dart';
import 'package:supplychain/utils/DatabaseService.dart';
import 'package:supplychain/HomePage.dart';
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
        saveUser(
            user!.email!, user!.displayName!, user!.uid!); //save to firestore
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

  static saveUser(String email, name, uid) async {
    var userSnap = FirebaseFirestore.instance.collection('users').doc(uid);
    var doc = await userSnap.get();

    if (!doc.exists) {
      await userSnap.set({'email': email, 'name': name});
    }
  }

  static updateUserType(String uid, type) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'type': type});
  }

  static Future<User?> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.updatePhotoURL(
          "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png");
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(
          "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png");

      await saveUser(email, name, userCredential.user!.uid); //save to firestore
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Password Provided is too weak',
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Email already Exists! Log In',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<User?> signinUser(
      {required String email,
      required String password,
      required,
      required BuildContext context}) async {
    User? user;
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'No user Found with this Email !',
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Wrong Password !'),
        );
      }
    } catch (e) {
      print("Exception in code : ${e}");
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
                      builder: (context) {
                        var t = DatabaseService().getType(user.uid);
                        if (t != null) {
                          print("NOT found");
                          return ProfileChooserPage(user: user);
                        } else {
                          print(
                              "TYpe present ${DatabaseService().getType(user.uid)}");
                          return HomePage(
                            user: user,
                            name: user.displayName,
                          );
                        }
                      },
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
