// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/pages/ProfileChooserPage.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // User thisUser;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();
  TextEditingController _walletAddressController = TextEditingController();
  String? _errorTextPassNew,
      _errorTextPassConfirm,
      _errorTextEmail,
      _errorWalletAddress,
      _errorTextName;
  String tempUserName = "Onkar Dighe";
  bool isPasswordVisible = false,
      isConfirmPasswordVisible = false,
      isWalletAddressVisible = false;
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
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.89,
                color: Colors.grey.shade100,
                child: Center(
                    child: Column(
                  children: [
                    Spacer(),
                    Text("Sign Up",
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (input) => !isValidEmail(input!)
                                ? "Invalid Email !"
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              errorText: _errorTextEmail,
                              label: Text(
                                "Email",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: AppTheme.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.primaryColor),
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
                          TextFormField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z ]'))
                            ],
                            onChanged: (input) {
                              _errorTextName =
                                  input.isEmpty ? "Enter Name !" : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (input) =>
                                input!.isEmpty ? "Enter Name !" : null,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              errorText: _errorTextName,
                              label: Text(
                                "Name",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: AppTheme.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.primaryColor),
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
                          TextField(
                            controller: _passController,
                            obscureText: !isPasswordVisible,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15),
                            ],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              errorText: _errorTextPassNew,
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
                                "Create new password",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: AppTheme.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintStyle: const TextStyle(color: Colors.black38),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //
                          TextField(
                            // Confirm password field
                            controller: _passConfirmController,
                            obscureText: !isConfirmPasswordVisible,
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
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              errorText: _errorTextPassConfirm,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              label: Text(
                                "Confirm password",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: AppTheme.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.primaryColor),
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
                          TextField(
                            // Wallet Address field
                            controller: _walletAddressController,
                            obscureText: !isWalletAddressVisible,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.primaryColor),
                            onChanged: (walletAddress) {
                              _errorWalletAddress = walletAddress.length == 42
                                  ? null
                                  : 'Invalid wallet Address !';
                            },
                            decoration: InputDecoration(
                              errorText: _errorWalletAddress,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isWalletAddressVisible =
                                        !isWalletAddressVisible;
                                  });
                                },
                                child: Icon(
                                  isWalletAddressVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              label: Text(
                                "Wallet Public address",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: AppTheme.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppTheme.primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppTheme.primaryColor),
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
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ))),
                              onPressed: () async {
                                // check for passwords equal
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

                                // check for wallet Address
                                if (_walletAddressController.value.text
                                            .trim()
                                            .length !=
                                        42 ||
                                    !RegExp('^0x[a-fA-F0-9]{40}').hasMatch(
                                        _walletAddressController.value.text
                                            .trim())) {
                                  _errorWalletAddress =
                                      'Invalid wallet Address !';
                                } else {
                                  _errorWalletAddress = null;
                                }

                                // check for email
                                if (_emailController.value.text.length <= 0 ||
                                    !isValidEmail(
                                        _emailController.value.text)) {
                                  setState(() {
                                    _errorTextEmail = "Invalid Email !";
                                  });
                                } else if (_nameController.value.text.isEmpty) {
                                  _errorTextName = "Enter Name !";
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
                                    user = tempUser;
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileChooserPage(
                                                  user: tempUser)),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/LoginPage");
                        },
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: "Already registered ? ",
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        color: AppTheme.primaryColor)),
                              ]),
                        )),
                    Spacer()
                  ],
                )),
              ),
            )));
  }

  Future<User?> _SignUp() async {
    User? user = await Authentication.signUpWithEmail(
        context: context,
        email: _emailController.value.text,
        password: _passConfirmController.value.text,
        name: _nameController.value.text.trim(),
        publicWalletAddress: _walletAddressController.value.text.trim());

    return user;
  }

  bool isValidEmail(String str) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(str);
  }
}
