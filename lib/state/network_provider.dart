import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapane/custom/widgets/connexion_widget.dart';
import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier {
  int i = 0;
  init() {
    new Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      bool result = await DataConnectionChecker().hasConnection;
      if (result == true) {
        BotToast.cleanAll();
        i=0;
      } else {
        if (i == 0) {
          BotToast.showCustomNotification(
            enableSlideOff: false,
            toastBuilder: (_) => LostConnexion(),
            duration: Duration(minutes: 10000),
          );
          i++;
        }
      }
    });
  }
}
