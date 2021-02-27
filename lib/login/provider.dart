import 'package:flutter/material.dart';
import 'package:demo_flutter/login/bloc.dart';

class LoginBlocProvider extends InheritedWidget {
  final LoginBloc bloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<LoginBlocProvider>(aspect: LoginBlocProvider());
    return w.bloc;
  }
}