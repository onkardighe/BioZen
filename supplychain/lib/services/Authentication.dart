import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplychain/pages/ProfileChooserPage.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/pages/HomePage.dart';
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
    final GoogleSignIn firebaseAuth = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await firebaseAuth.signOut();
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

  static saveUserMapWithAddress(String uid, publicWalletAddress) async {
    var userSnapByAddress = FirebaseFirestore.instance
        .collection('usersByAddress')
        .doc(publicWalletAddress);
    var docByAddrress = await userSnapByAddress.get();

    if (docByAddrress.exists) {
      await userSnapByAddress.update({'uid': uid});
    } else {
      await userSnapByAddress.set({'uid': uid});
    }
  }

  static saveUser(String email, name, uid, publicWalletAddress) async {
    var userSnap = FirebaseFirestore.instance.collection('users').doc(uid);
    var doc = await userSnap.get();

    if (!doc.exists) {
      await userSnap.set(
          {'email': email, 'name': name, 'publicAddress': publicWalletAddress});
    }
  }

  static updateUserType(String uid, type) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'type': type});
  }

  static Future<bool> isMobileLinked(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() as Map<String, dynamic>;
    return data.containsKey("mobile");
  }

  static Future<bool> isPrivateKeyAdded(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() as Map<String, dynamic>;
    return data.containsKey("privateAddress");
  }

  static Future<User?> signUpWithEmail(
      {required BuildContext context,
      required String email,
      required String password,
      required String? name,
      required String publicWalletAddress}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.updatePhotoURL(
          "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png");

      String uid = userCredential.user!.uid;
      await saveUser(email, name, uid, publicWalletAddress);
      await saveUserMapWithAddress(uid, publicWalletAddress);
      //save to firestore
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

  static Future<User?> logInUser(
      {required String email,
      required String password,
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