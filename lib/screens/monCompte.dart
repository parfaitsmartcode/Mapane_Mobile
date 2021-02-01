import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme_mapane.dart';
import '../utils/size_config.dart';
import '../state/user_provider.dart';
import 'package:mapane/routes.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'dart:async';

class MonCompte extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MonCompte> {
  String newDomicile = "";
  String _mobileNumber = '';
  String _mobileNumberPhone = '';
  String _mobileNumberPhoneWrite = '';
  bool _loading = false;
  var isSelected = [false, false, false, false, false];
  List<SimCard> _simCard = <SimCard>[];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  void takenumber(String value) {
    setState(() => _mobileNumberPhone = value);
  }

  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = await MobileNumber.mobileNumber;
      _simCard = await MobileNumber.getSimCards;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mobileNumber = mobileNumber;
    });
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
            padding: EdgeInsets.symmetric(
                vertical: getSize(9, "height", context),
                horizontal: getSize(36, "width", context)),
            child: Column(
              children: [
                // SizedBox(
                //     height: 8,
                //   ),
                Image.asset(
                  'assets/images/Logo-long-edited.png',
                  height: getSize(39, "height", context),
                ),
                SizedBox(
                  height: getSize(34, "height", context),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: getSize(20, "width", context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mon compte",
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      fontSize: 31,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackColor,
                                      letterSpacing: 0,
                                    ),
                          ),
                          Text(
                            "+237 690348765",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor.withOpacity(0.46),
                                  fontSize: getSize(17, "height", context),
                                  letterSpacing: 0,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: Elevation.low,
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(
                              getSize(100, "height", context)),
                        ),
                        // padding: EdgeInsets.all(4),
                        width: getSize(39, "width", context),
                        height: getSize(39, "width", context),
                        child: Center(
                          child: Image.asset(
                            'assets/images/Logo-small.png',
                            height: getSize(20, "height", context),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getSize(24, "height", context),
                ),
                Image.asset('assets/images/image-map.png',
                    width: double.infinity),
                SizedBox(
                  height: getSize(34, "height", context),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: Elevation.low,
                    color: AppColors.whiteColor,
                    borderRadius:
                        BorderRadius.circular(getSize(30, "height", context)),
                  ),
                  padding: EdgeInsets.only(
                      left: getSize(15, "width", context),
                      top: getSize(17, "height", context),
                      right: getSize(20, "width", context),
                      bottom: getSize(15, "height", context)),
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: getSize(38, "height", context),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      getSize(5, "width", context),
                                      0,
                                      getSize(15, "width", context),
                                      0),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/Tel-icon.png',
                                    height: getSize(24, "height", context),
                                    width: getSize(24, "width", context),
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Modifier le numéro',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(14, "height", context),
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor:
                                  AppColors.whiteColor.withOpacity(0.91),
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: getSize(303, "width", context),
                                        // height: getSize(256, "height", context),
                                        // padding: EdgeInsets.all(getSize(0,"height",context)),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                              getSize(20, "height", context)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF000000)
                                                  .withOpacity(0.11),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(0,
                                                  5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(getSize(
                                                  20, "height", context)),
                                              decoration: BoxDecoration(
                                                  // color: AppColors.whiteColor,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                        text: "Sélectionner ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: getSize(
                                                                18,
                                                                "height",
                                                                context),
                                                            color:
                                                                Colors.black),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "un numéro \nde téléphone",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        33, "height", context),
                                                  ),
                                                  _mobileNumber == null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: ListTile(
                                                            title: Align(
                                                              child: Text(
                                                                'Veuillez entrer une SIM',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Center(
                                                          child: _mobileNumber
                                                                      .length <=
                                                                  3
                                                              ? fillInput()
                                                              : fillCards()),
                                                  SizedBox(
                                                    height: getSize(
                                                        34, "height", context),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: getSize(
                                                              36,
                                                              "height",
                                                              context),
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _loading = true;
                                                              });
                                                              userService
                                                                  .updateHouse(
                                                                      _mobileNumberPhone,
                                                                      _mobileNumberPhoneWrite,
                                                                      0)
                                                                  .then(
                                                                      (value) {
                                                                showGeneralDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    barrierLabel: MaterialLocalizations.of(
                                                                            context)
                                                                        .modalBarrierDismissLabel,
                                                                    barrierColor: AppColors
                                                                        .whiteColor
                                                                        .withOpacity(
                                                                            0),
                                                                    transitionDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    pageBuilder: (BuildContext
                                                                            buildContext,
                                                                        Animation
                                                                            animation,
                                                                        Animation
                                                                            secondaryAnimation) {
                                                                      return Center(
                                                                        child:
                                                                            Card(
                                                                          shadowColor:
                                                                              Colors.transparent,
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal: 0,
                                                                              vertical: 0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                width: getSize(303, "width", context),
                                                                                // height: getSize(256, "height", context),
                                                                                // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                                                decoration: BoxDecoration(
                                                                                  color: AppColors.whiteColor,
                                                                                  borderRadius: BorderRadius.circular(getSize(20, "height", context)),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Color(0xFF000000).withOpacity(0.11),
                                                                                      spreadRadius: 5,
                                                                                      blurRadius: 10,
                                                                                      offset: Offset(0, 5), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(vertical: getSize(33, "height", context), horizontal: getSize(28, "width", context)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: getSize(100, "height", context),
                                                                                        height: getSize(100, "height", context),
                                                                                        padding: EdgeInsets.symmetric(vertical: getSize(20, "height", context), horizontal: getSize(22, "width", context)),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(100),
                                                                                          color: AppColors.greenColor.withOpacity(0.35),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Image.asset(
                                                                                            'assets/images/check-icon.png',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getSize(21, "height", context),
                                                                                      ),
                                                                                      Text(
                                                                                        "Sauvegardé",
                                                                                        style: AppTheme.defaultParagraph,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getSize(12, "height", context),
                                                                                      ),
                                                                                      Container(
                                                                                        width: getSize(220, "width", context),
                                                                                        child: Text(
                                                                                          value,
                                                                                          style: AppTheme.bodyText1.copyWith(
                                                                                            color: AppColors.blackColor.withOpacity(0.5),
                                                                                          ),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });

                                                                setState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                              }).catchError(
                                                                      (onError) {
                                                                showGeneralDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    barrierLabel: MaterialLocalizations.of(
                                                                            context)
                                                                        .modalBarrierDismissLabel,
                                                                    barrierColor: AppColors
                                                                        .whiteColor
                                                                        .withOpacity(
                                                                            0.96),
                                                                    transitionDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    pageBuilder: (BuildContext
                                                                            buildContext,
                                                                        Animation
                                                                            animation,
                                                                        Animation
                                                                            secondaryAnimation) {
                                                                      return Center(
                                                                        child:
                                                                            Card(
                                                                          shadowColor:
                                                                              Colors.transparent,
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal: 0,
                                                                              vertical: 0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                width: getSize(303, "width", context),
                                                                                // height: getSize(256, "height", context),
                                                                                // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                                                decoration: BoxDecoration(
                                                                                  color: AppColors.whiteColor,
                                                                                  borderRadius: BorderRadius.circular(getSize(20, "height", context)),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Color(0xFF000000).withOpacity(0.11),
                                                                                      spreadRadius: 5,
                                                                                      blurRadius: 10,
                                                                                      offset: Offset(0, 5), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(vertical: getSize(33, "height", context), horizontal: getSize(28, "width", context)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: getSize(100, "height", context),
                                                                                        height: getSize(100, "height", context),
                                                                                        padding: EdgeInsets.symmetric(vertical: getSize(36, "height", context), horizontal: getSize(30, "width", context)),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(100),
                                                                                          color: Colors.red.withOpacity(0.35),
                                                                                        ),
                                                                                        child: Center(
                                                                                            child: Icon(
                                                                                          Icons.close,
                                                                                          size: getSize(38, "height", context),
                                                                                          color: Colors.white,
                                                                                        )),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getSize(21, "height", context),
                                                                                      ),
                                                                                      Text(
                                                                                        "Erreur",
                                                                                        style: AppTheme.defaultParagraph,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getSize(12, "height", context),
                                                                                      ),
                                                                                      Container(
                                                                                        width: getSize(220, "width", context),
                                                                                        child: Text(
                                                                                          onError.response == null || onError.response == "" ? 'Une erreur est survenue, verifier votre connexion.' : onError.response.data["message"],
                                                                                          style: AppTheme.bodyText1.copyWith(
                                                                                            color: AppColors.blackColor.withOpacity(0.5),
                                                                                          ),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });

                                                                setState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                              });
                                                            },
                                                            textColor:
                                                                Colors.white,
                                                            color: Colors
                                                                .transparent,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      100.0),
                                                            ),
                                                            child: Container(
                                                              width: getSize(
                                                                  215,
                                                                  "width",
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: <
                                                                      Color>[
                                                                    Color(
                                                                        0xFFA7BACB),
                                                                    Color(
                                                                        0xFF25296A),
                                                                  ],
                                                                ),
                                                              ),
                                                              padding: EdgeInsets.fromLTRB(
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context),
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context)),
                                                              child: Center(
                                                                  child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  _loading
                                                                      ? SizedBox(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            strokeWidth:
                                                                                1,
                                                                          ),
                                                                          height: getSize(
                                                                              14,
                                                                              "height",
                                                                              context),
                                                                          width: getSize(
                                                                              14,
                                                                              "height",
                                                                              context),
                                                                        )
                                                                      : Row(),
                                                                  Text(
                                                                    'Sauvegarder',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: getSize(
                                                                          18,
                                                                          "height",
                                                                          context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: getSize(40,
                                                              "width", context),
                                                          height: getSize(40,
                                                              "width", context),
                                                          child: FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            color: Color(
                                                                0x162C306F),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .close_rounded,
                                                                color: Color(
                                                                    0xFF272C6C),
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ])
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: getSize(38, "height", context),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      getSize(5, "width", context),
                                      0,
                                      getSize(15, "width", context),
                                      0),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/Map-pin-icon-noir.png',
                                    height: getSize(24, "height", context),
                                    width: getSize(24, "width", context),
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Enregistrer votre domicile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(14, "height", context),
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor:
                                  AppColors.whiteColor.withOpacity(0.96),
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: getSize(303, "width", context),
                                        // height: getSize(256, "height", context),
                                        // padding: EdgeInsets.all(getSize(0,"height",context)),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                              getSize(20, "height", context)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF000000)
                                                  .withOpacity(0.11),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(0,
                                                  5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(getSize(
                                                  20, "height", context)),
                                              decoration: BoxDecoration(
                                                  // color: AppColors.whiteColor,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                        text: "Information ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: getSize(
                                                                18,
                                                                "height",
                                                                context),
                                                            color:
                                                                Colors.black),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "\nsur votre domicile",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        29, "height", context),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: SizedBox(
                                                          height: getSize(
                                                              44,
                                                              "height",
                                                              context),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            child: Drawer(
                                                              elevation: 0,
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  newDomicile =
                                                                      value;
                                                                },
                                                                decoration: InputDecoration(
                                                                    prefixIcon: Image.asset(
                                                                      'assets/images/Groupe 9.png',
                                                                      height: getSize(
                                                                          24,
                                                                          "height",
                                                                          context),
                                                                      width: getSize(
                                                                          24,
                                                                          "width",
                                                                          context),
                                                                    ),
                                                                    // border:
                                                                    //     OutlineInputBorder(
                                                                    //   borderRadius:
                                                                    //       BorderRadius.all(
                                                                    //     Radius.circular(
                                                                    //         100.0),

                                                                    //   ),
                                                                    // ),
                                                                    border: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                    ),
                                                                    filled: true,
                                                                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                                                                    hintStyle: TextStyle(fontSize: getSize(18, "height", context), color: Colors.black.withOpacity(.22)),
                                                                    hintText: "Votre nom publique",
                                                                    fillColor: Colors.black.withOpacity(.04)),
                                                                style: AppTheme
                                                                    .buttonText,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        16, "height", context),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: getSize(
                                                              36,
                                                              "height",
                                                              context),
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              // Actuelle
                                                              if (newDomicile !=
                                                                  "") {
                                                                userProvider
                                                                    .storeDomicile(
                                                                        newDomicile);
                                                              } else {
                                                                print(
                                                                    "l'actuel domicile est vide ");
                                                              }

                                                              showGeneralDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  barrierLabel:
                                                                      MaterialLocalizations.of(
                                                                              context)
                                                                          .modalBarrierDismissLabel,
                                                                  barrierColor: AppColors
                                                                      .whiteColor
                                                                      .withOpacity(
                                                                          0),
                                                                  transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                  pageBuilder: (BuildContext
                                                                          buildContext,
                                                                      Animation
                                                                          animation,
                                                                      Animation
                                                                          secondaryAnimation) {
                                                                    return Material(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              width: getSize(303, "width", context),
                                                                              // height: getSize(256, "height", context),
                                                                              // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.whiteColor,
                                                                                borderRadius: BorderRadius.circular(getSize(20, "height", context)),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Color(0xFF000000).withOpacity(0.11),
                                                                                    spreadRadius: 5,
                                                                                    blurRadius: 10,
                                                                                    offset: Offset(0, 5), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(vertical: getSize(33, "height", context), horizontal: getSize(28, "width", context)),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: getSize(100, "height", context),
                                                                                      height: getSize(100, "height", context),
                                                                                      padding: EdgeInsets.symmetric(vertical: getSize(20, "height", context), horizontal: getSize(22, "width", context)),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(100),
                                                                                        color: AppColors.greenColor.withOpacity(0.35),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Image.asset(
                                                                                          'assets/images/check-icon.png',
                                                                                          // height:getSize(0, "height", context),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: getSize(21, "height", context),
                                                                                    ),
                                                                                    Text(
                                                                                      "Sauvegardé",
                                                                                      style: AppTheme.defaultParagraph,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: getSize(12, "height", context),
                                                                                    ),
                                                                                    Container(
                                                                                      width: getSize(220, "width", context),
                                                                                      child: Text(
                                                                                        "Votre information a été mise à jours avec succès",
                                                                                        style: AppTheme.bodyText1.copyWith(
                                                                                          color: AppColors.blackColor.withOpacity(0.5),
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                            textColor:
                                                                Colors.white,
                                                            color: Colors
                                                                .transparent,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      100.0),
                                                            ),
                                                            child: Container(
                                                              width: getSize(
                                                                  215,
                                                                  "width",
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: <
                                                                      Color>[
                                                                    Color(
                                                                        0xFFA7BACB),
                                                                    Color(
                                                                        0xFF25296A),
                                                                  ],
                                                                ),
                                                              ),
                                                              padding: EdgeInsets.fromLTRB(
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context),
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context)),
                                                              child: Center(
                                                                  child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      strokeWidth:
                                                                          1,
                                                                    ),
                                                                    height: getSize(
                                                                        14,
                                                                        "height",
                                                                        context),
                                                                    width: getSize(
                                                                        14,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    'Sauvegarder',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: getSize(
                                                                          18,
                                                                          "height",
                                                                          context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: getSize(40,
                                                              "width", context),
                                                          height: getSize(40,
                                                              "width", context),
                                                          child: FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            color: Color(
                                                                0x162C306F),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .close_rounded,
                                                                color: Color(
                                                                    0xFF272C6C),
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ])
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      InkWell(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.settings);
                          },
                          child: Container(
                            height: getSize(38, "height", context),
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.fromLTRB(
                                        getSize(5, "width", context),
                                        0,
                                        getSize(15, "width", context),
                                        0),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/Settings-icon.png',
                                      height: getSize(24, "height", context),
                                      width: getSize(24, "width", context),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Paramètres de l\'application',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontSize:
                                                getSize(14, "height", context),
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.settings);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: getSize(38, "height", context),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      getSize(5, "width", context),
                                      0,
                                      getSize(15, "width", context),
                                      0),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/Logout-icon.png',
                                    height: getSize(24, "height", context),
                                    width: getSize(24, "width", context),
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Quitter l\'application',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(14, "height", context),
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor:
                                  AppColors.whiteColor.withOpacity(0.96),
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: getSize(303, "width", context),
                                        // height: getSize(256, "height", context),
                                        // padding: EdgeInsets.all(getSize(0,"height",context)),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                              getSize(20, "height", context)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF000000)
                                                  .withOpacity(0.11),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(0,
                                                  5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(getSize(
                                                  20, "height", context)),
                                              decoration: BoxDecoration(
                                                  // color: AppColors.whiteColor,
                                                  ),
                                              child: Material(
                                                elevation: 0,
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Voulez vous vraiment quitter l'application Mapane ?",
                                                      style: TextStyle(
                                                        fontSize: getSize(18,
                                                            "height", context),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getSize(29,
                                                          "height", context),
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: getSize(
                                                                36,
                                                                "height",
                                                                context),
                                                            child: FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              textColor:
                                                                  Colors.white,
                                                              color: Colors
                                                                  .transparent,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                width: getSize(
                                                                    155,
                                                                    "width",
                                                                    context),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: <
                                                                        Color>[
                                                                      Color(
                                                                          0xFFA7BACB),
                                                                      Color(
                                                                          0xFF25296A),
                                                                    ],
                                                                  ),
                                                                ),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    0,
                                                                    getSize(
                                                                        5,
                                                                        "height",
                                                                        context),
                                                                    0,
                                                                    getSize(
                                                                        5,
                                                                        "height",
                                                                        context)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Non, je reste',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: getSize(
                                                                            18,
                                                                            "height",
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            child: FlatButton(
                                                              onPressed: () {
                                                                SystemNavigator
                                                                    .pop();
                                                              },
                                                              color: Color(
                                                                  0x162C306F),
                                                              padding: EdgeInsets.fromLTRB(
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context),
                                                                  0,
                                                                  getSize(
                                                                      5,
                                                                      "height",
                                                                      context)),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Oui',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: getSize(
                                                                        18,
                                                                        "height",
                                                                        context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget fillCards() {
    var taille = _simCard.length;
    List<Widget> widgets = _simCard
        .map(
          (SimCard sim) => Column(
            children: [
              Card(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: ListTile(
                    leading: Image.asset(
                      'assets/images/Flag-CM.png',
                      height: 25,
                    ),
                    onTap: () {
                      setState(() {
                        _mobileNumberPhone = sim.number;
                        isSelected = [false, false, false, false, false];
                        isSelected[_simCard.indexOf(sim)] = true;
                      });
                    },
                    title: Align(
                      child: Text(
                        sim.number == null ? "" : sim.number,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: 1.7),
                      ),
                      alignment: Alignment(-0.3, 0),
                    ),
                    trailing:
                        taille == 1 || isSelected[_simCard.indexOf(sim)] == true
                            ? Icon(
                                Icons.check_circle,
                                size: 23.0,
                                color: Color(0xFF25296A),
                              )
                            : Text('')),
              ),
              _simCard.indexOf(sim) != taille - 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.5),
                      child: Divider(thickness: 2, color: Colors.grey[200]),
                    )
                  : Row(),
            ],
          ),
        )
        .toList();
    return Column(children: widgets);
  }

  Widget fillInput() {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Drawer(
                elevation: 0,
                child: Container(
                  color: Colors.white,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        _mobileNumberPhoneWrite = number.phoneNumber;
                      });
                    },
                    textStyle: TextStyle(fontSize: 16),
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    spaceBetweenSelectorAndTextField: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberSim extends StatelessWidget {
  const NumberSim({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListTile(
            leading: Image.asset('assets/images/Flag-CM.png'),
            title: Align(
              child: Text(
                "_isoCountryCode",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black),
              ),
              alignment: Alignment(-1.2, 0),
            ),
            trailing: Image.asset(
              'assets/images/Flag-CM.png',
              height: getSize(38, "height", context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.5),
          child: Divider(thickness: 2, color: Colors.grey[200]),
        ),
      ],
    );
  }
}
