import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:demo_flutter/app_config.dart';
import 'package:demo_flutter/login/login_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginBloc with ChangeNotifier {
  static const String TOKEN_SECURITY_KEY = 'token';

  // Create storage
  final storage = new FlutterSecureStorage();

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

  Future<String> validToken(BuildContext context) {
    return storage.read(key: TOKEN_SECURITY_KEY).then((token) async {
      if(token?.isEmpty?? true) {
        return null;
      }

      final AppConfig config = Provider.of<AppConfig>(context);
      final String url = 'http://' + config.host + '/api/v1.0/auth/user/token/$token/expiry-date';
      final response = await getJson(url,);
      if(response == null || response.statusCode != HttpStatus.ok) {
        return null;
      }

      print(response.body);
      final resMap = jsonDecode(response.body);
      final bool refreshable = resMap['refreshable'];
      if(refreshable) return null;

      return token;
    });
  }

  void saveToken(String token) {
    if(token?.isEmpty?? true) {
      return;
    }

    storage.write(key: TOKEN_SECURITY_KEY, value: token).then((_) => print('Save token done.'));
  }

  void countryCodePickerOnPress(CountryCode countryCode) {
    print(countryCode);
    setDialCode(countryCode.dialCode);
  }

  void authReq(BuildContext context, Function(BuildContext) success, Function failure) async {
    print("Phone: $_phone, dialCode: $_dialCode");

    final AppConfig config = Provider.of<AppConfig>(context);
    final String url = 'http://' + config.host + '/api/v1.0/auth/user/certification-number';
    print(url);

    final response = await postJson(
      url,
      body: jsonEncode(<String, String> {
        'cellphone': _phone,
        'deviceId': 'asdf',
      }),
    );

    if(response == null || response.statusCode != HttpStatus.created) {
      print(response.statusCode);
      failure();
      setAlert(LoginConstants.errorSummit);
      return;
    }

    success(context);
  }

  void verifyPinCode(BuildContext context, Function(BuildContext, String) verifySuccess, Function(BuildContext) verifyTooMany) async {
    print("PinCode: $_pinCode");

    final AppConfig config = Provider.of<AppConfig>(context);
    final String url = 'http://' + config.host + '/api/v1.0/auth/user/token';
    print(url);

    final response = await postJson(
      url,
      body: jsonEncode(<String, String> {
        'cellphone': _phone,
        'deviceId': 'asdf',
        'authNumber': _pinCode,
      }),
    );

    if(response == null || response.statusCode != HttpStatus.ok) {
      if(++_pinCodeErrorCount >= 3) {
        _pinCodeErrorCount = 0;
        verifyTooMany(context);
      }
      return;
    }

    final resMap = jsonDecode(response.body);
    final token = resMap['token'];
    print('token: $token');
    verifySuccess(context, token);
  }

  Future<http.Response> getJson(String url, {body}) {
    return http.get(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
    ).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        print('Timeout');
        return null;
      },
    );
  }

  Future<http.Response> postJson(String url, {body}) {
    return http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    ).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        print('Timeout');
        return null;
      },
    );
  }
}