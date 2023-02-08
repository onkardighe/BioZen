import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/ProfileChooserPage.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/HomePage.dart';
import 'package:supplychain/utils/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // User thisUser;
  TextEditingController _passController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _errorTextPassNew, _errorTextPassConfirm, _errorTextEmail;
  String tempUserName = "Onkar Dighe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppTheme().themeGradient)),
          centerTitle: true,
          title: const Text(
            "Supply Chain",
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  const Text("Sign Up",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 35,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            blurStyle: BlurStyle.normal)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: _emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9@.]'))
                          ],
                          onChanged: ((email) {
                            setState(() {
                              _errorTextEmail = !isValidEmail(email)
                                  ? "Invalid Email !"
                                  : null;
                            });
                          }),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (input) =>
                              !isValidEmail(input!) ? "Invalid Email !" : null,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            errorText: _errorTextEmail,
                            label: const Text(
                              "Email",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            floatingLabelStyle:
                                TextStyle(color: Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            errorText: _errorTextPassNew,
                            suffixIcon: const Icon(
                              Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                            label: const Text(
                              "Create new password",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            floatingLabelStyle:
                                TextStyle(color: Colors.deepPurple),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintStyle: const TextStyle(color: Colors.black38),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _passConfirmController,
                          obscureText: true,
                          onChanged: (passConfirmed) {
                            _errorTextPassConfirm =
                                passConfirmed != _passController.value.text
                                    ? "Password does not match !"
                                    : null;
                            setState(() {});
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            errorText: _errorTextPassConfirm,
                            suffixIcon: const Icon(
                              Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                            label: const Text(
                              "Confirm password",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            floatingLabelStyle:
                                TextStyle(color: Colors.deepPurple),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme().themeGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),

                                // change width of the button
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(200, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ))),
                            onPressed: () async {
                              if (_passConfirmController.value.text ==
                                  _passController.value.text) {
                                setState(() {
                                  _errorTextPassConfirm = null;
                                });
                              } else {
                                setState(() {
                                  _errorTextPassConfirm =
                                      "Password does not match !";
                                });
                              }

                              if (_emailController.value.text.length <= 0 ||
                                  !isValidEmail(_emailController.value.text)) {
                                setState(() {
                                  _errorTextEmail = "Invalid Email !";
                                });
                              } else if (_errorTextPassConfirm != null ||
                                  _passConfirmController.value.text.length <=
                                      0) {
                                setState(() {
                                  _errorTextPassConfirm = "Invalid Password";
                                });
                              } else {
                                // do sign up
                                User? tempUser = await _SignUp();
                                if (tempUser != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        // builder: (context) => HomePage(
                                        //   user: tempUser!,
                                        //   name: tempUserName,
                                        // ),

                                        builder: (context) =>
                                            ProfileChooserPage(user: tempUser)),
                                  );
                                } else {
                                  setState(() {
                                    _errorTextEmail = "";
                                    _errorTextPassConfirm =
                                        "Sign up failed, Try agin !";
                                  });
                                }
                              }
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text("or Sign up with "),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          future: Authentication.initializeFirebase(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text(
                                  'Error initializing Firebase ${snapshot.error}');
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return GoogleSignInButton();
                            }
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/LoginPage");
                      },
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "Already registered ? ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  text: "Login",
                                  style: TextStyle(color: Colors.deepPurple)),
                            ]),
                      )),
                  Spacer()
                ],
              )),
            )));
  }

  Future<User?> _SignUp() async {
    User? user = await Authentication.signUpWithEmail(
        context: context,
        email: _emailController.value.text,
        password: _passConfirmController.value.text,
        name: tempUserName);

    return user;
  }

  bool isValidEmail(String str) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(str);
  }
}
