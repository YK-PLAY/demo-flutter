import 'package:demo_flutter/login/login_screen.dart';
import 'package:demo_flutter/login/login_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers(),
      child: MaterialApp(
        title: "Demo App",
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    );
  }

  List<SingleChildCloneableWidget> _providers() {
    final List<SingleChildCloneableWidget> providers = new List();
    providers.addAll(LoginProviders.providers());

    return providers;
  }
}