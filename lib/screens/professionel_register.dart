import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/custom/widgets/mytexfield.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class ProfessionelRegister extends StatefulWidget {
  @override
  _ProfessionelRegisterState createState() => _ProfessionelRegisterState();
}

class _ProfessionelRegisterState extends State<ProfessionelRegister> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.backgroundImage), fit: BoxFit.fill)),
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
                        style: TextStyle(color: Colors.white, fontSize: 24),
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
                              fontSize: 15.0.sp),
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
                            padding: EdgeInsets.only(
                                left: SizeConfig.safeBlockHorizontal * 6,
                                right: SizeConfig.safeBlockHorizontal * 6),
                            child: SvgPicture.asset(
                              Assets.userIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 85,
                        child: MyTextField(
                          hintText: "Date de naissance",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.safeBlockHorizontal * 6,
                                right: SizeConfig.safeBlockHorizontal * 6),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
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
                            padding: EdgeInsets.only(
                                left: SizeConfig.safeBlockHorizontal * 6,
                                right: SizeConfig.safeBlockHorizontal * 6),
                            child: SvgPicture.asset(
                              Assets.phoneIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 85,
                        child: MyTextField(
                          onTap: () {
                            showMaterialModalBottomSheet(
                              isDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.9),
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child: Container(
                                  height: 55.0.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.safeBlockVertical *
                                                2),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            height: 0.5.h,
                                            width: 15.0.w,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.safeBlockVertical *
                                                5,
                                            left:
                                                SizeConfig.safeBlockHorizontal *
                                                    7),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Compétences",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0.sp),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.safeBlockVertical *
                                                11,
                                            left:
                                                SizeConfig.safeBlockHorizontal *
                                                    7,
                                            right:
                                                SizeConfig.safeBlockHorizontal *
                                                    5),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .safeBlockHorizontal *
                                                            6,
                                                        right: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3),
                                                    child: SvgPicture.asset(
                                                        Assets.searchIcon),
                                                  ),
                                                  hintText: "Rechercher",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    fontSize: 15.0.sp,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                          vertical: 16),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                ))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.safeBlockVertical *
                                                20,
                                            left:
                                                SizeConfig.safeBlockHorizontal *
                                                    7,
                                            right:
                                                SizeConfig.safeBlockHorizontal *
                                                    5),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) => Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            itemCount: 20,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Radio(
                                                  activeColor:
                                                      Colors.blueAccent,
                                                  value: false,
                                                  onChanged: (value) {
                                                    print('changed');
                                                    showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        height: 45.0.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: SizeConfig
                                                                          .safeBlockVertical *
                                                                      2),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child:
                                                                    Container(
                                                                  height: 0.5.h,
                                                                  width: 15.0.w,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: SizeConfig
                                                                          .safeBlockVertical *
                                                                      7,
                                                                  left: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      7),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    "Informatique",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0.sp),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: SizeConfig
                                                                          .safeBlockVertical *
                                                                      12,
                                                                  right: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      7,
                                                                  left: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      7),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    "Offrez-vous aussi cette compétence dans un endroit  fixe ou un atelier ?",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.3),
                                                                        fontSize:
                                                                            15.0.sp),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                bottom: SizeConfig.safeBlockVertical * 10,
                                                                  right: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      7,
                                                                  left: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      7),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                    Container(
                                                                  width: SizeConfig
                                                                          .screenWidth /
                                                                      1.2,
                                                                  height: SizeConfig
                                                                          .screenHeight /
                                                                      15,
                                                                  child:
                                                                      RaisedButton(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20),
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.cyan.withOpacity(0.4),
                                                                            width: 2)),
                                                                    color: HexColor(
                                                                        "#2082D6"),
                                                                    child: Text(
                                                                      "Oui",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: SizeConfig.safeBlockVertical,
                                                                  right: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                      7,
                                                                  left: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                      7),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                Container(
                                                                  width: SizeConfig
                                                                      .screenWidth /
                                                                      1.2,
                                                                  height: SizeConfig
                                                                      .screenHeight /
                                                                      15,
                                                                  child:
                                                                  RaisedButton(
                                                                    color: Colors.black,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    ),
                                                                    child: Text(
                                                                      "Non",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          20),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: SizeConfig
                                                          .safeBlockHorizontal),
                                                  child: Center(
                                                      child: Text(
                                                    "Index $index",
                                                    style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                                ),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                SizedBox(),
                                                Icon(
                                                  Icons.directions_walk_sharp,
                                                  color: HexColor("#FCD222"),
                                                ),
                                                SvgPicture.asset(
                                                    Assets.pencilIcon)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          hintText: "Compétences",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.safeBlockHorizontal * 6,
                                right: SizeConfig.safeBlockHorizontal * 6),
                            child: SvgPicture.asset(
                              Assets.userStarIcon,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.h),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {},
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
