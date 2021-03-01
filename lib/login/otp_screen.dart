import 'package:demo_flutter/util/StringUtils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:demo_flutter/login/login_bloc.dart';
import 'package:demo_flutter/login/login_info.dart';
import 'package:provider/provider.dart';

// https://github.com/adar2378/pin_code_fields
class OtpScreen extends StatefulWidget {
  @override
  _OtpScreen createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  bool hasError = false;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    LoginBloc _bloc = Provider.of<LoginBloc>(context);

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
                _title2(_bloc.dialCode, _bloc.phone),
                SizedBox(height: 20,),
                _pinCodeForm(context),
                _middlePadding(),
                SizedBox(height: 20,),
                _middleText(),
                SizedBox(height: 14,),
                _verifyButton(context),
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

  Padding _title2(String dialCode, String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: RichText(
        text: TextSpan(
            text: "Enter the code sent to ",
            children: [
              TextSpan(
                  text: dialCode,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )
              ),
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

  Container _verifyButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
      child: ButtonTheme(
        height: 50,
        child: FlatButton(
          onPressed: () {
            print(currentText);
            LoginInfo _bloc = Provider.of<LoginInfo>(context);
            _bloc.setLogin(true);
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => HomeScreen)
            // );
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

  String _pinCodeValidator(String v) {
    if(StringUtils.isDigits(v)) {
      return null;
    }

    return "Please input digit";
  }
}