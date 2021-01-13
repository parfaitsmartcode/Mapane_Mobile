import 'package:flutter/material.dart';
import 'dart:io';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                           //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(                  //return OrientationBuilder
          builder: (context, orientation) {
            return MaterialApp(
              title: "App Onboarding",
              home: Home(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}