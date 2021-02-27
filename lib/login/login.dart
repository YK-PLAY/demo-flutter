import 'dart:collection';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:demo_flutter/home/home.dart';
import 'package:demo_flutter/login/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  Locale _myLocale;

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
      return Scaffold(
        body: _loginForm(),
      );
    }
  }

  @override
  void initState() {
    // _tryLogin();
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = LoginBlocProvider.of(context);
    _myLocale = Localizations.localeOf(context);

    print(_myLocale.countryCode);
  }


  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _loginForm() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            stream: _bloc.phone,
            builder: (context, snapshot) {
              return Column(
                  children: <Widget>[
                    _phoneInputForm(snapshot.error),
                    SizedBox(height: 32,),
                    _summitButton(),
                    SizedBox(height: 32,),
                  ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _phoneInputForm(String error) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  print(countryCode);
                  _bloc.changeDialCode(countryCode.dialCode);
                },
                initialSelection: _myLocale.countryCode,
                favorite: [_myLocale.countryCode],
                showCountryOnly: false,
                alignLeft: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: _bloc.changePhone,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Please enter your phone",
                errorText: error,
                labelText: "Phone",
                labelStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summitButton() {
    return RaisedButton(
      onPressed: () {
        print("Phone: ${_bloc.getPhone}, dialCode: ${_bloc.getDialCode}");
      },
      child: Text(
        "SUMMIT".toUpperCase(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      color: Colors.blue,
    );
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


}