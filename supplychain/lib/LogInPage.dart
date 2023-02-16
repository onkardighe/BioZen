import 'package:flutter/material.dart';
import 'package:supplychain/utils/Authentication.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/HomePage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _errorPassText;
  bool isPasswordVisible = false;
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
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Spacer(),
                  const Text("Log In",
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (input) =>
                              isValidEmail(input!) ? null : "Invalid Email !",
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: const InputDecoration(
                            label: Text(
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
                          height: 25,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          obscureText: !isPasswordVisible,
                          controller: _passController,
                          onChanged: (passwordText) {
                            _errorPassText = null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            errorText: _errorPassText,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              child: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.deepPurple,
                              ),
                            ),
                            label: Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                            counterText: 'Forgot Password ?',
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
                          height: 35,
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
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(200, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder())),
                            onPressed: () async {
                              if (_emailController.value.text.isNotEmpty &&
                                  isValidEmail(_emailController.value.text) &&
                                  _passController.value.text.isNotEmpty) {
                                // log in
                                User? tempUser = await loginUser();
                                if (tempUser != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                          user: tempUser!,
                                          name: tempUser.displayName),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _errorPassText =
                                        "Sign up failed, Try agin !";
                                  });
                                }
                              } else {
                                setState(() {
                                  _errorPassText = "Invalid Credentials";
                                });
                              }
                            },
                            child: const Text('Log In',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/SignUpPage");
                      },
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "Don't have an account ? ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                      color: Colors.deepPurple.shade500)),
                            ]),
                      )),
                  SizedBox(
                    height: 30,
                  )
                ],
              )),
            )));
  }

  Future<User?> loginUser() async {
    User? user = await Authentication.logInUser(
        email: _emailController.value.text,
        password: _passController.value.text,
        context: context);
    return user;
  }

  bool isValidEmail(String str) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(str);
  }
}
