import 'dart:async';

import 'package:demo_flutter/login/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with LoginValidator {

  final _phone = BehaviorSubject<String>();
  final _dialCode = BehaviorSubject<String>();

  Stream<String> get phone => _phone.stream.transform(validatePhone);
  Stream<String> get dialCode => _dialCode.stream;

  String get getPhone => _phone.value;
  String get getDialCode => _dialCode.value;

  // setter
  Function(String) get changePhone => _phone.sink.add;
  Function(String) get changeDialCode => _dialCode.sink.add;

  dispose() async {
    await _phone.drain();
    _phone.close();

    await _dialCode.drain();
    _dialCode.close();
  }
}