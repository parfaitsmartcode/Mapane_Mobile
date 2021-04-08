import 'package:flutter/material.dart';
import 'package:near_me/screens/demandeur_register.dart';
import 'package:near_me/screens/home.dart';
import 'package:near_me/screens/professionel_register.dart';
import 'package:near_me/screens/profile_pic.dart';
import 'package:near_me/screens/select_account.dart';
import 'package:near_me/screens/splashscreen.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String selectAccount = '/selectAccount';
  static const String demandeurRegister = '/demandeurRegister';
  static const String professionelRegister = '/professionelRegister';
  static const String profilePic = '/profilePic';
  static const String homePage = '/homePage';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    selectAccount: (BuildContext context) => SelectAccount(),
    demandeurRegister: (BuildContext context) => DemandeurRegister(),
    professionelRegister: (BuildContext context) => ProfessionelRegister(),
    profilePic: (BuildContext context) => ProfilePic(),
    homePage: (BuildContext context) => HomePage(),
  };
}



