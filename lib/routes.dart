import 'package:flutter/material.dart';
import 'package:near_me/screens/splashscreen.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String walk = '/walk';
  static const String numero_get = '/numero-get';
  static const String numero_get_ios = '/numero-get-ios';
  static const String splash_welcome = '/splash-welcome';
  static const String welcome_map = '/welcome-map';
  static const String settings = '/settings';
  static const String map = '/map';
  static const String network = '/network';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
  };
}



