import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:demo_flutter/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  void countryCodePickerOnPress(CountryCode countryCode) {
    print(countryCode);
    setDialCode(countryCode.dialCode);
  }

  void authReq(BuildContext context, Function(BuildContext) success, Function failure) async {
    print("Phone: $_phone, dialCode: $_dialCode");

    final AppConfig config = Provider.of<AppConfig>(context);
    final String url = 'http://' + config.host + '/api/v1/auth/register';
    print(url);

    final response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String> {
        'username': _phone,
        'uuid': 'asdf',
      }),
    );

    final resMap = jsonDecode(response.body);
    final int status = resMap['status'];
    if(status == 0) {
      success(context);
    } else {
      failure();
    }
  }
}