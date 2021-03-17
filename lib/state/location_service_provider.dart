import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapane/custom/widgets/gps_widget.dart';

class LocationServiceProvider extends ChangeNotifier{
  int i = 0;
  final Location location = new Location();
  init() {
    new Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      bool _serviceEnabled = await location.serviceEnabled();
      print("checking location $_serviceEnabled");
      if(!_serviceEnabled){
        if(i == 0){
          i++;
          BotToast.showCustomNotification(
            enableSlideOff: false,
            toastBuilder: (_) => LocationServiceConnexion(),
            duration: Duration(minutes: 10000),
          );
        }
      }else{
        if(i != 0){
          BotToast.cleanAll();
          i != 0 ?? i--;
        }
      }
    });
  }
}