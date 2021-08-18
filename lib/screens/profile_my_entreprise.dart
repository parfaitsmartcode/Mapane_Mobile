import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../custom/widgets/newWidgets/topCustomBar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../custom/widgets/newWidgets/rps_custom_painter.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/theme_mapane.dart';
import '../state/user_provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:mapane/screens/settings.dart';
import 'package:mapane/state/LoadingState.dart';
import 'dart:io' show Platform;
import 'package:mapane/localization/language/languages.dart';
import 'package:mapane/localization/locale_constant.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ProfileMyEntreprise extends StatefulWidget {
  const ProfileMyEntreprise({Key key}) : super(key: key);

  @override
  _ProfileMyEntrepriseState createState() => _ProfileMyEntrepriseState();
}

class _ProfileMyEntrepriseState extends State<ProfileMyEntreprise> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFA7BACB),
      body: SafeArea(
        child: Container(
            // width: getSize(375, "width", context),
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
                ])),
            // padding: EdgeInsets.symmetric(
            //     vertical: getSize(0, "height", context),
            //     horizontal: getSize(22.5, "width", context)),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      right: -(getSize(22.5, "width", context) +
                          getSize(0, "width", context)),
                      top: getSize(50, "height", context),
                      child: SizedBox(
                        width: getSize(70, "width", context),
                        height: getSize(70, "width", context),
                        child: InkWell(
                          onTap: () {},
                          child: CustomPaint(
                            size: Size(
                                getSize(20, "height", context),
                                (getSize(20, "height", context) * 1)
                                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            painter: RPSCustomPainter(),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: getSize(11.5, "width", context),
                                  top: getSize(13, "width", context),
                                  child: Image.asset(
                                    'assets/images/add-icon.png',
                                    height: getSize(24.5, "width", context),
                                    width: getSize(24.5, "width", context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: getSize(15, "width", context)),
                      padding: EdgeInsets.symmetric(
                          vertical: getSize(0, "height", context),
                          horizontal: getSize(22.5, "width", context)),
                      child: Column(
                        children: [
                          topCustomBar(type: "black", text: "Mes entreprises"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSize(0, "height", context),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getSize(0, "height", context),
                      horizontal: getSize(22.5, "width", context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getSize(17, "height", context)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getSize(15, "height", context))),
                              margin: EdgeInsets.only(
                                  right: getSize(17, "width", context)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: getSize(5, "height", context)),
                                child: Image.asset(
                                  'assets/images/Picture.png',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: getSize(
                                                    5, "height", context)),
                                            child: Text("Malengue Palace",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize: getSize(18,
                                                            "height", context),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top:
                                                  getSize(5, "height", context),
                                            ),
                                            child: Text("Hôtel",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize: getSize(14,
                                                            "height", context),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black
                                                            .withOpacity(0.5))),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getSize(
                                                  5, "height", context)),
                                          child: Image.asset(
                                            'assets/images/Edit-icon.png',
                                            width:
                                                getSize(24, "width", context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      color: Colors.black.withOpacity(0.1),
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              getSize(18, "height", context)),
                                      height: getSize(1, "height", context)),
                                  Container(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  getSize(6, "width", context)),
                                          child: Image.asset(
                                            'assets/images/icon.png',
                                            width:
                                                getSize(24, "width", context),
                                          ),
                                        ),
                                        Text("3 Jour restants",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontSize: getSize(
                                                        14, "height", context),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getSize(6, "height", context),
                                  ),
                                  Container(
                                    child: Text(
                                        "Souscrire à une publicité ciblée",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize: getSize(
                                                    14, "height", context),
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xFF6386B8))),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getSize(17, "height", context)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getSize(15, "height", context))),
                              margin: EdgeInsets.only(
                                  right: getSize(17, "width", context)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: getSize(5, "height", context)),
                                child: Image.asset(
                                  'assets/images/Picture.png',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: getSize(
                                                    5, "height", context)),
                                            child: Text("Malengue Palace",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize: getSize(18,
                                                            "height", context),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top:
                                                  getSize(5, "height", context),
                                            ),
                                            child: Text("Hôtel",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize: getSize(14,
                                                            "height", context),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black
                                                            .withOpacity(0.5))),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getSize(
                                                  5, "height", context)),
                                          child: Image.asset(
                                            'assets/images/Edit-icon.png',
                                            width:
                                                getSize(24, "width", context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      color: Colors.black.withOpacity(0.1),
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              getSize(18, "height", context)),
                                      height: getSize(1, "height", context)),
                                  Container(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  getSize(6, "width", context)),
                                          child: Image.asset(
                                            'assets/images/icongreen.png',
                                            width:
                                                getSize(24, "width", context),
                                          ),
                                        ),
                                        Text("3 Jour restants",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontSize: getSize(
                                                        14, "height", context),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xFF36B281))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getSize(6, "height", context),
                                  ),
                                  Container(
                                    child: Text(
                                        "Souscrire à une publicité ciblée",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize: getSize(
                                                    14, "height", context),
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xFF6386B8))),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
