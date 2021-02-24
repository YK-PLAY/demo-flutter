import 'package:demo_flutter/login/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.deepPurple,
      //   accentColor: Colors.orange,
      //   cursorColor: Colors.orange,
      //   textTheme: TextTheme(
      //     headline3: TextStyle(
      //       fontFamily: 'OpenSans',
      //       fontSize: 45.0,
      //       color: Colors.orange
      //     ),
      //     button: TextStyle(
      //       fontFamily: 'OpenSans',
      //     ),
      //     subtitle1: TextStyle(fontFamily: 'NotoSans'),
      //     bodyText2: TextStyle(fontFamily: 'NotoSans'),
      //   ),
      // ),
      home: LoginScreen(),
      );
  }
}