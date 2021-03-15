import 'package:flutter/material.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/localization/language/languages.dart';

class Settings extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    userProvider.setAudioNotification();
    userProvider.setConnectMode();
    context.read<UserProvider>().getPopupVal();
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
                            height: getSize(485, "height", context),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getSize(23, "height", context),
                                    vertical: getSize(24, "width", context)),
                                child: Center(
                                    child: Column(children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed: () {
                                            context
                                                .read<BottomBarProvider>()
                                                .setWidget(false);
                                          }),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getSize(5, "width", context),
                                            vertical: 0),
                                        child: Text(
                                          Languages.of(context).setting,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(42, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "width", context),
                                        child: Image.asset(
                                          'assets/images/Sound-icon.png',
                                          height: getSize(20, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(200, "width", context),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              // width: getSize(160, "width", context),
                                              child: Text(
                                                Languages.of(context)
                                                    .notifaudio,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: getSize(
                                                        14, "height", context),
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              child: FlutterSwitch(
                                                padding: 2,
                                                toggleSize: getSize(
                                                    18, "width", context),
                                                width: getSize(
                                                    36, "width", context),
                                                height: getSize(
                                                    20, "height", context),
                                                activeColor: Color(0xFF25296A)
                                                    .withOpacity(.2),
                                                inactiveColor: Color(0xFF25296A)
                                                    .withOpacity(.2),
                                                activeToggleColor:
                                                    Color(0xFF25296A),
                                                value: context
                                                    .watch<UserProvider>()
                                                    .audioVal,
                                                borderRadius: 100.0,
                                                onToggle: (val) {
                                                  setState(() {
                                                    context
                                                        .read<UserProvider>()
                                                        .modifyAudioParam(val);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
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
                                          width: getSize(39, "width", context),
                                          child: Icon(Icons
                                              .notifications_none_outlined)),
                                      Container(
                                        width: getSize(200, "width", context),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              // width: getSize(160, "width", context),
                                              child: Text(
                                                Languages.of(context)
                                                    .displaynotif,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: getSize(
                                                        14, "height", context),
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              child: FlutterSwitch(
                                                padding: 2,
                                                toggleSize: getSize(
                                                    18, "width", context),
                                                width: getSize(
                                                    36, "width", context),
                                                height: getSize(
                                                    20, "height", context),
                                                activeColor: Color(0xFF25296A)
                                                    .withOpacity(.2),
                                                inactiveColor: Color(0xFF25296A)
                                                    .withOpacity(.2),
                                                activeToggleColor:
                                                    Color(0xFF25296A),
                                                value: context
                                                    .watch<UserProvider>()
                                                    .popupVal,
                                                borderRadius: 100.0,
                                                onToggle: (val) {
                                                  setState(() {
                                                    context
                                                        .read<UserProvider>()
                                                        .modifyPopupParam(val);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
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
                                        width: getSize(39, "width", context),
                                        child: Image.asset(
                                          'assets/images/Link-icon.png',
                                          height: getSize(20, "width", context),
                                        ),
                                      ),
                                      Container(
                                          width: getSize(200, "width", context),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                // width: getSize(160, "width", context),
                                                child: Text(
                                                  Languages.of(context)
                                                      .modenoncote,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: getSize(14,
                                                          "height", context),
                                                      color: Colors.black
                                                          .withOpacity(.3)),
                                                ),
                                              ),
                                              Container(
                                                child: FlutterSwitch(
                                                  padding: 2,
                                                  toggleSize: getSize(
                                                      18, "width", context),
                                                  width: getSize(
                                                      36, "width", context),
                                                  height: getSize(
                                                      20, "height", context),
                                                  activeColor: Color(0xFF25296A)
                                                      .withOpacity(.2),
                                                  inactiveColor:
                                                      Color(0xFF25296A)
                                                          .withOpacity(.2),
                                                  activeToggleColor:
                                                      Color(0xFF25296A),
                                                  value: context
                                                      .watch<UserProvider>()
                                                      .connectVal,
                                                  borderRadius: 100.0,
                                                  onToggle: (val) {
                                                    setState(() {
                                                      // context
                                                      //     .read<UserProvider>()
                                                      //     .modifyConnectParam(
                                                      //         val);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getSize(16, "height", context),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: getSize(39, "width", context),
                                        child: Image.asset(
                                          'assets/images/FIle-icon.png',
                                          height: getSize(20, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          Languages.of(context).termandcond,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: getSize(
                                                  14, "height", context),
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
                                        width: getSize(39, "width", context),
                                        child: Image.asset(
                                          'assets/images/Info-icon.png',
                                          height: getSize(20, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          Languages.of(context).apropos,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: getSize(
                                                  14, "height", context),
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
                                        width: getSize(39, "width", context),
                                        child: Image.asset(
                                          'assets/images/Help-icon.png',
                                          height: getSize(20, "width", context),
                                        ),
                                      ),
                                      Container(
                                        width: getSize(174, "width", context),
                                        child: Text(
                                          Languages.of(context).aide,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: getSize(
                                                  14, "height", context),
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
