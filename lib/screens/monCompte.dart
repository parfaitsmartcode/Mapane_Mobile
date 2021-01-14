import 'package:flutter/material.dart';
import '../utils/theme_mapane.dart';

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
        child:Container(
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
          padding: EdgeInsets.symmetric(vertical: 9, horizontal: 36),
          child:
            Column(
              children: [
                // SizedBox(
                //     height: 8,
                //   ),
                Image.asset('assets/images/Logo-long-edited.png', height: 39,),
                SizedBox(
                  height: 34,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                            style: 
                              Theme.of(context).textTheme.headline3.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor.withOpacity(0.46),
                                  fontSize: 17,
                                  letterSpacing: 0,
                                ),
                            ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: Elevation.low,
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        // padding: EdgeInsets.all(4),
                        width: 38,
                        height: 38,
                        child:Center(
                          child:Image.asset('assets/images/Logo-small.png', height: 20,),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Image.asset('assets/images/image-map.png', height: 118,),
                SizedBox(
                          height: 34,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: Elevation.low,
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.only(left: 20, top: 9, right: 20, bottom: 18),
                  child: Column(                      
                    children: [
                      SizedBox(
                        height: 37,
                        child: ListTile(
                            leading: Image.asset('assets/images/Tel-icon.png', height: 24,),
                            title: Align(
                              child: Text(
                                'Modifier le numéro',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              alignment: Alignment(-1.3,0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                            dense:true,
                          ),
                      ),
                      SizedBox(
                        height: 37,
                        child: ListTile(
                          leading: Image.asset('assets/images/Map-pin-icon-noir.png', height: 24,),
                          title: Align(
                              child: Text(
                              'Enregistrer votre domicile',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              alignment: Alignment(-1.7,0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          dense:true,
                        ),
                      ),
                      SizedBox(
                        height: 37,
                        child: ListTile(
                          leading: Image.asset('assets/images/Settings-icon.png', height: 24,),
                          title: Align(
                              child: Text(
                              'Paramètres de l\'application',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              alignment: Alignment(-2,0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          dense:true,
                        ),
                      ),
                      SizedBox(
                        height: 37,
                          child: ListTile(
                          leading: Image.asset('assets/images/Logout-icon.png', height: 24,),
                          title: Align(
                              child: Text(
                              'Quitter l\'application',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              alignment: Alignment(-1.3,0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          dense:true,  
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
