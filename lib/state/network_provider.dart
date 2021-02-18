import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapane/custom/widgets/connexion_widget.dart';
import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier{

  init(){
    print("affichage du toast");
    BotToast.showCustomNotification(
      toastBuilder: (_) =>
          Center(
            child: Container(
              width: 250,
                height: 250,
                child: LostConnexion()
            )
          ),
      duration: Duration(seconds: 15),

    );
    /*BotToast.showLoading(

    );*/
  }
}