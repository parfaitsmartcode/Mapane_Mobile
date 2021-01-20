import 'package:flutter/material.dart';
import '../utils/theme_mapane.dart';
import '../utils/size_config.dart';

class MonCompte extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MonCompte> {
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
            padding: EdgeInsets.symmetric(
                vertical: getSize(9, "height", context),
                horizontal: getSize(36, "width", context)),
            child: Column(
              children: [
                // SizedBox(
                //     height: 8,
                //   ),
                Image.asset(
                  'assets/images/Logo-long-edited.png',
                  height: getSize(39, "height", context),
                ),
                SizedBox(
                  height: getSize(34, "height", context),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: getSize(20, "width", context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mon compte",
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      fontSize: 31,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackColor,
                                      letterSpacing: 0,
                                    ),
                          ),
                          Text(
                            "+237 690348765",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor.withOpacity(0.46),
                                  fontSize: getSize(17, "height", context),
                                  letterSpacing: 0,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: Elevation.low,
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(
                              getSize(19, "height", context)),
                        ),
                        // padding: EdgeInsets.all(4),
                        width: getSize(39, "width", context),
                        height: getSize(38, "height", context),
                        child: Center(
                          child: Image.asset(
                            'assets/images/Logo-small.png',
                            height: getSize(20, "height", context),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getSize(24, "height", context),
                ),
                Image.asset('assets/images/image-map.png',
                    width: double.infinity),
                SizedBox(
                  height: getSize(34, "height", context),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: Elevation.low,
                    color: AppColors.whiteColor,
                    borderRadius:
                        BorderRadius.circular(getSize(30, "height", context)),
                  ),
                  padding: EdgeInsets.only(
                      left: getSize(15, "width", context),
                      top: getSize(17, "height", context),
                      right: getSize(20, "width", context),
                      bottom: getSize(15, "height", context)),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/Tel-icon.png',
                                  height: getSize(24, "height", context),
                                  width: getSize(24, "width", context),
                                )),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Modifier le numéro',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/Map-pin-icon-noir.png',
                                  height: getSize(24, "height", context),
                                  width: getSize(24, "width", context),
                                )),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Enregistrer votre domicile',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/Settings-icon.png',
                                  height: getSize(24, "height", context),
                                  width: getSize(24, "width", context),
                                )),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Paramètres de l\'application',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/Logout-icon.png',
                                  height: getSize(24, "height", context),
                                  width: getSize(24, "width", context),
                                )),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Quitter l\'application',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // children: [
                    //   SizedBox(
                    //     height: getSize(37,"height",context),
                    //     child: ListTile(
                    //         leading: Image.asset('assets/images/Tel-icon.png', height: getSize(24,"height",context), width: getSize(24,"width",context),),
                    //         title: Align(
                    //           child: Text(
                    //             'Modifier le numéro',
                    //             style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: getSize(14,"height",context), fontWeight: FontWeight.w400),
                    //             ),
                    //             alignment: Alignment.centerLeft,
                    //         ),
                    //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    //         dense:true,
                    //       ),
                    //   ),
                    //   SizedBox(
                    //     height: getSize(37,"height",context),
                    //     child: ListTile(
                    //       leading: Image.asset('assets/images/Map-pin-icon-noir.png', height: getSize(24,"height",context), width: getSize(24,"width",context),),
                    //       title: Align(
                    //           child: Text(
                    //           'Enregistrer votre domicile',
                    //           style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: getSize(14,"height",context), fontWeight: FontWeight.w400),
                    //           ),
                    //           alignment: Alignment.centerLeft,
                    //       ),
                    //       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    //       dense:true,
                    //     ),
                    //   ),
                    //   SizedBox(
                    //     height: getSize(37,"height",context),
                    //     child: ListTile(
                    //       leading: Image.asset('assets/images/Settings-icon.png', height: getSize(24,"height",context),),
                    //       title: Align(
                    //           child: Text(
                    //           'Paramètres de l\'application',
                    //           style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: getSize(14,"height",context), fontWeight: FontWeight.w400),
                    //           ),
                    //           alignment: Alignment.centerLeft,
                    //       ),
                    //       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    //       dense:true,
                    //     ),
                    //   ),
                    //   SizedBox(
                    //     height: getSize(37,"height",context),
                    //     width: 400,
                    //       child: ListTile(
                    //       leading: Image.asset('assets/images/Logout-icon.png', height: getSize(24,"height",context),),
                    //       title: SizedBox(
                    //         width: 400,
                    //         child: Align(
                    //             child: Text(
                    //             'Quitter l\'application',
                    //             style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: getSize(14,"height",context), fontWeight: FontWeight.w400),
                    //             ),
                    //             alignment: Alignment.centerLeft,
                    //         ),
                    //       ),
                    //       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    //       dense:true,
                    //     ),
                    //   ),
                    // ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
