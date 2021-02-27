import 'package:demo_flutter/login/login.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/login/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
      child: MaterialApp(
        title: 'Login Demo',
        home: LoginScreen(),
      ),
    );
    // return MaterialApp(
    //   title: 'Login Demo',
    //   home: LoginScreen(),
    //   );
  }
}