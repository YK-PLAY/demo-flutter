import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:demo_flutter/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const users = const {
  '01012344321@gmail.com': '12345'
};

class LoginScreen extends StatelessWidget {

  Duration get loginTime => Duration(milliseconds: 2250);

  final _storage = FlutterSecureStorage();

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

  Future<String> authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');

    String value = await _storage.read(key: 'session');
    print('read1: $value');
    if(value == null || value == '') {
      await _storage.write(key: 'session', value: 'asgkljklajklsjfl1123');
    }

    String value2 = await _storage.read(key: 'session');
    print('read2: $value2');


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