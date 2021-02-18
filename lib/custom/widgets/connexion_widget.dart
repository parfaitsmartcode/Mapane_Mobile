import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mapane/utils/size_config.dart';
import 'dart:ui';

class LostConnexion extends StatelessWidget {
  const LostConnexion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          constraints: BoxConstraints.expand(),
          color: Color.fromRGBO(248, 248, 248, 0.5),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/Rounded Icon box.png',
                      ),
                      SizedBox(
                        height: getSize(15, "height", context),
                      ),
                      Text(
                        "Connexion perdue",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: getSize(10, "height", context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getSize(35, "width", context)),
                        child: Text(
                          "Impossible d’établir une connexion avec notre serveur. Vérifier votre accès à internet.",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(.5)),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: getSize(50, "height", context),
                  child: Column(
                    children: [
                      FlatButton(
                        onPressed: () {},
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(68.0),
                          side: BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          color: Colors.transparent,
                          width: getSize(245, "width", context),
                          padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Actualiser',
                                  style: TextStyle(fontSize: 16)),
                              Image.asset(
                                'assets/images/refresh-icon.png',
                                height: getSize(15, "height", context),
                              )
                            ],
                          )),
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        );
  }
}

class RecameConnexion extends StatelessWidget {
  const RecameConnexion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 248, 0.5),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/Rounded Icon box-checked.png',
                      ),
                      SizedBox(
                        height: getSize(15, "height", context),
                      ),
                      Text(
                        "Connexion rétablie",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: getSize(10, "height", context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getSize(35, "width", context)),
                        child: Text(
                          "Vous êtes de nouveau connecté à notre serveur.\nContinuer de travailler en toute sécurité.",
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}

class LoadingConnexion extends StatelessWidget {
  const LoadingConnexion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          constraints: BoxConstraints.expand(),
          color: Color.fromRGBO(248, 248, 248, 0.5),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/Groupe 14-connexion.png',
                      ),
                    ],
                  ),
                ),
              Positioned(
                  bottom: getSize(50, "height", context),
                  child: Column(
                    children: [
                      Text(
                        "Accès à internet",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: getSize(10, "height", context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getSize(35, "width", context)),
                        child: Text(
                          "Connexion en cours avec le serveur…",
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(.5)),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        );
  }
}