import 'dart:collection';

import 'package:demo_flutter/home/home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Duration get loginTime => Duration(milliseconds: 2250);

  static final sessionKey = 'session';
  final _storage = FlutterSecureStorage();
  final userMap = new HashMap();

  bool loggedIn = false;

  bool hasError = false;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    if(loggedIn) {
      return HomeScreen();
    } else {
      return _otpPage(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // _tryLogin();
  }

  Widget _otpPage(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
              children: [
                SizedBox(height: 30,),
                _animation(),
                SizedBox(height: 8,),
                _title1(),
                _title2("01012345678"),
                SizedBox(height: 20,),
                _pinCodeForm(context),
                _middlePadding(),
                SizedBox(height: 20,),
                _middleText(),
                SizedBox(height: 14,),
                _verifyButton(),
                SizedBox(height: 16,),
                _bottomButtons(),
              ]
          ),
        ),
      ),
    );
  }

  Container _animation() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
        child: FlareActor(
          "assets/animations/otp.flr",
          animation: "otp",
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        )
    );
  }

  Padding _title1() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "Phone Number Verification",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding _title2(String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: RichText(
        text: TextSpan(
          text: "Enter the code sent to ",
          children: [
            TextSpan(
              text: phoneNumber,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )
            )
          ],
          style: TextStyle(color: Colors.black54, fontSize: 15)
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Form _pinCodeForm(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: _pinCodeTextField(context),
      ),
    );
  }

  PinCodeTextField _pinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      obscureText: true,
      obscuringCharacter: '*',
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: _pinCodeValidator,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: hasError ? Colors.orange : Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.blue.shade50,
      enableActiveFill: true,
      // errorAnimationController: ,
      // controller: ,
      keyboardType: TextInputType.number,
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (v) {
        print('Completed');
      },
      onChanged: (v) {
        print(v);
        setState(() {
          currentText = v;
        });
      },
      beforeTextPaste: (text) => false,
    );
  }

  // TODO - find this role
  Padding _middlePadding() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        hasError ? "*Please fill up all the cells properly" : "",
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  RichText _middleText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Didn't receive the code? ",
        style: TextStyle(
          color: Color(0xFF91D383),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )
      ),
    );
  }

  Container _verifyButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
      child: ButtonTheme(
        height: 50,
        child: FlatButton(
          onPressed: () {

          },
          child: Center(
            child: Text(
              "VERIFY".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            offset: Offset(1, -2),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Colors.green.shade200,
            offset: Offset(-1, 2),
            blurRadius: 5,
          ),
        ]
      ),
    );
  }

  Row _bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: FlatButton(
            child: Text("Clear"),
            onPressed: () {

            },
          ),
        ),
        Flexible(
          child: FlatButton(
            child: Text("Set Text"),
            onPressed: () {

            },
          ),
        ),
      ],
    );
  }

  void _tryLogin() async {
    final String session = await _storage.read(key: sessionKey);
    if(_validSession(session)) {
      loggedIn = true;
    }
  }

  bool _validSession(String session) {
    // TODO - do some network job with server
    return true;
  }

  String _pinCodeValidator(String v) {
    if(v.length < 3) {
      return "I'm from validator";
    } else {
      return null;
    }
  }
}