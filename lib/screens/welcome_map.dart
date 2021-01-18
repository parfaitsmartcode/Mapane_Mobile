import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io';

class WelcomeMap extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<WelcomeMap> {
  bool _isloading = false;
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
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: getSize(26, "width", context)),
                            child: TabBarView(children: [
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            getSize(46, "height", context),
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        _isloading == true
                                            ? SkeletonColumn()
                                            : AllAlerte()
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [SkeletonColumn()],
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(46, "height", context),
                                      horizontal: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [SkeletonColumn()],
                                  ),
                                ),
                              ),
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            getSize(46, "height", context),
                                        horizontal: 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [AutreAlerte()],
                                    ),
                                  ),
                                ),
                              ])
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

class MaterialModal extends StatelessWidget {
  const MaterialModal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal:
              getSize(0, "width", context)),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(15),
                topRight:
                    Radius.circular(15)),
            color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              width: 54,
              child: Padding(
                padding: const EdgeInsets
                    .fromLTRB(0, 16, 0, 25),
                child: Divider(
                    thickness: 4,
                    color:
                        Color(0x26000000)),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.map,
                  color: Color(0xFF25296A),
                ),
                title: Text(
                    'Controle routier',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w400,
                        fontSize: 16,
                        color:
                            Colors.black))),
            ListTile(
                leading: Icon(
                  Icons.add_location ,
                  color: Color(0xFF25296A),
                ),
                title: Text(
                    'Zone dangereuse',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w400,
                        fontSize: 16,
                        color:
                            Colors.black))),
            ListTile(
                leading: Icon(
                  Icons.airline_seat_recline_extra_rounded,
                  color: Color(0xFF25296A),
                ),
                title: Text(
                    'Accident de circulation',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w400,
                        fontSize: 16,
                        color:
                            Colors.black))),
            ListTile(
                leading: Icon(
                  Icons.local_taxi_sharp,
                  color: Color(0xFF25296A),
                ),
                title: Text(
                    'Route en chantier',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w400,
                        fontSize: 16,
                        color:
                            Colors.black))),
            ListTile(
                leading: Icon(
                  Icons.radio_sharp,
                  color: Color(0xFF25296A),
                ),
                title: Text(
                    'Radar',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w400,
                        fontSize: 16,
                        color:
                            Colors.black))),
          ],
        ),
      ),
    );
  }
}

class SkeletonColumn extends StatelessWidget {
  const SkeletonColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAnimation(
          child: Container(
            width: 215.0,
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 11,
        ),
        SkeletonAnimation(
          child: Container(
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 30.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        SkeletonAnimation(
          child: Container(
            width: 215.0,
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 11,
        ),
        SkeletonAnimation(
          child: Container(
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 30.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        SkeletonAnimation(
          child: Container(
            width: 215.0,
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 11,
        ),
        SkeletonAnimation(
          child: Container(
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 30.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        SkeletonAnimation(
          child: Container(
            width: 215.0,
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 11,
        ),
        SkeletonAnimation(
          child: Container(
            height: 21.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0x26A3A3A3),
                  Color(0x4007116E),
                  Color(0x4007116E),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AllAlerte extends StatelessWidget {
  const AllAlerte({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            title: Text('Accident de circulation',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bepanda, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 5min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Route barrée',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Akwa Nord, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 30min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Embouteillage',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Poste centrale, Yaoundé',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Hier',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Radar',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entrée Yaoundé',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Avant-hier',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Accident de circulation',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bepanda, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 5min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0))
      ],
    );
  }
}

class AutreAlerte extends StatefulWidget {
  @override
  _AutreAlerteState createState() => _AutreAlerteState();
}
class _AutreAlerteState extends State<AutreAlerte> {
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showMaterialModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        duration: const Duration(milliseconds: 500),
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => MaterialModal(),
                                      ));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            title: Text('Accident de circulation',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bepanda, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 5min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Route barrée',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Akwa Nord, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 30min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Embouteillage',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Poste centrale, Yaoundé',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Hier',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Radar',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entrée Yaoundé',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Avant-hier',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
        ListTile(
            title: Text('Accident de circulation',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black)),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bepanda, Douala',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                  Text('Il y a 5min',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.4))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0))
      ],
    );
  }
}
