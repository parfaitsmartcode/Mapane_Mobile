import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:mapane/custom/widgets/connexion_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class Settings extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.whiteGradientColor1,
                    Color(0x5DA7BACB),
                    Color(0x5DA7BACB),
                    AppColors.whiteGradientColor1
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.75,
                    1
                  ]),
            ),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getSize(35, "height", context),
                        horizontal: getSize(36, "width", context)),
                    child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                            height: getSize(536, "height", context),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getSize(24, "width", context),
                                    vertical: getSize(23, "height", context)),
                                child: Center(
                                    child: Column(children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          }),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getSize(5, "width", context),
                                            vertical: 0),
                                        child: Text(
                                          'Paramètres',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(46, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "height", context),
                                        child: Image.asset(
                                          'assets/images/Sound-icon.png',
                                          height: getSize(17, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(160, "width", context),
                                        child: Text(
                                          'Notifications audio',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        child: FlutterSwitch(
                                          width: getSize(40, "width", context),
                                          height: getSize(20, "height", context),
                                          activeColor: Color(0xFF25296A).withOpacity(.2),
                                          inactiveColor: Color(0xFF25296A).withOpacity(.2),
                                          activeToggleColor: Color(0xFF25296A),
                                          value: context.watch<UserProvider>().audioVal,
                                          borderRadius: 100.0,
                                          onToggle: (val) {
                                            setState(() {
                                              context.read<UserProvider>().modifyAudioParam(val);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(16, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "height", context),
                                        child: Image.asset(
                                          'assets/images/Link-icon.png',
                                          height: getSize(17, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(160, "width", context),
                                        child: Text(
                                          'Mode non connecté',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        child: FlutterSwitch(
                                          width: getSize(40, "width", context),
                                          height: getSize(20, "height", context),
                                          activeColor: Color(0xFF25296A).withOpacity(.2),
                                          inactiveColor: Color(0xFF25296A).withOpacity(.2),
                                          activeToggleColor: Color(0xFF25296A),
                                          value: context.watch<UserProvider>().connectVal,
                                          borderRadius: 100.0,
                                          onToggle: (val) {
                                            setState(() {
                                              context.read<UserProvider>().modifyConnectParam(val);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(16, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "height", context),
                                        child: Image.asset(
                                          'assets/images/FIle-icon.png',
                                          height: getSize(17, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          'Termes et conditions',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(16, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "height", context),
                                        child: Image.asset(
                                          'assets/images/Info-icon.png',
                                          height: getSize(17, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          'A Propos',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(16, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "height", context),
                                        child: Image.asset(
                                          'assets/images/Help-icon.png',
                                          height: getSize(17, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          'Aide',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ])))))),
              ],
            )),
      ),
    );
  }
}
