import 'package:flutter/material.dart';
import 'package:mapane/routes.dart';
import 'package:mapane/screens/socket_test.dart';
import 'package:mapane/screens/home_page.dart';
import 'package:mapane/screens/splash_screen.dart';
import 'package:mapane/screens/moncompte.dart';
import 'package:mapane/screens/tabs_page.dart';
import 'package:mapane/screens/test.dart';
import 'package:mapane/service_locator.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:provider/provider.dart';
import './utils/theme_mapane.dart';
import 'package:mapane/screens/welcome_map.dart';
import 'package:mapane/screens/walk.dart';
import 'package:mapane/screens/settings.dart';
import 'package:mapane/screens/numero_get_ios.dart';
import 'package:mapane/screens/numero_get.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:mapane/state/search_provider.dart';

Injector injector;
void main() async {
  setupLocator();
  // IO.Socket socket = IO.io('https://ee9a821b9b54.ngrok.io',<String, dynamic>{
  //     'transports': ['websocket'],
  //   });
  // socket.onConnect((_) {
  //   print('connect');
  //   socket.emit('msg', 'test');
  // });
  // socket.on('event', (data) => print(data));
  // socket.onDisconnect((_) => print('disconnect'));
  // socket.on('fromServer', (_) => print(_));
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
      home: WelcomeMap(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
