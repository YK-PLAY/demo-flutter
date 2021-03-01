import 'package:flutter/material.dart';

class LoginBloc with ChangeNotifier {
  String _phone;
  String _dialCode;

  String get phone => _phone;
  String get dialCode => _dialCode;

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setDialCode(String value) {
    _dialCode = value;
    notifyListeners();
  }

  void setDialCodeWithoutNotify(String value) {
    _dialCode = value;
  }
}