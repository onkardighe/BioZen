import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/Authentication.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  String? _errorTextPassNew, _errorTextPassConfirm, _errorTextMobile;

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
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _mobileController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            errorText: _errorTextMobile,
                            label: const Text("Mobile Number"),
                            border: const OutlineInputBorder(
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
                          decoration: InputDecoration(
                            errorText: _errorTextPassNew,
                            suffixIcon: const Icon(Icons.visibility),
                            label: const Text("Create new password"),
                            border: const OutlineInputBorder(
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
                          decoration: InputDecoration(
                            errorText: _errorTextPassConfirm,
                            suffixIcon: const Icon(Icons.visibility),
                            label: const Text("Confirm password"),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintStyle: const TextStyle(color: Colors.black38),
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

                              // change width of the button
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 50)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ))),
                          onPressed: () {
                            _errorTextPassConfirm =
                                _passConfirmController.value.text !=
                                        _passController.value.text
                                    ? "Password does not match !"
                                    : null;
                            setState(() {});

                            if (_errorTextPassConfirm == null &&
                                _passConfirmController.value.text.length > 0 &&
                                _mobileController.value.text.length == 10) {
                              _SignUp();
                            } else {
                              _errorTextPassConfirm = "Invalid Password";
                              setState(() {});
                            }
                          },
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
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
                        Navigator.pushNamed(context, "/LoginPage");
                      },
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "Already registered ? ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  text: "LOG IN",
                                  style: TextStyle(color: Colors.blue)),
                            ]),
                      )),
                  Spacer()
                ],
              )),
            )));
  }

  void _SignUp() {
    Navigator.pushNamed(context, "/OtpVerifyPage");
  }
}
