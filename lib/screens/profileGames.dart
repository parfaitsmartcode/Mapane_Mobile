import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../custom/widgets/newWidgets/topCustomBar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

class ProfileGame extends StatefulWidget {
  const ProfileGame({Key key}) : super(key: key);

  @override
  _ProfileGameState createState() => _ProfileGameState();
}

class _ProfileGameState extends State<ProfileGame> {
  Duration _duration = Duration(seconds: 4);
  double _opaityShadow = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _opaityShadow = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7BACB),
      body: SafeArea(
        child: Container(
            // width: getSize(375, "width", context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // AppColors.whiteColor,
                    Color(0xFFA7BACB),
                    Color(0xFF25296A),
                  ],
                  stops: [
                    0.1,
                    1
                  ]),
            ),
            padding: EdgeInsets.symmetric(
                vertical: getSize(0, "height", context),
                horizontal: getSize(22.5, "width", context)),
            child: Column(
              children: [
                topCustomBar(),
                Container(
                  padding:
                      EdgeInsets.only(bottom: getSize(20, "height", context)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: getSize(1, "height", context),
                              color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: getSize(76, "width", context),
                        child: Text(
                          "Mon score",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getSize(16, "height", context),
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "86",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getSize(55, "height", context),
                            fontWeight: FontWeight.bold,
                            height: 1.36,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: getSize(76, "width", context),
                        child: Text(
                          "Points",
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getSize(16, "height", context),
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getSize(26, "height", context),
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            height: getSize(560, "height", context),
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: getSize(28, "width", context),
                                vertical: getSize(15, "height", context)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35)),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          bottom:
                                              getSize(15, "height", context)),
                                      height: getSize(5, "height", context),
                                      width: getSize(55, "width", context),
                                      color: Colors.black.withOpacity(0.1)),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            getSize(14, "height", context)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: getSize(
                                                  34, "width", context)),
                                          child: Image.asset(
                                            'assets/images/newIcons/Tracé 267.png',
                                            height:
                                                getSize(26, "height", context),
                                          ),
                                        ),
                                        Text("Nord"),
                                        new Image.asset(
                                          'assets/images/newIcons/checkicon.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/Groupe 31.png',
                          height: getSize(24, "height", context),
                        ),
                        SizedBox(
                          width: getSize(14, "width", context),
                        ),
                        Text(
                          "Region du centre",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getSize(16, "height", context),
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getSize(45, "height", context),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: getSize(80, "height", context)),
                        child: Column(
                          children: [
                            Container(
                              width: getSize(80, "height", context),
                              height: getSize(80, "height", context),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      getSize(10, "height", context))),
                              child: Center(
                                child: Text(
                                  "2",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(35, "height", context),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getSize(13, "height", context),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ' 86 ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(14, "height", context),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Pts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize: getSize(
                                                  14, "height", context),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getSize(7, "height", context),
                            ),
                            Text('( Moi )',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(12, "height", context),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white))
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Tracé 263.png',
                              width: getSize(53, "width", context),
                            ),
                            SizedBox(
                              height: getSize(13, "height", context),
                            ),
                            AnimatedContainer(
                              duration: _duration,
                              width: getSize(130, "height", context),
                              height: getSize(130, "height", context),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      // AppColors.whiteColor,
                                      Color(0xFFFAB702),
                                      Color(0xFFF8DC00),
                                    ],
                                    stops: [
                                      0.1,
                                      1
                                    ]),
                                borderRadius: BorderRadius.circular(
                                    getSize(10, "height", context)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFF9CF2F)
                                        .withOpacity(_opaityShadow),
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "1",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(35, "height", context),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getSize(17, "height", context),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ' 100 ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(20, "height", context),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Pts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize: getSize(
                                                  20, "height", context),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getSize(7, "height", context),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: getSize(80, "height", context)),
                        child: Column(
                          children: [
                            Container(
                              width: getSize(80, "height", context),
                              height: getSize(80, "height", context),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      getSize(10, "height", context))),
                              child: Center(
                                child: Text(
                                  "3",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(35, "height", context),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getSize(13, "height", context),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ' 70 ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(14, "height", context),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Pts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize: getSize(
                                                  14, "height", context),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getSize(7, "height", context),
                            ),
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
