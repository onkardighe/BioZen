import 'dart:html';

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
  late FocusNode _otp1FocusNode = FocusNode(),
      _otp2FocusNode = FocusNode(),
      _otp3FocusNode = FocusNode(),
      _otp4FocusNode = FocusNode();
  var _mobileNumber = "+91 8999746484";
  var _name = '';
  final _numericRegex = RegExp(r'^[0-9]+$');

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
                          onChanged: (val) => _checkNumeric(1, val),
                          controller: _otp1,
                          focusNode: _otp1FocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP1),
                        )),
                    SizedBox(width: 15),
                    SizedBox(
                        width: 40,
                        child: TextField(
                          focusNode: _otp2FocusNode,
                          controller: _otp2,
                          onChanged: (val) => _checkNumeric(2, val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
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
                          focusNode: _otp3FocusNode,
                          onChanged: (val) => _checkNumeric(3, val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
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
                          focusNode: _otp4FocusNode,
                          onChanged: (val) => _checkNumeric(4, val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorOTP4),
                        )),
                    Spacer()
                  ],
                ),
                SizedBox(
                  height: 70,
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
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ))),
    );
  }

  void _checkNumeric(int idx, String val) {
    if (val.length < 1) return;

    if (idx == 1) {
      if (_numericRegex.hasMatch(val)) {
        _errorOTP1 = null;
        _otp2FocusNode.requestFocus();
      } else {
        _errorOTP1 = '';
      }
    } else if (idx == 2) {
      if (_numericRegex.hasMatch(val)) {
        _errorOTP2 = null;
        _otp3FocusNode.requestFocus();
      } else {
        _errorOTP2 = '';
      }
    } else if (idx == 3) {
      if (_numericRegex.hasMatch(val)) {
        _errorOTP3 = null;
        _otp4FocusNode.requestFocus();
      } else {
        _errorOTP3 = '';
      }
    } else {
      _errorOTP4 = _numericRegex.hasMatch(val) ? null : '';
    }
    setState(() {});
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
