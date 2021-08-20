import 'package:flutter/material.dart';
import 'package:mapane/custom/widgets/connexion_widget.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/screens/walk.dart';
import 'package:mapane/screens/numero_get.dart';
import 'package:mapane/screens/numero_get_ios.dart';
import 'package:mapane/screens/splash_welcome.dart';
import 'package:mapane/screens/welcome_map.dart';
import 'package:mapane/screens/settings.dart';
import 'package:mapane/screens/tabs_page.dart';
import 'package:mapane/screens/profile_my_entreprise.dart';
import 'package:mapane/screens/profile_edit_entreprise.dart';

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
  static const String profile_my_entreprise = '/profile_my_entreprise';
  static const String profile_edit_entreprise = '/profile_edit_entreprise';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    walk: (BuildContext context) => Walk(),
    numero_get: (BuildContext context) => NumeroGet(),
    numero_get_ios: (BuildContext context) => NumeroGetIos(),
    splash_welcome: (BuildContext context) => SplashWelcome(),
    welcome_map: (BuildContext context) => WelcomeMap(),
    settings: (BuildContext context) => Settings(),
    map: (BuildContext context) => TabsPage(),
    network: (BuildContext context) => LostConnexion(),
    profile_my_entreprise: (BuildContext context) => ProfileMyEntreprise(),
    profile_edit_entreprise: (BuildContext context) => ProfileEditEntreprise()
  };
}

