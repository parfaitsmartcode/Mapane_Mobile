import 'package:bot_toast/bot_toast.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/networking/services/push_notifications_service.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
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
class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  //static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    //final pushNotificationService = PushNotificationService(_firebaseMessaging,context);
    //pushNotificationService.initialise();
    return MaterialApp(
      title: 'Mapane',
      theme: ThemeMapane.themeMapane(context),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      routes: Routes.routes,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('fr', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale?.languageCode == locale?.languageCode &&
              supportedLocale?.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales?.first;
      },
    );
  }
}
