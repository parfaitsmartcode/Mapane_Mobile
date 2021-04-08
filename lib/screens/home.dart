import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(20.0.h),
            child: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              centerTitle: true,
              toolbarHeight: 30.0.h,
              title:
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 3),
                    child: Image.asset(Assets.logoWidthPng),
                  ),
              leadingWidth: double.infinity,
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromWidth(10.0.w),
                child: TabBar(
                  tabs: [
                    Tab(icon: SvgPicture.asset(Assets.searchAppbar)),
                    Tab(icon: SvgPicture.asset(Assets.chatAppbar)),
                    Tab(icon: SvgPicture.asset(Assets.userAppbar,)),
                    Tab(icon: SvgPicture.asset(Assets.walletAppbar,)),
                  ],
                ),
              ),
            ),
          ),
            body: TabBarView(
              children: [
                Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.appBackground),
                        fit: BoxFit.fill)
                ),
              ),
                Center(
                    child: Text(
                      "1",
                      style: TextStyle(fontSize: 40),
                    )
                ),
                Center(),
                Center()
              ]
            )
        )
    );
  }
}
