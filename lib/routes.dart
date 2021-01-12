import 'package:flutter/material.dart';
import 'package:mapane/screens/splash_screen.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),

  };
}



