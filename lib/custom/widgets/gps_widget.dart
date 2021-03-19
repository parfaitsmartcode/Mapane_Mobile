import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mapane/constants/assets.dart';
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
                    Assets.gpsPicture
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
                      "Impossible d’acceder au service de localisation. Veuillez l'activer.",
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
          ]),
        ),
      ),
    );
  }
}
