import 'package:flutter/material.dart';
import 'package:mapane/routes.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/screens/moncompte.dart';
import 'package:mapane/service_locator.dart';
import './utils/theme_mapane.dart';
import 'package:mapane/screens/welcome_map.dart';
import 'package:mapane/screens/settings.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapane',
      theme: ThemeMapane.themeMapane(context),
      home: Settings(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
