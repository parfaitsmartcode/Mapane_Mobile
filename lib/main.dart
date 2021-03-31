import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/routes.dart';
import 'package:near_me/screens/splashscreen.dart';
import 'package:near_me/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp( MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapane',
      routes: Routes.routes,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
