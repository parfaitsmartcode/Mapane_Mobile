import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/routes.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.backgroundImage),
                        fit: BoxFit.fill)
                ),
                child: Container(
                  height: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          HexColor("#2082D6")
                        ],
                        stops: [
                          0.4,
                          1.0
                        ]),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(Assets.logoWidthPng),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18.0.h),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Création du compte",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0.h),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Remplissez le formulaire pour accédez gratuitement à la plateforme",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 15.0.sp
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 25.0.h,
                                width:  50.0.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: SvgPicture.asset(Assets.userIcon,width: SizeConfig.safeBlockHorizontal * 25,height: SizeConfig.safeBlockHorizontal * 8,),
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 4,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 25),
                                child: Text(
                                  "Sélectionner votre photo de profil",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 15.0.sp
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 5),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: SizeConfig.screenWidth / 1.2,
                            height: SizeConfig.screenHeight / 14,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: Colors.cyan.withOpacity(0.4),
                                      width: 2)),
                              color: HexColor("#2082D6"),
                              child: Text(
                                "Commencer",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.homePage);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
            )
        ));
  }
}
