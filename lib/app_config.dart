import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {

  final String env;

  AppConfig(this.env);

  static Future<AppConfig> loadForEnvironment(String env) async {
    env = env ?? 'dev';

    final contents = await rootBundle.loadString('assets/config/$env.json');
    final json = jsonDecode(contents);

    return AppConfig(env);
  }
}