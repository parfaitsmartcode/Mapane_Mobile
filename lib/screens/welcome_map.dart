import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';

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
                      vertical: getSize(9, "heigth", context),
                      horizontal: getSize(36, "width", context)),
                  child: Image.asset(
                    'assets/images/Logo-long-edited.png',
                    height: getSize(39, "heigth", context),
                  ),
                ),
                SizedBox(
                  height: getSize(34, "heigth", context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: getSize(26,"width",context)),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mon historique",
                              style:
                                  Theme.of(context).textTheme.headline1.copyWith(
                                        fontSize: getSize(24, "heigth", context),
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
                              height: getSize(20, "heigth", context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getSize(14, "heigth", context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: getSize(26,"width",context)),
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: getSize(12, "heigth", context)),
                              labelColor: Color(0xFF25296A),
                              indicatorColor: Color(0xFF25296A),
                              indicator: BoxDecoration(
                                color: Color(0xFF25296A).withOpacity(.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              tabs: [
                                Tab(
                                  text: "Tout",
                                ),
                                Tab(text: "Embouteillages"),
                                Tab(text: "Route barrée"),
                                Tab(text: "Autres"),
                              ]),
                        ),
                        Container(
                          //Add this to give height
                          height: MediaQuery.of(context).size.height / 3,
                          child: TabBarView(children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: getSize(46, "heigth", context),
                                    horizontal: 0),
                                child: Text("Home Body"),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: getSize(46, "heigth", context),
                                    horizontal: 0),
                                child: Text("Home Body 2"),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: getSize(46, "heigth", context),
                                    horizontal: 0),
                                child: Text("Home Body 3"),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: getSize(46, "heigth", context),
                                    horizontal: 0),
                                child: Text("Home Body 4"),
                              ),
                            ),
                          ]),
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
