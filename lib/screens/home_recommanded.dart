import 'package:flutter/material.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/curve_painter.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class Recommended extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.appBackground), fit: BoxFit.fill)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous avez recommandé",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13.0.sp
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical,
                      ),
                      Text(
                        "Sandrine Nana",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0.sp
                        ),
                      ),
                    ]
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
                      SizeConfig.screenWidth / 2.1,
                      SizeConfig.screenHeight / 2.1,
                      SizeConfig.screenWidth / 1.45,
                      SizeConfig.screenHeight * 0.47,
                      SizeConfig.screenWidth / 1.42,
                      SizeConfig.screenHeight * 0.58,
                      HexColor("#FCD22F"),
                      strokeWidth: 2
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0.h),
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 70,
                    backgroundImage: AssetImage(Assets.profilePicture),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0.h,left: 28.0.w),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        ),
                    child: CircleAvatar(
                      backgroundColor: HexColor("#FCD22F"),
                      radius: 20,
                      child: Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ),
                ),
              ),
              )
            ],
          )),
    );
  }
}
