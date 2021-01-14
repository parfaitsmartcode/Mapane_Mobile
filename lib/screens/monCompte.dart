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
          child: Column(
            children: [
              Column(
                children: [
                  Text("Photo"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Mon compte",
                            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 31),
                            ),
                          Text(
                            "+237 690348765",
                            ),
                        ],
                      ),
                      Container(
                        child:Text("Map"),
                      )
                    ],
                  ),
                  Text("Image"),
                  Container(
                    decoration: Decoration(),
                    child: Column(                      
                      children: [
                        ListTile(
                          leading: FlutterLogo(),
                          title: Text(
                            'Modifier le numéro',
                            style: Theme.of(context).textTheme.bodyText1,
                            ),
                        ),
                        ListTile(
                          leading: FlutterLogo(),
                          title: Text(
                            'Enregistrer votre domicile',
                            style: Theme.of(context).textTheme.bodyText1,
                            ),
                        ),
                        ListTile(
                          leading: FlutterLogo(),
                          title: Text(
                            'Paramètres de l\'application',
                            style: Theme.of(context).textTheme.bodyText1,
                            ),
                        ),
                        ListTile(
                          leading: FlutterLogo(),
                          title: Text(
                            'Quitter l\'application',
                            style: Theme.of(context).textTheme.bodyText1,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
