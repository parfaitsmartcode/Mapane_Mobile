import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/curve_painter.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class DisableScreen extends StatefulWidget {
  @override
  _DisableScreenState createState() => _DisableScreenState();
}

class _DisableScreenState extends State<DisableScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.appBackground), fit: BoxFit.fill)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(Assets.unsuccessfullIcon)
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Désolé, Samy",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0.sp
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    Text(
                      "Votre crédit de recherche est épuisé.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0.sp
                      ),
                    ),
                    RichText(
                        text: TextSpan(
                          text: "Nous avons trouvé ",
                          style: TextStyle(

                              fontSize: 13.0.sp
                          ),
                          children: [
                            TextSpan(
                              text: "40 profils",
                              style: TextStyle(
                                  fontSize: 13.0.sp,
                                color: HexColor("#FCD22F")
                              ),
                            ),
                            TextSpan(
                              text: " correspondants",
                              style: TextStyle(
                                  fontSize: 13.0.sp,
                              ),
                            )
                          ]
                        )
                    ),
                    Text(
                      "a votre recherche. Veuillez recharger pour",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0.sp
                      ),
                    ),
                    Text(
                      "visualiser les résultats.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0.sp
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 50,left: SizeConfig.blockSizeHorizontal * 15,right: SizeConfig.blockSizeHorizontal * 15),
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 17,
                            height: SizeConfig.blockSizeVertical * 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Icon(
                              Icons.add,
                              color: HexColor("#FCD22F"),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          Text(
                            "Recharger",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0.sp
                            ),
                          ),
                          Text(
                            "son compte",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0.sp
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 17,
                            height: SizeConfig.blockSizeVertical * 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: SvgPicture.asset(Assets.cartIcon),
                            )
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          Text(
                            "Acheter",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0.sp
                            ),
                          ),
                          Text(
                            "un pack",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0.sp
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 17,
                              height: SizeConfig.blockSizeVertical * 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: SvgPicture.asset(Assets.sendIcon),
                              )
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                            Text(
                              "Demander du",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0.sp
                              ),
                            ),
                            Text(
                              "crédit à un ami",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0.sp
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: SizeConfig.screenHeight,
                child: CustomPaint(
                  painter: CurvePainter(
                    SizeConfig.screenWidth * 0.2,
                    SizeConfig.screenHeight,
                    SizeConfig.screenWidth / 2.1,
                    SizeConfig.screenHeight * 0.9,
                    SizeConfig.screenWidth * 0.8,
                    SizeConfig.screenHeight,
                    Colors.white.withOpacity(0.2),
                  ),
                  child: SizedBox(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: SizeConfig.screenHeight,
                child: CustomPaint(
                  painter: CurvePainter(
                    0,
                    SizeConfig.screenHeight,
                    SizeConfig.screenWidth / 2.1,
                    SizeConfig.screenHeight * 0.78,
                    SizeConfig.screenWidth,
                    SizeConfig.screenHeight,
                    Colors.white.withOpacity(0.1),
                  ),
                  child: SizedBox(),
                ),
              ),
            ),
          ],
        ));
  }
}
