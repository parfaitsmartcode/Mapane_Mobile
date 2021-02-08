import 'package:flutter/material.dart';
import 'package:Mapane/routes.dart';
import 'package:Mapane/screens/socket_test.dart';
import 'package:Mapane/screens/home_page.dart';
import 'package:Mapane/screens/splash_screen.dart';
import 'package:Mapane/screens/moncompte.dart';
import 'package:Mapane/screens/tabs_page.dart';
import 'package:Mapane/screens/test.dart';
import 'package:Mapane/service_locator.dart';
import 'package:Mapane/state/bottom_bar_provider.dart';
import 'package:Mapane/state/place_provider.dart';
import 'package:provider/provider.dart';
import './utils/theme_mapane.dart';
import 'package:Mapane/screens/welcome_map.dart';
import 'package:Mapane/screens/walk.dart';
import 'package:Mapane/screens/settings.dart';
import 'package:Mapane/screens/numero_get_ios.dart';
import 'package:Mapane/screens/numero_get.dart';
import 'package:Mapane/state/alert_provider.dart';
import 'package:Mapane/state/user_provider.dart';

import 'package:Mapane/state/search_provider.dart';
void main() async {
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomBarProvider()),
      ChangeNotifierProvider(create: (_) => AlertProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => PlaceProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapane',
      theme: ThemeMapane.themeMapane(context),
      home: SplashScreen(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
