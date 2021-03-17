import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final BuildContext context;

  PushNotificationService(this._fcm,this.context);

  String getRestrictedCharacters(String string){
    const allowedCharacters = r"""abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~%""";
    final split = string.split('');
    Set<String> restricted = Set();
    int i = 0;
    split.forEach((c) {
      if (!allowedCharacters.contains(c)) {
        restricted.add(c);
      }
      i++;
    });
    if (restricted.isEmpty){
      return string.replaceAll(" ", "");
    } else {
      restricted.forEach((element) {
        split.removeWhere((item) => item == element);
      });
      return split.join("").replaceAll(" ", "");
    }
  }

  Future initialise(String country, String state) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    country = getRestrictedCharacters(country);
    state = getRestrictedCharacters(state);

    _fcm
        .subscribeToTopic('mapane-alerts')
        .then((value) {
          print("success to subscribe");
    })
        .catchError((onError) => print("failed subscription to mapane-alerts"));

    _fcm
        .subscribeToTopic('mapane-alerts-$country-$state')
        .then((value) {
      print("success to subscribe");
    })
        .catchError((onError) =>
        print("failed subscription to mapane-alerts-$country-$state"));

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print("id de user");
        // String userId = "";
        context.read<UserProvider>().getUserId().then((value){
          if (Alert.fromJson(json.decode(message['data']['body'])['alerte1'])
              .address
              .split(",")[2] ==
              " " +
                  context
                      .read<PlaceProvider>()
                      .userPlace
                      .fold((l) => null, (r) => r.state)
                      .toString()) {
            context.read<AlertProvider>().pushNotification(Alert.fromJson(json.decode(message['body'])['alerte1']),value);
          }
        });
        // print(userId);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Alert alert = Alert.fromJson(json.decode(message['body'])['alerte1']);
          var cPosition = alert.lat+","+alert.lon;
          context.read<UserProvider>().updatePosition(cPosition);
        });
      },
    );
  }
}