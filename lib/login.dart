import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:demo_flutter/home.dart';

const users = const {
  '01012344321@gmail.com': '12345'
};

class LoginScreen extends StatelessWidget {

  Duration get loginTime => Duration(milliseconds: 2250);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ZTKMK',
      logo: 'assets/images/ecorp.png',
      onLogin: authUser,
      onSignup: authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(),));
      },
      onRecoverPassword: recoverPassword,
    );
  }

  Future<String> authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future
        .delayed(loginTime)
        .then((_) {
          if(!users.containsKey(data.name)) {
            return 'Username not exists';
          }
          if(users[data.name] != data.password) {
            return 'Password does not match';
          }
          return null;
        });
  }

  Future<String> recoverPassword(String name) {
    print('Name: $name');
    return Future
        .delayed(loginTime)
        .then((_) {
          if(!users.containsKey(name)) {
            return 'Username not exists';
          }
          return null;
        });
  }
}