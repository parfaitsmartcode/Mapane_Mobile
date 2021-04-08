import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/mytexfield.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class DemandeurRegister extends StatefulWidget {
  @override
  _DemandeurRegisterState createState() => _DemandeurRegisterState();
}

class _DemandeurRegisterState extends State<DemandeurRegister> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(Assets.backgroundImage),fit: BoxFit.fill)),
          child: Container(
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.9), HexColor("#2082D6")],
                  stops: [0.4, 1.0]),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.0.h),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(Assets.logoWidthPng),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 8,
                      ),
                      Text(
                          "Création du compte",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                        child: Text(
                          "Remplissez le formulaire pour accédez gratuitement à la plateforme",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 15.0.sp
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 85,
                        child: MyTextField(
                          hintText: "Nom complet",
                          prefixIcon: Padding(
                            padding:  EdgeInsets.only(left:SizeConfig.safeBlockHorizontal * 6,right: SizeConfig.safeBlockHorizontal * 6),
                            child: SvgPicture.asset(Assets.userIcon,),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 85,
                        child: MyTextField(
                          hintText: "Numéro de téléphone",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal * 6,right: SizeConfig.safeBlockHorizontal * 6),
                            child: SvgPicture.asset(Assets.phoneIcon,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0.h),
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

                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    ));
  }
}
