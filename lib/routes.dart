import 'package:flutter/material.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/screens/walk.dart';
import 'package:mapane/screens/numero_get.dart';
import 'package:mapane/screens/numero_get_ios.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String walk = '/walk';
  static const String numero_get = '/numero-get';
  static const String numero_get_ios = '/numero-get-ios';
  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    walk: (BuildContext context) => Walk(),
    numero_get: (BuildContext context) => NumeroGet(),
    numero_get_ios: (BuildContext context) => NumeroGetIos(),

  };
}



