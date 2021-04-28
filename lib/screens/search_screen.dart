import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/curve_painter.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 70,
                backgroundImage: AssetImage(Assets.profilePicture),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 31.0.h, left: 24.0.w),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1.5)),
                  /*borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0)),
                ),*/
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 15),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello, Samy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0.sp
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 1.5,
                  ),
                  Text(
                    "De qui avez vous besoin ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0.sp
                    ),
                  ),
                  Text(
                    "aujourd'hui ?",
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 15.0.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 45),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: SizeConfig.blockSizeVertical * 7,
                width: SizeConfig.safeBlockHorizontal * 90,
                child: TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      hintText: "Trouver un professionel",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: SvgPicture.asset(Assets.searchSearchbar), onPressed: (){

                            }),
                            IconButton(icon: SvgPicture.asset(Assets.micSearchbar), onPressed: (){

                            })
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13.0.sp,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2),width: 1.5),
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20),bottomRight: Radius.circular(20))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2),width: 1.5),
                          borderRadius:BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20),bottomRight: Radius.circular(20))),
                    )
                ),
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
                    0,
                    SizeConfig.screenHeight,
                    SizeConfig.screenWidth / 2.1,
                    SizeConfig.screenHeight * 0.80,
                    SizeConfig.screenWidth,
                    SizeConfig.screenHeight,
                    Colors.white.withOpacity(0.3),
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
                  SizeConfig.screenHeight * 0.94,
                  SizeConfig.screenWidth / 2.1,
                  SizeConfig.screenHeight  * 0.75,
                  SizeConfig.screenWidth,
                  SizeConfig.screenHeight * 0.94,
                  Colors.white.withOpacity(0.15),
                ),
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
                  SizeConfig.screenHeight * 0.87,
                  SizeConfig.screenWidth / 2.1,
                  SizeConfig.screenHeight  * 0.7,
                  SizeConfig.screenWidth,
                  SizeConfig.screenHeight * 0.87,
                  Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
