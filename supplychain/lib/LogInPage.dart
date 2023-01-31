import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _usernameController = TextEditingController();
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
                          controller: _usernameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            label: Text("Username"),
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
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 50)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                          color: Colors.grey)))),
                          onPressed: () {
                            if (_usernameController.value.text.isNotEmpty &&
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
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/64/281/281764.png'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/SignUpPage");
                        setState(() {});
                      },
                      child: const Text("NEW USER ? Sign up",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              )),
            )));
  }
}
