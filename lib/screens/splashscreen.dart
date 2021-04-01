import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigate = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _navigate = true;
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
                constraints: BoxConstraints.expand(),
                decoration: _navigate
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.backgroundImage)))
                    : null,
                child: Container(
                  decoration: _navigate ? BoxDecoration(
                    gradient: LinearGradient(
                      begin:  Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.7),Colors.black,HexColor("#2082D6")],
                      stops: [0.58,0.8,1.0]
                    )
                  ) : null,
                  child: Stack(
                      children: [
                        AnimatedPadding(
                          duration: Duration(seconds: 3),
                          padding: _navigate ? EdgeInsets.only(bottom: SizeConfig.screenHeight/ 4.3) : EdgeInsets.all(0.01),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                                Assets.logoPng
                            ),
                          ),
                        ),
                          AnimatedPadding(
                            duration: Duration(seconds: 1),
                            padding: _navigate ? EdgeInsets.only(bottom: SizeConfig.screenHeight / 2.7,left: SizeConfig.blockSizeHorizontal * 2,right: SizeConfig.blockSizeHorizontal * 2) : EdgeInsets.all(0.01),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _navigate ? Text(
                                "Les meilleures compétences à proximité",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ) : SizedBox(),
                            )
                          ),
                        AnimatedPadding(
                            duration: Duration(seconds: 1),
                            padding: _navigate ? EdgeInsets.only(bottom: SizeConfig.screenHeight / 4) : EdgeInsets.all(0.01),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _navigate ? Container(
                                width: SizeConfig.screenWidth /1.3,
                                child: Text(
                                  "Near Me vous permet de trouver des personnes ou services à proximité de vous pour répondre à votre besoin.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ) : SizedBox(),
                            )
                          ),
                        AnimatedPadding(
                            padding: _navigate ? EdgeInsets.only(bottom: SizeConfig.screenHeight / 40) : EdgeInsets.all(0.01),
                            duration: Duration(seconds: 1),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _navigate ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth / 1.2,
                                  height: SizeConfig.screenHeight / 14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 6)),
                                    color: HexColor("#2082D6"),
                                  ),
                                  child: ListTile(
                                    leading: SizedBox(),
                                      title: Text(
                                        "Créer mon compte",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                      onTap: (){}
                                      ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2,
                                ),
                                Text(
                                  "En créant mon compte, j'accepte",
                                  style: TextStyle(
                                      color: Colors.white,
                                    fontSize: 12.0
                                  ),
                                ),
                                Text(
                                  "les conditions d'utilisations",
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 12.0
                                  ),
                                )
                              ],
                            ) : SizedBox()
                          ),
                        )
                        ]
                    ),
                  ),
                ))
            );
  }
}
