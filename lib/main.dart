import 'package:flutter/material.dart';
import 'package:mapane/routes.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/screens/moncompte.dart';
import 'package:mapane/screens/tabs_page.dart';
import 'package:mapane/service_locator.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';
import './utils/theme_mapane.dart';
import 'package:mapane/screens/welcome_map.dart';
import 'package:mapane/screens/settings.dart';
import 'package:mapane/state/alert_provider.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => BottomBarProvider()),
        ChangeNotifierProvider(create:(_) => AlertProvider()),
      ],
      child:  MyApp(),
    )

  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapane',
      theme: ThemeMapane.themeMapane(context),
      home: WelcomeMap(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
