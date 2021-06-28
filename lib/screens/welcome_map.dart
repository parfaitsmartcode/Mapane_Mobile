import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:mapane/state/LoadingState.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/models/alert.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:mapane/localization/language/languages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/networking/services/alert_service.dart';

class WelcomeMap extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<WelcomeMap> {
  bool _isloading = false;
  int _currentIndexTab = 0;
  String cat = "";
  var filter_alerte = false;
  @override
  void initState() {
    context.read<AlertProvider>().getAlertByUser("5ff34b88af0f1982ab03f3f9");
    context.read<AlertProvider>().getAlertByUserCat(
        "All",
        1,
        context
            .read<PlaceProvider>()
            .userPlace
            .fold((l) => null, (r) => r.state)
            .toString());
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
                              Languages.of(context).historique,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // GestureDetector(
                                //   onTap: () {
                                //     if (filter_alerte) {
                                //       context
                                //           .read<AlertProvider>()
                                //           .getAlertByUser(
                                //               "5ff34b88af0f1982ab03f3f9");
                                //       context
                                //           .read<AlertProvider>()
                                //           .getAlertByUserCat(
                                //               "All",
                                //               2,
                                //               context
                                //                       .read<PlaceProvider>()
                                //                       .userPlace
                                //                       .fold((l) => null,
                                //                           (r) => r.state)
                                //                       .toString() +
                                //                   ", " +
                                //                   context
                                //                       .read<PlaceProvider>()
                                //                       .userPlace
                                //                       .fold((l) => null,
                                //                           (r) => r.country)
                                //                       .toString());
                                //     } else {
                                //       context
                                //           .read<AlertProvider>()
                                //           .getAlertByUserReal(context
                                //                   .read<PlaceProvider>()
                                //                   .userPlace
                                //                   .fold((l) => null,
                                //                       (r) => r.state)
                                //                   .toString() +
                                //               ", " +
                                //               context
                                //                   .read<PlaceProvider>()
                                //                   .userPlace
                                //                   .fold((l) => null,
                                //                       (r) => r.country)
                                //                   .toString());
                                //     }
                                //     setState(() {
                                //       filter_alerte = !filter_alerte;
                                //     });
                                //   },
                                //   child: Row(
                                //     children: [
                                //       Icon(Icons.list_alt,
                                //           size: getSize(11, "height", context)),
                                //       Text(
                                //         filter_alerte
                                //             ? Languages.of(context).mes_alertes
                                //             : Languages.of(context).toutes_alertes,
                                //         style: TextStyle(
                                //           fontSize:
                                //               getSize(12, "height", context),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.filter_list),
                                  onSelected: (String result) {
                                    switch (result) {
                                      case 'mes_alertes':
                                        print('filter 1 clicked');
                                        context
                                            .read<AlertProvider>()
                                            .getAlertByUserReal(context
                                                    .read<PlaceProvider>()
                                                    .userPlace
                                                    .fold((l) => null,
                                                        (r) => r.state)
                                                    .toString() +
                                                ", " +
                                                context
                                                    .read<PlaceProvider>()
                                                    .userPlace
                                                    .fold((l) => null,
                                                        (r) => r.country)
                                                    .toString());
                                        break;
                                      case 'toutes_alertes':
                                        print('filter 2 clicked');
                                        context
                                            .read<AlertProvider>()
                                            .getAlertByUser(
                                                "5ff34b88af0f1982ab03f3f9");
                                        context
                                            .read<AlertProvider>()
                                            .getAlertByUserCat(
                                                "All",
                                                2,
                                                context
                                                        .read<PlaceProvider>()
                                                        .userPlace
                                                        .fold((l) => null,
                                                            (r) => r.state)
                                                        .toString() +
                                                    ", " +
                                                    context
                                                        .read<PlaceProvider>()
                                                        .userPlace
                                                        .fold((l) => null,
                                                            (r) => r.country)
                                                        .toString());
                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'mes_alertes',
                                      child: Text(Languages.of(context).mes_alertes),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'toutes_alertes',
                                      child: Text(Languages.of(context).toutes_alertes),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: getSize(8, "width", context),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AlertProvider>()
                                        .getAlertByUser(
                                            "5ff34b88af0f1982ab03f3f9");
                                    context
                                        .read<AlertProvider>()
                                        .getAlertByUserCat(
                                            "All",
                                            2,
                                            context
                                                    .watch<PlaceProvider>()
                                                    .userPlace
                                                    .fold((l) => null,
                                                        (r) => r.state)
                                                    .toString() +
                                                ", " +
                                                context
                                                    .watch<PlaceProvider>()
                                                    .userPlace
                                                    .fold((l) => null,
                                                        (r) => r.country)
                                                    .toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/refresh-icon.png',
                                    height: getSize(20, "height", context),
                                  ),
                                ),
                              ],
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
                              onTap: (int index) {
                                if (index < 3) {
                                  context.read<UserProvider>().checkTab(false);
                                } else {
                                  context.read<UserProvider>().checkTab(true);
                                }
                                setState(() => _currentIndexTab = index);
                              },
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: getSize(12, "height", context)),
                              unselectedLabelStyle: TextStyle(
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
                                    text: Languages.of(context).all,
                                  ),
                                ),
                                Container(
                                  width: getSize(100, "width", context),
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: Languages.of(context).embou,
                                  ),
                                ),
                                Container(
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: Languages.of(context).routebarre,
                                  ),
                                ),
                                Container(
                                  width: getSize(56, "width", context),
                                  height: getSize(27, "height", context),
                                  child: Tab(
                                    text: Languages.of(context).autre,
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          //Add this to give height
                          height: (MediaQuery.of(context).size.height / 1.7),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: getSize(26, "width", context)),
                            child: TabBarView(children: [
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(46, "width", context),
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        context
                                                    .watch<AlertProvider>()
                                                    .loadingState ==
                                                LoadingState.loading
                                            ? SkeletonColumn()
                                            : context
                                                .select(
                                                    (AlertProvider provider) =>
                                                        provider)
                                                .alertListHisto
                                                .fold((NException error) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      error.message,
                                                    )
                                                  ],
                                                );
                                              }, (alertListHisto) {
                                                return alertListHisto.isEmpty
                                                    ? Column(
                                                        children: [
                                                          Text(Languages.of(
                                                                  context)
                                                              .noalert)
                                                        ],
                                                      )
                                                    : alertListHisto
                                                                .where((i) =>
                                                                    i.address.split(",")[
                                                                            2] +
                                                                        "," +
                                                                        i.address.split(",")[
                                                                            3] ==
                                                                    " " +
                                                                        context
                                                                            .watch<
                                                                                PlaceProvider>()
                                                                            .userPlace
                                                                            .fold(
                                                                                (l) =>
                                                                                    null,
                                                                                (r) => r
                                                                                    .state)
                                                                            .toString() +
                                                                        ", " +
                                                                        context
                                                                            .watch<
                                                                                PlaceProvider>()
                                                                            .userPlace
                                                                            .fold(
                                                                                (l) =>
                                                                                    null,
                                                                                (r) => r
                                                                                    .country)
                                                                            .toString())
                                                                .toList()
                                                                .length >
                                                            0
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                alertListHisto
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final Alert
                                                                  alert =
                                                                  alertListHisto[
                                                                      index];
                                                              // print("heykkkk");
                                                              // print(alertListHisto
                                                              //   .where((i) =>
                                                              //       i.category
                                                              //           .name ==
                                                              //       "Embouteillage")
                                                              //   .toList()
                                                              //   .length);
                                                              return AllAlerte(
                                                                  alert: alert,
                                                                  type: "All",
                                                                  count: alertListHisto
                                                                      .length);
                                                            },
                                                          )
                                                        : Center(
                                                            child: Text(
                                                                Languages.of(
                                                                        context)
                                                                    .noalert,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center));
                                              })
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(46, "width", context),
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        context
                                                    .watch<AlertProvider>()
                                                    .loadingState ==
                                                LoadingState.loading
                                            ? SkeletonColumn()
                                            : context
                                                .select(
                                                    (AlertProvider provider) =>
                                                        provider)
                                                .alertListHisto
                                                .fold((NException error) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      error.message,
                                                    )
                                                  ],
                                                );
                                              }, (alertListHisto) {
                                                return alertListHisto.isEmpty
                                                    ? Column(
                                                        children: [
                                                          Text(Languages.of(
                                                                  context)
                                                              .noalert)
                                                        ],
                                                      )
                                                    : alertListHisto
                                                                .where((i) =>
                                                                    i.category
                                                                            .slug ==
                                                                        "Embouteillage" &&
                                                                    i.address.split(",")[2] +
                                                                            "," +
                                                                            i.address.split(",")[
                                                                                3] ==
                                                                        " " +
                                                                            context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.state).toString() +
                                                                            ", " +
                                                                            context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.country).toString())
                                                                .toList()
                                                                .length >
                                                            0
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                alertListHisto
                                                                    .length,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final Alert
                                                                  alert =
                                                                  alertListHisto[
                                                                      index];
                                                              return AllAlerte(
                                                                  alert: alert,
                                                                  type:
                                                                      "Embouteillage",
                                                                  count: alertListHisto
                                                                      .length);
                                                            },
                                                          )
                                                        : Center(child: Text(Languages.of(context).noalert, textAlign: TextAlign.center));
                                              })
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(46, "width", context),
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        context
                                                    .watch<AlertProvider>()
                                                    .loadingState ==
                                                LoadingState.loading
                                            ? SkeletonColumn()
                                            : context
                                                .select(
                                                    (AlertProvider provider) =>
                                                        provider)
                                                .alertListHisto
                                                .fold((NException error) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      error.message,
                                                    )
                                                  ],
                                                );
                                              }, (alertListHisto) {
                                                return alertListHisto.isEmpty
                                                    ? Column(
                                                        children: [
                                                          Text(Languages.of(
                                                                  context)
                                                              .noalert)
                                                        ],
                                                      )
                                                    : alertListHisto
                                                                .where((i) =>
                                                                    i.category
                                                                            .slug ==
                                                                        "Route-barree" &&
                                                                    i.address.split(",")[2] +
                                                                            "," +
                                                                            i.address.split(",")[
                                                                                3] ==
                                                                        " " +
                                                                            context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.state).toString() +
                                                                            ", " +
                                                                            context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.country).toString())
                                                                .toList()
                                                                .length >
                                                            0
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                alertListHisto
                                                                    .length,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final Alert
                                                                  alert =
                                                                  alertListHisto[
                                                                      index];
                                                              return AllAlerte(
                                                                  alert: alert,
                                                                  type:
                                                                      "Route-barree");
                                                            },
                                                          )
                                                        : Center(child: Text(Languages.of(context).noalert, textAlign: TextAlign.center));
                                              })
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(46, "width", context),
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        context
                                                    .watch<AlertProvider>()
                                                    .loadingState ==
                                                LoadingState.loading
                                            ? SkeletonColumn()
                                            : context
                                                .select(
                                                    (AlertProvider provider) =>
                                                        provider)
                                                .alertListCat
                                                .fold((NException error) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      error.message,
                                                    )
                                                  ],
                                                );
                                              }, (alertListCat) {
                                                // if (alertListCat.isEmpty) {
                                                // if(context.watch<UserProvider>().checkifmodal){
                                                //   print("checkifmodalentering");
                                                //   context.read<UserProvider>()
                                                //       .checkTab(true);
                                                // }else{
                                                //   print("checkifmodalsortering");
                                                //   context.read<UserProvider>()
                                                //       .checkTab(false);
                                                // }
                                                // }
                                                return alertListCat.isEmpty
                                                    ? Column(
                                                        children: [
                                                          AutreAlerteVide()
                                                        ],
                                                      )
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            alertListCat.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final Alert alert =
                                                              alertListCat[
                                                                  index];
                                                          // print(index);
                                                          return AutreAlerte(
                                                              alert: alert,
                                                              alertes:
                                                                  alertListCat,
                                                              type: cat,
                                                              index: index);
                                                        },
                                                      );
                                              })
                                      ],
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
            width: getSize(215, "width", context),
            height: getSize(21, "height", context),
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
          height: getSize(11, "height", context),
        ),
        SkeletonAnimation(
          child: Container(
            height: getSize(21, "height", context),
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
            width: getSize(215, "width", context),
            height: getSize(21, "height", context),
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
          height: getSize(11, "height", context),
        ),
        SkeletonAnimation(
          child: Container(
            height: getSize(21, "height", context),
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
            width: getSize(215, "width", context),
            height: getSize(21, "height", context),
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
          height: getSize(11, "height", context),
        ),
        SkeletonAnimation(
          child: Container(
            height: getSize(21, "height", context),
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
            width: getSize(215, "width", context),
            height: getSize(21, "height", context),
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
          height: getSize(11, "height", context),
        ),
        SkeletonAnimation(
          child: Container(
            height: getSize(21, "height", context),
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
  final Alert alert;
  final type;
  final count;

  AllAlerte({this.alert, this.type, this.count});
  @override
  Widget build(BuildContext context) {
    Moment.setLocaleGlobally(
        context.watch<UserProvider>().languageVal ? LocaleFr() : LocaleEn());
    var moment = Moment.now();
    var dateForComparison = DateTime.parse(alert.createdAt);
    var dateForNow = DateTime.parse(moment.toString());
    var descri = alert.desc != "desc" ? " au lieu dit " + alert.desc : "";
    var lieu_actuel = context
            .watch<PlaceProvider>()
            .userPlace
            .fold((l) => null, (r) => r.state)
            .toString() +
        ", " +
        context
            .watch<PlaceProvider>()
            .userPlace
            .fold((l) => null, (r) => r.country)
            .toString();
    // print("addresse cpouarnte");
    // print(context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.state).toString());

    loaderPopup() {
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: AppColors.whiteColor.withOpacity(0.92),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Card(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: getSize(70, "width", context),
                      height: getSize(70, "height", context),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                            getSize(15, "height", context)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.11),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getSize(10, "height", context),
                            horizontal: getSize(10, "width", context)),
                        child: Column(
                          children: [
                            Center(
                              child: SpinKitChasingDots(
                                color: HexColor("#A7BACB"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    deleteAlertPopup(alert_id) {
      showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: AppColors.whiteColor.withOpacity(0.96),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getSize(303, "width", context),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.circular(getSize(20, "height", context)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.11),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.all(getSize(20, "height", context)),
                          decoration: BoxDecoration(
                              // color: AppColors.whiteColor,
                              ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: Languages.of(context).deleteconfirm,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            getSize(18, "height", context),
                                        color: Colors.black)),
                              ),
                              SizedBox(
                                height: getSize(20, "height", context),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        height: getSize(40, "height", context),
                                        width: getSize(91, "width", context),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            loaderPopup();
                                            alertService
                                                .deleteAlert(alert_id)
                                                .then((data) {
                                              Navigator.pop(context);
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              0,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              0,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: AppColors
                                                                            .greenColor
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        overflow:
                                                                            Overflow.visible,
                                                                        children: <
                                                                            Widget>[
                                                                          Positioned(
                                                                            child: Center(
                                                                                child: Image.asset(
                                                                              'assets/images/Map pin-3.png',
                                                                              height: getSize(45.6, "height", context),
                                                                              width: getSize(37.77, "width", context),
                                                                            )),
                                                                          ),
                                                                          Positioned(
                                                                            left: getSize(
                                                                                60,
                                                                                "width",
                                                                                context),
                                                                            top: getSize(
                                                                                61,
                                                                                "height",
                                                                                context),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                              child: SizedBox(
                                                                                width: getSize(31, "height", context),
                                                                                height: getSize(31, "height", context),
                                                                                child: Card(
                                                                                  elevation: 2.5,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                  child: Center(
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: getSize(9, "height", context),
                                                                                      color: AppColors.greenColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      Languages.of(
                                                                              context)
                                                                          .alertdeleted,
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              context
                                                  .read<AlertProvider>()
                                                  .getAlertByUser(
                                                      "5ff34b88af0f1982ab03f3f9");
                                              context
                                                  .read<AlertProvider>()
                                                  .getAlertByUserCat(
                                                      "All", 1, lieu_actuel);
                                              // Timer(
                                              //     Duration(seconds: 3),
                                              //     () {
                                              //           print(
                                              //               "retour qui efface le popup");
                                              //           Navigator.pop(context);
                                              //         });
                                            }).catchError((onError) {
                                              Navigator.pop(context);
                                              // Timer(Duration(seconds: 3),
                                              //     () => Navigator.pop(context));
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              height: getSize(
                                                                  256,
                                                                  "height",
                                                                  context),
                                                              padding: EdgeInsets
                                                                  .all(getSize(
                                                                      0,
                                                                      "height",
                                                                      context)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              36,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              30,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child: Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        size: getSize(
                                                                            38,
                                                                            "height",
                                                                            context),
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      Languages.of(
                                                                              context)
                                                                          .error,
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          12,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Container(
                                                                      width: getSize(
                                                                          220,
                                                                          "width",
                                                                          context),
                                                                      child:
                                                                          Text(
                                                                        onError.response == null ||
                                                                                onError.response == ""
                                                                            ? Languages.of(context).errormsg
                                                                            : onError.response.data["message"],
                                                                        style: AppTheme
                                                                            .bodyText1
                                                                            .copyWith(
                                                                          color: AppColors
                                                                              .blackColor
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          },
                                          textColor: Colors.white,
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFFA7BACB),
                                                  Color(0xFF25296A),
                                                ],
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                0,
                                                getSize(5, "height", context),
                                                0,
                                                getSize(5, "height", context)),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Languages.of(context).yes,
                                                  style: TextStyle(
                                                    fontSize: getSize(
                                                        18, "height", context),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: getSize(40, "height", context),
                                      width: getSize(162, "width", context),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Color(0x162C306F),
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            getSize(5, "height", context),
                                            0,
                                            getSize(5, "height", context)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Languages.of(context).notks,
                                            style: TextStyle(
                                              fontSize: getSize(
                                                  18, "height", context),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    // var delai_time = alert.createdAt;
    var duration_in_minute =
        dateForComparison.difference(dateForNow).inMinutes.abs();
    // var hours = duration.asHours();
    return (type == alert.category.slug || type == "All") &&
            alert.address.split(",")[2] + "," + alert.address.split(",")[3] ==
                " " + lieu_actuel
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  onTap: () {
                    var cPosition = alert.lat + "," + alert.lon;
                    context.read<UserProvider>().updatePosition(cPosition);
                    context.read<BottomBarProvider>().modifyIndex(1);
                    //Navigator.of(context).pushNamed('/map');
                    //DefaultTabController.of(context).animateTo(1);
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                          context.watch<UserProvider>().languageVal
                              ? alert.category.name.capitalize()
                              : alert.category.name_en.capitalize(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.black)),
                      duration_in_minute <=
                                  int.parse(alert.category.delete_time) &&
                              context.watch<UserProvider>().userId.toString() ==
                                  alert.userId.id.toString()
                          ? GestureDetector(
                              child: Icon(Icons.delete, color: Colors.red),
                              onTap: () {
                                deleteAlertPopup(alert.id);
                              },
                            )
                          : Row()
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getSize(11, "height", context),
                        horizontal: 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: getSize(200, "width", context),
                          child: Text(
                              alert.address == '' || alert.address == null
                                  ? Languages.of(context).addressunknown
                                  : alert.address + descri,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: getSize(14, "height", context),
                                  color: Colors.black.withOpacity(.4))),
                        ),
                        SizedBox(
                          width: getSize(28, "width", context),
                        ),
                        SizedBox(
                            width: getSize(80, "width", context),
                            child: Text(moment.from(dateForComparison),
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: getSize(14, "height", context),
                                    color: Colors.black.withOpacity(.4)))),
                      ],
                    ),
                  ),
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
                child: Divider(thickness: 1, color: Color(0x26000000)),
              ),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }
}

class MaterialModal extends StatefulWidget {
  @override
  _MaterialModalState createState() => _MaterialModalState();
}

class _MaterialModalState extends State<MaterialModal> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 0, horizontal: getSize(0, "width", context)),
      child: Container(
        height: getSize(350, "height", context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: getSize(54.35, "width", context),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Divider(thickness: 4, color: Color(0x26000000)),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(0, getSize(35, "height", context), 0, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView(shrinkWrap: true, children: <Widget>[
                  // ListTile(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //       context
                  //           .read<AlertProvider>()
                  //           .getAlertByUserCat("Controle routier", 2);
                  //       context.read<UserProvider>().checkTab(false);
                  //     },
                  //     leading: Image.asset('assets/images/police.png',
                  //         height: getSize(24, "height", context),
                  //         width: getSize(24, "width", context)),
                  //     title: Text('Controle routier',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: getSize(16, "height", context),
                  //             color: Colors.black))),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AlertProvider>().getAlertByUserCat(
                            "Zone-dangereuse",
                            2,
                            context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.state)
                                    .toString() +
                                ", " +
                                context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.country)
                                    .toString());
                        context.read<UserProvider>().checkTab(false);
                      },
                      leading: Image.asset(
                          'assets/images/new-icon-alerts/test/zone-dangereuse.png',
                          height: getSize(24, "height", context),
                          width: getSize(24, "width", context)),
                      title: Text(Languages.of(context).zonedanger,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getSize(16, "height", context),
                              color: Colors.black))),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AlertProvider>().getAlertByUserCat(
                            "Accident-de-circulation",
                            2,
                            context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.state)
                                    .toString() +
                                ", " +
                                context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.country)
                                    .toString());
                        context.read<UserProvider>().checkTab(false);
                      },
                      leading: Image.asset(
                          'assets/images/new-icon-alerts/test/accident.png',
                          height: getSize(24, "height", context),
                          width: getSize(24, "width", context)),
                      title: Text(Languages.of(context).accidentdecircu,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getSize(16, "height", context),
                              color: Colors.black))),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AlertProvider>().getAlertByUserCat(
                            "Route-en-chantier",
                            2,
                            context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.state)
                                    .toString() +
                                ", " +
                                context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.country)
                                    .toString());
                        context.read<UserProvider>().checkTab(false);
                      },
                      leading: Image.asset(
                          'assets/images/new-icon-alerts/test/chantier-copie.png',
                          height: getSize(24, "height", context),
                          width: getSize(24, "width", context)),
                      title: Text(Languages.of(context).routechantier,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getSize(16, "height", context),
                              color: Colors.black))),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AlertProvider>().getAlertByUserCat(
                            "Police",
                            2,
                            context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.state)
                                    .toString() +
                                ", " +
                                context
                                    .read<PlaceProvider>()
                                    .userPlace
                                    .fold((l) => null, (r) => r.country)
                                    .toString());
                        context.read<UserProvider>().checkTab(false);
                      },
                      leading: Image.asset('assets/images/controle-routier.png',
                          height: getSize(24, "height", context),
                          width: getSize(24, "width", context)),
                      title: Text('Police',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getSize(16, "height", context),
                              color: Colors.black))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutreAlerte extends StatefulWidget {
  @override
  _AutreAlerteState createState() => _AutreAlerteState();
  final type;
  final index;
  final alertes;
  final Alert alert;
  AutreAlerte({this.alert, this.type, this.index, this.alertes});
}

class _AutreAlerteState extends State<AutreAlerte> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.index == 0
        ? context.read<UserProvider>().tabcheck
            ? showMaterialModalBottomSheet(
                expand: false,
                context: context,
                duration: const Duration(milliseconds: 500),
                backgroundColor: Colors.transparent,
                builder: (context) => MaterialModal(),
              )
            : print("autre_essai")
        : print("essaie"));
  }

  @override
  Widget build(BuildContext context) {
    Moment.setLocaleGlobally(
        context.watch<UserProvider>().languageVal ? LocaleFr() : LocaleEn());
    var moment = Moment.now();
    var dateForComparison = DateTime.parse(widget.alert.createdAt);
    var descri =
        widget.alert.desc != "desc" ? " au lieu dit " + widget.alert.desc : "";
    var dateForNow = DateTime.parse(moment.toString());
    var lieu_actuel = context
            .watch<PlaceProvider>()
            .userPlace
            .fold((l) => null, (r) => r.state)
            .toString() +
        ", " +
        context
            .watch<PlaceProvider>()
            .userPlace
            .fold((l) => null, (r) => r.country)
            .toString();
    // print("addresse cpouarnte");
    // print(context.watch<PlaceProvider>().userPlace.fold((l) => null, (r) => r.state).toString());

    loaderPopup() {
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: AppColors.whiteColor.withOpacity(0.92),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Card(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: getSize(70, "width", context),
                      height: getSize(70, "height", context),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                            getSize(15, "height", context)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.11),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getSize(10, "height", context),
                            horizontal: getSize(10, "width", context)),
                        child: Column(
                          children: [
                            Center(
                              child: SpinKitChasingDots(
                                color: HexColor("#A7BACB"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    deleteAlertPopup(alert_id) {
      showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: AppColors.whiteColor.withOpacity(0.96),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getSize(303, "width", context),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.circular(getSize(20, "height", context)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.11),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.all(getSize(20, "height", context)),
                          decoration: BoxDecoration(
                              // color: AppColors.whiteColor,
                              ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: Languages.of(context).deleteconfirm,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            getSize(18, "height", context),
                                        color: Colors.black)),
                              ),
                              SizedBox(
                                height: getSize(20, "height", context),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        height: getSize(40, "height", context),
                                        width: getSize(91, "width", context),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            loaderPopup();
                                            alertService
                                                .deleteAlert(alert_id)
                                                .then((data) {
                                              Navigator.pop(context);
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              0,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              0,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: AppColors
                                                                            .greenColor
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        overflow:
                                                                            Overflow.visible,
                                                                        children: <
                                                                            Widget>[
                                                                          Positioned(
                                                                            child: Center(
                                                                                child: Image.asset(
                                                                              'assets/images/Map pin-3.png',
                                                                              height: getSize(45.6, "height", context),
                                                                              width: getSize(37.77, "width", context),
                                                                            )),
                                                                          ),
                                                                          Positioned(
                                                                            left: getSize(
                                                                                60,
                                                                                "width",
                                                                                context),
                                                                            top: getSize(
                                                                                61,
                                                                                "height",
                                                                                context),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                              child: SizedBox(
                                                                                width: getSize(31, "height", context),
                                                                                height: getSize(31, "height", context),
                                                                                child: Card(
                                                                                  elevation: 2.5,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                  child: Center(
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: getSize(9, "height", context),
                                                                                      color: AppColors.greenColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      Languages.of(
                                                                              context)
                                                                          .alertdeleted,
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              context
                                                  .read<AlertProvider>()
                                                  .getAlertByUser(
                                                      "5ff34b88af0f1982ab03f3f9");
                                              context
                                                  .read<AlertProvider>()
                                                  .getAlertByUserCat(
                                                      "All", 1, lieu_actuel);
                                              // Timer(
                                              //     Duration(seconds: 3),
                                              //     () {
                                              //           print(
                                              //               "retour qui efface le popup");
                                              //           Navigator.pop(context);
                                              //         });
                                            }).catchError((onError) {
                                              Navigator.pop(context);
                                              // Timer(Duration(seconds: 3),
                                              //     () => Navigator.pop(context));
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              height: getSize(
                                                                  256,
                                                                  "height",
                                                                  context),
                                                              padding: EdgeInsets
                                                                  .all(getSize(
                                                                      0,
                                                                      "height",
                                                                      context)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              36,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              30,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child: Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        size: getSize(
                                                                            38,
                                                                            "height",
                                                                            context),
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      Languages.of(
                                                                              context)
                                                                          .error,
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          12,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Container(
                                                                      width: getSize(
                                                                          220,
                                                                          "width",
                                                                          context),
                                                                      child:
                                                                          Text(
                                                                        onError.response == null ||
                                                                                onError.response == ""
                                                                            ? Languages.of(context).errormsg
                                                                            : onError.response.data["message"],
                                                                        style: AppTheme
                                                                            .bodyText1
                                                                            .copyWith(
                                                                          color: AppColors
                                                                              .blackColor
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          },
                                          textColor: Colors.white,
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFFA7BACB),
                                                  Color(0xFF25296A),
                                                ],
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                0,
                                                getSize(5, "height", context),
                                                0,
                                                getSize(5, "height", context)),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Languages.of(context).yes,
                                                  style: TextStyle(
                                                    fontSize: getSize(
                                                        18, "height", context),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: getSize(40, "height", context),
                                      width: getSize(162, "width", context),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Color(0x162C306F),
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            getSize(5, "height", context),
                                            0,
                                            getSize(5, "height", context)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Languages.of(context).notks,
                                            style: TextStyle(
                                              fontSize: getSize(
                                                  18, "height", context),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    // var delai_time = alert.createdAt;
    var duration_in_minute =
        dateForComparison.difference(dateForNow).inMinutes.abs();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            onTap: () {
              var cPosition = widget.alert.lat + "," + widget.alert.lon;
              context.read<UserProvider>().updatePosition(cPosition);
              //Navigator.of(context).pushNamed('/map');
              // DefaultBottomNavigationBar.of(context).animateTo(1);
              context.read<BottomBarProvider>().modifyIndex(1);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                    context.watch<UserProvider>().languageVal
                        ? widget.alert.category.name.capitalize()
                        : widget.alert.category.name_en.capitalize(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: getSize(20, "height", context),
                        color: Colors.black)),
                duration_in_minute <=
                            int.parse(widget.alert.category.delete_time) &&
                        context.watch<UserProvider>().userId.toString() ==
                            widget.alert.userId.id.toString()
                    ? GestureDetector(
                        child: Icon(Icons.delete, color: Colors.red),
                        onTap: () {
                          deleteAlertPopup(widget.alert.id);
                        },
                      )
                    : Row()
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getSize(11, "height", context), horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getSize(200, "width", context),
                    child: Text(
                        widget.alert.address == '' ||
                                widget.alert.address == null
                            ? Languages.of(context).addressunknown
                            : widget.alert.address + descri,
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getSize(14, "height", context),
                            color: Colors.black.withOpacity(.4))),
                  ),
                  SizedBox(
                    width: getSize(28, "width", context),
                  ),
                  SizedBox(
                      width: getSize(80, "width", context),
                      child: Text(moment.from(dateForComparison),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getSize(14, "height", context),
                              color: Colors.black.withOpacity(.4)))),
                ],
              ),
            ),
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.5, 0, 20.5),
          child: Divider(thickness: 1, color: Color(0x26000000)),
        ),
      ],
    );
  }
}

class AutreAlerteVide extends StatefulWidget {
  @override
  _AutreAlerteVideState createState() => _AutreAlerteVideState();
}

class _AutreAlerteVideState extends State<AutreAlerteVide> {
  void initState() {
    super.initState();
    context.read<UserProvider>().getLangVal();
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
    return Center(
        child:
            Text(Languages.of(context).noalert, textAlign: TextAlign.center));
  }
}