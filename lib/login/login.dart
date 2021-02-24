import 'dart:collection';

import 'package:demo_flutter/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  @override
  Widget build(BuildContext context) {
    if(loggedIn) {
      return HomeScreen();
    } else {
      return _loginPage();
    }
  }

  @override
  void initState() {
    super.initState();

    _tryLogin();
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

  Widget _loginPage() {
    return FlutterLogin(
        title: 'Login',
        logo: 'assets/images/ecorp.png',
        messages: _messages(),
        theme: _theme(),
        onSignup: _onSignUp,
        onLogin: _onLogin,
        onRecoverPassword: null,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
        },
        emailValidator: _usernameValidator,
    );
  }

  LoginMessages _messages() {
    return LoginMessages(
      usernameHint: 'Mobile'
    );
  }

  LoginTheme _theme() {
    return LoginTheme(
      primaryColor: Colors.deepPurple,
      accentColor: Colors.orange,
      titleStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 45.0,
        color: Colors.orange
      ),
      buttonStyle: TextStyle(fontFamily: 'OpenSans',)
    );
  }

  Future<String> _onSignUp(LoginData data) {
    print('[onSignUp] Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) {
      userMap.putIfAbsent(data.name, () => data.password);
      final session = _generateSession(data.name, data.password);
      _saveSession(session);
      return null;
    });
  }

  Future<String> _onLogin(LoginData data) {
    print('[onLogin] Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) {
      if(!userMap.containsKey(data.name)) {
        return 'Username not exists';
      }

      final session = _generateSession(data.name, data.password);
      if(!_validSession(session)) {
        return 'Password does not match';
      }

      _saveSession(session);
      return null;
    });
  }

  String _generateSession(String username, String password) {
    return username + password;
  }

  void _saveSession(String session) async {
    await _storage.write(key: sessionKey, value: session);
  }

  String _usernameValidator(String username) {
    if(username == null) {
      return 'Username is null';
    }

    if(username.length < 8) {
      return 'Username length is less than 8';
    }

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if(!regExp.hasMatch(username)) {
      return 'Please enter valid mobile number';
    }

    return null;
  }
}