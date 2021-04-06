import 'package:flutter/material.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/curve_painter.dart';
import 'package:near_me/routes.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';

class SelectAccount extends StatefulWidget {
  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  int indexAccount = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.backgroundImage),fit: BoxFit.fill)),
                child: Container(
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(Assets.logoWidthPng),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            height: SizeConfig.screenHeight,
                            child: CustomPaint(
                              painter: CurvePainter(
                                  0,
                                  SizeConfig.screenHeight / 3,
                                  SizeConfig.screenWidth / 2.1,
                                  SizeConfig.screenHeight / 9,
                                  SizeConfig.screenWidth,
                                  SizeConfig.screenHeight / 3,
                                  HexColor("#707070").withOpacity(0.2)),
                            ),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            height: SizeConfig.screenHeight,
                            child: CustomPaint(
                              painter: CurvePainter(
                                  0,
                                  SizeConfig.screenHeight / 2.4,
                                  SizeConfig.screenWidth / 2.1,
                                  SizeConfig.screenHeight / 6,
                                  SizeConfig.screenWidth,
                                  SizeConfig.screenHeight / 2.4,
                                  HexColor("#707070").withOpacity(0.4)),
                            ),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            height: SizeConfig.screenHeight,
                            child: CustomPaint(
                              painter: CurvePainter(
                                  0,
                                  SizeConfig.screenHeight / 2,
                                  SizeConfig.screenWidth / 2.1,
                                  SizeConfig.screenHeight / 4,
                                  SizeConfig.screenWidth,
                                  SizeConfig.screenHeight / 2,
                                  HexColor("#707070").withOpacity(0.6)),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 16),
                        child: PageView(
                          onPageChanged: (index){
                            setState(() {
                              indexAccount = index;
                            });
                          },
                            children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(Assets.cardIcon),
                                Text(
                                  "Je suis",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 1.5,
                                ),
                                Text(
                                  "Demandeur",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(Assets.cardIcon),
                                Text(
                                  "Je suis",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 1.5,
                                ),
                                Text(
                                  "Professionel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 18),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 12,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: indexAccount == 0 ? HexColor("#FCD222") : HexColor("#FCD222").withOpacity(0.3),
                                  radius: 8,
                                ),
                                CircleAvatar(
                                  backgroundColor: indexAccount == 0 ? HexColor("#FCD222").withOpacity(0.3) : HexColor("#FCD222")
                                  ,
                                  radius: 8,
                                )
                              ],
                            ),
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
                                "Sélectionner",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                if(indexAccount == 0){
                                  Navigator.pushNamed(
                                      context, Routes.demandeurRegister);
                                }else{
                                  Navigator.pushNamed(context, Routes.professionelRegister);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
