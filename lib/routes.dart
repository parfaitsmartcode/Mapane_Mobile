import 'package:flutter/material.dart';
import 'package:near_me/screens/demandeur_register.dart';
import 'package:near_me/screens/select_account.dart';
import 'package:near_me/screens/splashscreen.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String selectAccount = '/selectAccount';
  static const String demandeurRegister = '/demandeurRegister';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    selectAccount: (BuildContext context) => SelectAccount(),
    demandeurRegister: (BuildContext context) => DemandeurRegister(),
  };
}



