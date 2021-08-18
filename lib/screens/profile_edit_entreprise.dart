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

class ProfileEditEntreprise extends StatefulWidget {
  const ProfileEditEntreprise({Key key}) : super(key: key);

  @override
  _ProfileEditEntrepriseState createState() => _ProfileEditEntrepriseState();
}

class _ProfileEditEntrepriseState extends State<ProfileEditEntreprise> {
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
                    Container(
                      margin: EdgeInsets.only(
                          bottom: getSize(15, "width", context)),
                      padding: EdgeInsets.symmetric(
                          vertical: getSize(0, "height", context),
                          horizontal: getSize(22.5, "width", context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          topCustomBar(
                              type: "black", text: "Modifier entreprise"),
                          Padding(
                            padding: EdgeInsets.only(
                                top: getSize(15, "height", context)),
                            child: Text("Information sur votre entreprise",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(16, "height", context),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.4))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSize(0, "height", context),
                ),
              ],
            )),
      ),
    );
  }
}
