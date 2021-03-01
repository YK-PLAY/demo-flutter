
import 'package:flutter/material.dart';

class LoginInfo with ChangeNotifier {
  bool _login = false;

  bool get login => _login;

  void setLogin(bool login) {
    this._login = login;
    notifyListeners();
  }
}