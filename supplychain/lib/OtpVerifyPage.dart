import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class OtpVerifyPage extends StatefulWidget {
  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  TextEditingController _otp1 = TextEditingController(),
      _otp2 = TextEditingController(),
      _otp3 = TextEditingController(),
      _otp4 = TextEditingController();
  var _errorOTP1, _errorOTP2, _errorOTP3, _errorOTP4;
  var _mobileNumber = "+91 8999746484";
  var _name = '';

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
              child: Center(
            child: Column(
              children: [
                Spacer(),
                Text(
                  "Welcome" + _name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  height: 35,
                ),
                Text("An OTP has been sent to"),
                Text("${_mobileNumber}"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/SignUpPage"),
                  child: Text("Change", style: TextStyle(color: Colors.blue)),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otp1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP1),
                        )),
                    SizedBox(width: 15),
                    SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otp2,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP2),
                        )),
                    SizedBox(width: 15),
                    SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otp3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP3),
                        )),
                    SizedBox(width: 15),
                    SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otp4,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP4),
                        )),
                    Spacer()
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(230, 40)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    onPressed: _verify,
                    child: const Text("Verify",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                Spacer(),
              ],
            ),
          ))),
    );
  }

  void _verify() {
    _errorOTP1 = _otp1.value.text.length == 0 ? '' : null;
    _errorOTP2 = _otp2.value.text.length == 0 ? '' : null;
    _errorOTP3 = _otp3.value.text.length == 0 ? '' : null;
    _errorOTP4 = _otp4.value.text.length == 0 ? '' : null;
    setState(() {});

    if (_errorOTP1 == null &&
        _errorOTP2 == null &&
        _errorOTP3 == null &&
        _errorOTP4 == null) {
      Navigator.pushNamed(context, "/ProfileChooserPage");
    }
  }
}
