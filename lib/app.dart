import 'package:demo_flutter/app_config.dart';
import 'package:demo_flutter/login/login_screen.dart';
import 'package:demo_flutter/login/login_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final AppConfig config;

  const App({Key key, this.config}) : super(key: key);

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
    providers.add(Provider<AppConfig>(create: (context) => config,));

    return providers;
  }

}