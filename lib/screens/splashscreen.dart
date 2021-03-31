import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:near_me/constants/assets.dart';
import 'package:near_me/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _navigate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
                constraints: BoxConstraints.expand(),
                decoration: _navigate
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.backgroundImage)))
                    : null,
                child: Container(
                  decoration: _navigate ? BoxDecoration(
                    gradient: LinearGradient(
                      begin:  Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.7),Colors.black,Colors.blue],
                      stops: [0.58,0.8,1.0]
                    )
                  ) : null,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                            Assets.logoPng
                        ),
                        if(_navigate)...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Les meilleures compétences à proximité",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ))
            );
  }
}
