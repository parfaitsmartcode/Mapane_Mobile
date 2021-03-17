import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationServiceProvider extends ChangeNotifier{
  int i = 0;
  final Location location = new Location();
  init() {
    new Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      bool _serviceEnabled = await location.serviceEnabled();
      print("checking location $_serviceEnabled");
      if(!_serviceEnabled){
        if(i == 0){
          i++;
          /*BotToast.showCustomNotification(
            enableSlideOff: false,
            toastBuilder: (_) => Center(
              child: SizedBox(
                height: 250,
                width: 350,
                child: Card(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pour une meilleure experience activer la localisation de votre appareil dans le centre de notification"
                      )
                    ],
                  ),
                ),
              ),
            ),
            duration: Duration(minutes: 10000),
          );*/
        }
      }else{
        i != 0 ?? i--;
      }
    });
  }
}