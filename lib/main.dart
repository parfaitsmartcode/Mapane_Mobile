import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapane/routes.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/service_locator.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/network_provider.dart';
import 'package:provider/provider.dart';
import './utils/theme_mapane.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:mapane/state/search_provider.dart';
import 'package:mapane/state/place_provider.dart';


void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  checkPermission();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create:(_) => BottomBarProvider()),
            ChangeNotifierProvider(create:(_) => AlertProvider()),
            ChangeNotifierProvider(create:(_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => PlaceProvider()),
            ChangeNotifierProvider(create: (_) => NetworkProvider())
          ],
          child:  MyApp(),
        )
    );
  });

}
checkPermission() async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location location = new Location();
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapane',
      theme: ThemeMapane.themeMapane(context),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      routes: Routes.routes,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
