import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';

class WelcomeMap extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<WelcomeMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.whiteGradientColor1,
                    Color(0x5DA7BACB),
                    Color(0x5DA7BACB),
                    AppColors.whiteGradientColor1
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.75,
                    1
                  ]),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getSize(9, "height", context),
                      horizontal: getSize(36, "width", context)),
                  child: Image.asset(
                    'assets/images/Logo-long-edited.png',
                    height: getSize(39, "height", context),
                  ),
                ),
                SizedBox(
                  height: getSize(34, "height", context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: getSize(26, "width", context)),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mon historique",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: getSize(24, "height", context),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackColor,
                                    letterSpacing: 0,
                                  ),
                            )
                          ],
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/images/refresh-icon.png',
                              height: getSize(20, "height", context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getSize(14, "height", context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: getSize(6, "width", context)),
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: getSize(12, "height", context)),
                              unselectedLabelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: getSize(12, "height", context)),
                              labelColor: Color(0xFF25296A),
                              indicatorColor: Color(0xFF25296A),
                              indicator: BoxDecoration(
                                color: Color(0xFF25296A).withOpacity(.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              tabs: [
                                Container(
                                  width: getSize(56, "width", context),
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: "Tout",
                                  ),
                                ),
                                Container(
                                  width: getSize(100, "width", context),
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: "Embouteillages",
                                  ),
                                ),
                                Container(
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: "Route barrée",
                                  ),
                                ),
                                Container(
                                  width: getSize(56, "width", context),
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: "Autres",
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          //Add this to give height
                          height: MediaQuery.of(context).size.height / 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: getSize(26, "width", context)),
                            child: TabBarView(children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: ListSkeleton(
                                    style: SkeletonStyle(
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                                      theme: SkeletonTheme.Light,
                                      isShowAvatar: false,
                                      barCount: 2,
                                      colors: [
                                        Color(0x26A3A3A3),
                                        Color(0x4007116E),
                                        Color(0x4007116E)
                                      ],
                                      isAnimation: true,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: Text("Home Body 2"),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: Text("Home Body 3"),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: Text("Home Body 4"),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
