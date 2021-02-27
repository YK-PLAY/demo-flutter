import 'dart:async';
import 'package:demo_flutter/login/constants.dart';

class LoginValidator {
  final validatePhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if(RegExp(r"^(?:[+0]+)?[0-9]{6,14}$").hasMatch(phone)) {
        sink.add(phone);
      } else {
        sink.addError(LoginConstants.errorPhone);
      }
    }
  );
}