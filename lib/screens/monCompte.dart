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
                      InkWell(
                        child: Container(
                          height: getSize(38, "height", context),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      getSize(5, "width", context),
                                      0,
                                      getSize(15, "width", context),
                                      0),
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
                                          fontSize:
                                              getSize(14, "height", context),
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.blue,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height -  80,
            padding: EdgeInsets.all(20),
            color: Colors.red,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      // color: AppColors.whiteColor,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 0.01529 *
                                  MediaQuery.of(context)
                                      .size
                                      .height,
                            ),
                            Text(
                              "Sélectionner un numéro",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 0.02177 *
                                  MediaQuery.of(context)
                                      .size
                                      .height,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Color(0x26000000),
                                        width: 1),
                                  ),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets
                                              .symmetric(
                                          horizontal: 10,
                                          vertical: 12),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .all(
                                                            0.0),
                                                    child: ListTile(
                                                      title: Align(
                                                        child: Text(
                                                          'Veuillez entrer une SIM',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w400,
                                                              fontSize:
                                                                  20,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 0.02177 *
                                  MediaQuery.of(context)
                                      .size
                                      .height,
                            ),
                            Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 36),
                                    child: RaisedButton(
                                      onPressed: () {
                                        
                                      },
                                      textColor: Colors.white,
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius
                                                .circular(100.0),
                                      ),
                                      child: Container(
                                            width: 400,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      100),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFFA7BACB),
                                                  Color(0xFF25296A),
                                                ],
                                              ),
                                            ),
                                            padding: const EdgeInsets
                                                    .fromLTRB(
                                                24, 12, 24, 12),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets
                                                              .only(
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                  child: SizedBox(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.white,
                                                      strokeWidth: 1,
                                                    ),
                                                    height: 18.0,
                                                    width: 18.0,
                                                  ),
                                                ),
                                                Text('Sauvearder',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            )),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      });

                        },
                      ),
                      Container(
                        height: getSize(38, "height", context),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    getSize(5, "width", context),
                                    0,
                                    getSize(15, "width", context),
                                    0),
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
                                        fontSize:
                                            getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getSize(38, "height", context),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    getSize(5, "width", context),
                                    0,
                                    getSize(15, "width", context),
                                    0),
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
                                        fontSize:
                                            getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getSize(38, "height", context),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    getSize(5, "width", context),
                                    0,
                                    getSize(15, "width", context),
                                    0),
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
                                        fontSize:
                                            getSize(14, "height", context),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
