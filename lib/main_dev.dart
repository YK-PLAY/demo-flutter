import 'dart:async';

import 'package:demo_flutter/app.dart';
import 'package:demo_flutter/app_config.dart';
import 'package:flutter/material.dart';

void main() async {
  final conf = await AppConfig.loadForEnvironment('dev');
  runApp(App(config: conf,));
}