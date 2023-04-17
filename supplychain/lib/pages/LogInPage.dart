// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/utils/constants.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late SupplyController supplyController;
  String? _errorPassText;
  bool isPasswordVisible = false;
  bool loggingIn = false;
  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
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
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.89,
                color: Colors.grey.shade100,
                child: Center(
                    heightFactor: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) => isValidEmail(input!)
                                    ? null
                                    : "Invalid Email !",
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: AppTheme.primaryColor),
                                decoration: InputDecoration(
                                  label: Text(
                                    "Email",
                                    style:
                                        TextStyle(color: AppTheme.primaryColor),
                                  ),
                                  floatingLabelStyle:
                                      TextStyle(color: AppTheme.primaryColor),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppTheme.primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppTheme.primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                                style: TextStyle(color: AppTheme.primaryColor),
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
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  label: Text(
                                    "Password",
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  counterText: 'Forgot Password ?',
                                  floatingLabelStyle:
                                      TextStyle(color: AppTheme.primaryColor),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppTheme.primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppTheme.primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              loggingIn
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: AppTheme.primaryColor,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: AppTheme().themeGradient,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.transparent),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    const Size(200, 50)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder())),
                                        onPressed: () async {
                                          if (_emailController
                                                  .value.text.isNotEmpty &&
                                              isValidEmail(_emailController
                                                  .value.text) &&
                                              _passController
                                                  .value.text.isNotEmpty) {
                                            // log in
                                            User? tempUser = await loginUser();
                                            if (tempUser != null) {
                                              user = tempUser;
                                              await DatabaseService()
                                                  .fetchDataOfUser(
                                                      user.uid, 'publicAddress')
                                                  .then((value) async {
                                                if (value == null) {
                                                  return;
                                                }

                                                publicKey = value;
                                                await supplyController
                                                    .getSuppliesOfUser()
                                                    .then((res) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(),
                                                    ),
                                                  );
                                                });
                                              });
                                            } else {
                                              setState(() {
                                                _errorPassText =
                                                    "Sign up failed, Try agin !";
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _errorPassText =
                                                  "Invalid Credentials";
                                            });
                                          }
                                        },
                                        child: const Text('Log In',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                              const SizedBox(
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/SignUpPage");
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
                                            color: AppTheme.primaryColor)),
                                  ]),
                            )),
                      ],
                    )),
              ),
            )));
  }

  Future<User?> loginUser() async {
    setState(() {
      loggingIn = true;
    });
    User? user = await Authentication.logInUser(
        email: _emailController.value.text,
        password: _passController.value.text,
        context: context);
    setState(() {
      loggingIn = false;
    });
    return user;
  }

  bool isValidEmail(String str) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(str);
  }
}
