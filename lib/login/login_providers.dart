import 'package:demo_flutter/login/login_info.dart';
import 'package:demo_flutter/login/login_bloc.dart';
import 'package:provider/provider.dart';

class LoginProviders {
  static List<SingleChildCloneableWidget> providers() {
    return [
      ChangeNotifierProvider<LoginInfo>(create: (context) => LoginInfo(),),
      ChangeNotifierProvider<LoginBloc>(create: (context) => LoginBloc(),),
    ];
  }
}