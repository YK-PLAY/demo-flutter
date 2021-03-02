import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:demo_flutter/app_config.dart';
import 'package:demo_flutter/login/login_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginBloc with ChangeNotifier {
  String _phone;
  String _dialCode;
  String _alert = LoginConstants.validPhoneMessage;
  String _pinCode;

  int _pinCodeErrorCount = 0;

  String get phone => _phone;
  String get dialCode => _dialCode;
  String get alert => _alert;
  String get pinCode => _pinCode;

  void setPhone(String value) {
    if(!RegExp(r"^(?:[+0]+)?[0-9]{6,14}$").hasMatch(value)) {
      _alert = LoginConstants.errorPhone;
    } else {
      _alert = LoginConstants.validPhoneMessage;
    }

    _phone = value;
    notifyListeners();
  }

  void setDialCode(String value) {
    _dialCode = value;
    notifyListeners();
  }

  void setAlert(String value) {
    _alert = value;
    notifyListeners();
  }

  void setPinCode(String value) {
    _pinCode = value;
    notifyListeners();
  }

  void setDialCodeWithoutNotify(String value) {
    _dialCode = value;
  }

  void initializeDialCode(Locale locale) {
    final String dialCode = codes
        .map((e) => CountryCode(name: "", code: e['code'], dialCode: e['dial_code']))
        .firstWhere((element) => element.code == locale.countryCode)
        .dialCode;

    setDialCodeWithoutNotify(dialCode);
  }

  void countryCodePickerOnPress(CountryCode countryCode) {
    print(countryCode);
    setDialCode(countryCode.dialCode);
  }

  void authReq(BuildContext context, Function(BuildContext) success, Function failure) async {
    print("Phone: $_phone, dialCode: $_dialCode");

    final AppConfig config = Provider.of<AppConfig>(context);
    final String url = 'http://' + config.host + '/api/v1/auth/register';
    print(url);

    final response = await postJson(
      url,
      body: jsonEncode(<String, String> {
        'username': _phone,
        'uuid': 'asdf',
      }),
    );

    if(response == null) {
      failure();
      setAlert(LoginConstants.errorSummit);
      return;
    }

    final resMap = jsonDecode(response.body);
    final int status = resMap['status'];
    if(status == 0) {
      success(context);
    } else {
      failure();
      setAlert(LoginConstants.errorSummit);
    }
  }

  void verifyPinCode(BuildContext context, Function(BuildContext) verifySuccess, Function(BuildContext) verifyTooMany) async {
    print("PinCode: $_pinCode");

    final AppConfig config = Provider.of<AppConfig>(context);
    final String url = 'http://' + config.host + '/api/v1/auth/register/auth';
    print(url);

    final response = await postJson(
      url,
      body: jsonEncode(<String, String> {
        'username': _phone,
        'authNumber': _pinCode,
      }),
    );

    if(response == null) {
      return;
    }

    final resMap = jsonDecode(response.body);
    final int status = resMap['status'];
    if(status == 0) {
      verifySuccess(context);
    } else {
      if(++_pinCodeErrorCount >= 3) {
        _pinCodeErrorCount = 0;
        verifyTooMany(context);
      }
    }
  }

  Future<http.Response> postJson(String url, {body}) {
    return http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    ).timeout(
      Duration(seconds: 1),
      onTimeout: () {
        print('Timeout');
        return null;
      },
    );
  }
}