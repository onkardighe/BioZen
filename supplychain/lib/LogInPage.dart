import 'package:flutter/material.dart';
import 'utils/Authentication.dart';
import 'utils/appTheme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInPage extends StatefulWidget {
  

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  const Spacer(),
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
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _mobileController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            label: Text("Mobile Number"),
                            labelStyle: TextStyle(),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          obscureText: true,
                          controller: _passController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.visibility),
                            label: Text("Password"),
                            counterText: 'Forgot Password ?',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 50)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ))),
                          onPressed: () {
                            if (_mobileController.value.text.isNotEmpty &&
                                _passController.value.text.isNotEmpty) {
                              // log in
                            }
                          },
                          child: const Text('Log In',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text("Or Log in with "),
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
                        Navigator.pushNamed(context, "/SignUpPage");
                        setState(() {});
                      },
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "Don't have an account ? ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(color: Colors.blue)),
                            ]),
                      )),
                  Spacer()
                ],
              )),
            )));
  }
}
