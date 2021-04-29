import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:near_me/routes.dart';
import 'package:near_me/screens/splashscreen.dart';
import 'package:near_me/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer_util.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizerUtil().init(constraints, orientation);
          return MaterialApp(
            title: 'Near Me',
            routes: Routes.routes,
            theme: ThemeData(
              textTheme: GoogleFonts.firaSansTextTheme(),
              canvasColor: Colors.transparent,
            ),
            initialRoute: Routes.splash,
            debugShowCheckedModeBanner: false,
          );
        });
      },
    );
  }
}
