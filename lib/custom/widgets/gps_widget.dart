import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mapane/utils/size_config.dart';

class LocationServiceConnexion extends StatelessWidget {
  const LocationServiceConnexion({
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
                    "Localisation désactivée",
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
                      "Impossible d’acceder au service de localisation. Veuillez l'activer dans le centre de notification ou dans les paramètres",
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
