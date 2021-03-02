import 'package:country_code_picker/country_code_picker.dart';
import 'package:demo_flutter/home/home.dart';
import 'package:demo_flutter/login/login_bloc.dart';
import 'package:demo_flutter/login/login_info.dart';
import 'package:demo_flutter/login/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Locale _myLocale = Locale('ko', 'KR');

  @override
  Widget build(BuildContext context) {
    LoginInfo loginInfo = Provider.of<LoginInfo>(context);
    if(loginInfo.login) {
      return HomeScreen();
    } else {
      return _loginForm(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // do it after initialize the context
    Provider
        .of<LoginBloc>(context)
        .initializeDialCode(_myLocale);
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _phoneInputForm(context, "Some error!"),
          SizedBox(height: 32,),
          _summitButton(context),
          SizedBox(height: 32,),
        ],
      ),
    );
  }

  Widget _phoneInputForm(BuildContext context, String error) {
    LoginBloc _bloc = Provider.of<LoginBloc>(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: CountryCodePicker(
                onChanged: _bloc.countryCodePickerOnPress,
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
              onChanged: _bloc.setPhone,
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

  Widget _summitButton(BuildContext context) {
    LoginBloc _bloc = Provider.of<LoginBloc>(context);

    return RaisedButton(
      onPressed: () => _bloc.authReq(context, _summitSuccess(), _summitFailure()),
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

  Function(BuildContext) _summitSuccess() {
    return (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(),),
      );
    };
  }

  Function _summitFailure() {
    return () => print('error');
  }
}