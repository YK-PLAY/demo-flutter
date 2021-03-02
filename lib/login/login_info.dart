
import 'package:flutter/material.dart';

class LoginInfo with ChangeNotifier {
  bool _login = false;
  String _sessionKey;

  bool get login => _login;
  String get sessionKey => _sessionKey;

  void setLogin(bool value) {
    _login = value;
    notifyListeners();
  }

  void setSessionKey(String value) {
    _sessionKey = value;
  }
}