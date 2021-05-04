import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/routes.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Status _navigate = Status.SPLASH;
  double value = 0.01;
  int indexPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _navigate = Status.ONBOARDING;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: _navigate == Status.ONBOARDING || _navigate == Status.START
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.backgroundImage),
                    fit: BoxFit.cover))
            : BoxDecoration(),
        child: Container(
          decoration:
              _navigate == Status.ONBOARDING || _navigate == Status.START
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _navigate == Status.ONBOARDING
                              ? [
                                  Colors.black.withOpacity(0.65),
                                  Colors.black.withOpacity(0.98),
                                  Colors.black
                                ]
                              : [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black,
                                  HexColor("#2082D6")
                                ],
                          stops: _navigate == Status.ONBOARDING
                              ? [0.5, 0.8, 1]
                              : [0.5, 0.8, 1.0]))
                  : BoxDecoration(),
          child: Stack(children: [
            AnimatedPadding(
              duration: Duration(
                  milliseconds: _navigate == Status.ONBOARDING ? 500 : 400),
              padding: EdgeInsets.only(
                  bottom: _navigate == Status.ONBOARDING
                      ? 52.0.h
                      : _navigate == Status.START
                          ? 33.0.h
                          : 0.01),
              child: Align(
                  alignment: _navigate == Status.ONBOARDING
                      ? Alignment.topCenter
                      : Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: _navigate == Status.ONBOARDING
                        ? getSize(246, "height", context)
                        : getSize(288, "height", context),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: _navigate == Status.ONBOARDING
                              ? getSize(62, "height", context)
                              : 0),
                      child: Image.asset(
                        Assets.logoPng,
                        height: getSize(184, "height", context),
                      ),
                    ),
                  )),
            ),
            AnimatedPadding(
                duration: Duration(milliseconds: 500),
                padding: _navigate == Status.START
                    ? EdgeInsets.only(
                        bottom: 40.0.h,
                        left: SizeConfig.safeBlockHorizontal * 2,
                        right: SizeConfig.safeBlockHorizontal * 2)
                    : _navigate == Status.ONBOARDING
                        ? EdgeInsets.only(
                            bottom: 30.0.h - getSize(139, "height", context),
                            left: SizeConfig.safeBlockHorizontal * 2,
                            right: SizeConfig.safeBlockHorizontal * 2)
                        : EdgeInsets.all(0.01),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _navigate == Status.ONBOARDING
                      ? PageView(
                          onPageChanged: (int index) {
                            setState(() {
                              indexPage = index;
                            });
                          },
                          children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    Assets.searchOnboarding,
                                    width: getSize(117, "width", context),
                                  ),
                                  SizedBox(
                                    height: getSize(42, "height", context),
                                  ),
                                  Text(
                                    "Recherche",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getSize(24, "height", context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical / 2,
                                  ),
                                  Text(
                                    "Simple et Vocale",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getSize(24, "height", context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 3,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal *
                                                12),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            "Retrouvez des personnes avec une simplement ou notre assistant vocal",
                                        // "Retrouvez les professionnels et services (plombiers,répétiteurs,pharmacies etc...)",
                                        style: TextStyle(
                                            fontSize:
                                                getSize(18, "height", context),
                                            height: 1.22),
                                        // children: [
                                        //   TextSpan(
                                        //       text:
                                        //           "les plus proches de vous",
                                        //       style: TextStyle(
                                        //         color: HexColor("#FCD222"),
                                        //         fontSize: getSize(
                                        //             18, "height", context),
                                        //       )),
                                        //   TextSpan(
                                        //       text:
                                        //           ", avec une recherche simple ou avec notre assistant vocal",
                                        //       style: TextStyle(
                                        //         fontSize: getSize(
                                        //             18, "height", context),
                                        //       )),
                                        // ]
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    Assets.freeSearch,
                                    height: getSize(122, "height", context),
                                  ),
                                  SizedBox(
                                    height: getSize(27, "height", context),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal *
                                                20),
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "10",
                                            style: TextStyle(
                                                fontSize: getSize(
                                                    74, "height", context),
                                                height: 1.2,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                text: " recherches",
                                                style: TextStyle(
                                                  fontSize: getSize(
                                                      24, "height", context),
                                                  color: HexColor("#FCD222"),
                                                ),
                                              ),
                                              TextSpan(
                                                text: " gratuites",
                                                style: TextStyle(
                                                  fontSize: getSize(
                                                      24, "height", context),
                                                  color: HexColor("#FCD222"),
                                                ),
                                              ),
                                              TextSpan(
                                                text: " offertes",
                                                style: TextStyle(
                                                  fontSize: getSize(
                                                      24, "height", context),
                                                ),
                                              )
                                            ])),
                                  ),
                                  SizedBox(
                                    height: getSize(25, "height", context),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.safeBlockHorizontal *
                                                  13),
                                      child: Text(
                                        "Vous avez droit à 5 recherches gratuites pour débuter",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                getSize(18, "height", context),
                                            color: Colors.white),
                                      ))
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    Assets.walletOnboarding,
                                    height: getSize(133, "height", context),
                                  ),
                                  SizedBox(
                                    height: getSize(74, "height", context),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.safeBlockHorizontal *
                                                  12),
                                      child: Text(
                                        "Portefeuille numérique",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize:
                                              getSize(24, "height", context),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )),
                                  SizedBox(
                                    height: getSize(25, "height", context),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.safeBlockHorizontal *
                                                  13),
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text:
                                                  "Vous avez la possibilité de recharger ",
                                              style: TextStyle(
                                                  fontSize: getSize(
                                                      18, "height", context),
                                                  height: 1.22),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "et transférer du crédit NearMe",
                                                    style: TextStyle(
                                                      fontSize: getSize(18,
                                                          "height", context),
                                                      height: 1.22,
                                                      // color:
                                                      //     HexColor("#FCD222"),
                                                    ))
                                              ])))
                                ],
                              ),
                            ])
                      : _navigate == Status.START
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.safeBlockHorizontal * 10),
                              child: Text(
                                "Les meilleures compétences à proximité",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : SizedBox(),
                )),
            AnimatedPadding(
                duration: Duration(milliseconds: 400),
                padding: EdgeInsets.only(
                    bottom: _navigate == Status.START ? 28.0.h : 0.01),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _navigate == Status.START
                      ? Container(
                          width: SizeConfig.safeBlockHorizontal * 85,
                          child: Text(
                            "Near Me vous permet de trouver des personnes ou services à proximité de vous pour répondre à votre besoin.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0.sp,
                            ),
                          ),
                        )
                      : SizedBox(),
                )),
            AnimatedPadding(
              padding: _navigate == Status.START
                  ? EdgeInsets.only(bottom: SizeConfig.screenHeight / 40)
                  : EdgeInsets.all(0.01),
              duration: Duration(milliseconds: 500),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _navigate == Status.START
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth / 1.2,
                              height: SizeConfig.screenHeight / 14,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Colors.cyan.withOpacity(0.4),
                                        width: 2)),
                                color: HexColor("#2082D6"),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Text(
                                      "Créer mon compte",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.selectAccount);
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical * 2,
                            ),
                            Text(
                              "En créant mon compte, j'accepte",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                            Text(
                              "les conditions d'utilisations",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            )
                          ],
                        )
                      : _navigate == Status.ONBOARDING
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.safeBlockHorizontal * 5,
                                  vertical: SizeConfig.safeBlockHorizontal * 3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    //color: Colors.red,
                                    width: SizeConfig.safeBlockHorizontal * 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: indexPage == 0
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.3),
                                          radius: 6,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: indexPage == 1
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.3),
                                          radius: 6,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: indexPage == 2
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.3),
                                          radius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _navigate = Status.START;
                                      });
                                    },
                                    child: Container(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Suivant",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0.sp),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox()),
            )
          ]),
        ),
      ),
    ));
  }
}

enum Status { SPLASH, ONBOARDING, START }