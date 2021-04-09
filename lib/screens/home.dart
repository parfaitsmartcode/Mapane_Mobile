import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/screens/disable_screen.dart';
import 'package:near_me/screens/search_screen.dart';
import 'package:near_me/utils/hexcolor.dart';
import 'package:near_me/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

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
                preferredSize: Size.fromWidth(85.0.w),
                child: Container(
                  width: 85.0.w,
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(color: HexColor("#FCD222")),
                        insets: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7,right: SizeConfig.blockSizeHorizontal * 12)
                    ),
                    indicatorColor: HexColor("#FCD222"),
                    labelColor: HexColor("#FCD222"),
                    tabs: [
                      Tab(icon: SvgPicture.asset(Assets.searchAppbar,width: 32,color: _tabController.index == 0 ? HexColor("#FCD222") : Colors.grey.shade500,height: 32,fit: BoxFit.fill,)),
                      Tab(icon: SvgPicture.asset(Assets.chatAppbar,color: _tabController.index == 1 ? HexColor("#FCD222") : Colors.grey.shade500)),
                      Tab(icon: SvgPicture.asset(Assets.userAppbar,color: _tabController.index == 2 ? HexColor("#FCD222") : Colors.grey.shade500)),
                      Tab(icon: SvgPicture.asset(Assets.walletAppbar,color: _tabController.index == 3 ? HexColor("#FCD222") : Colors.grey.shade500)),
                    ],
                  ),
                )
              ),
            ),
          ),
            body: TabBarView(
              children: [
               DisableScreen(),
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
