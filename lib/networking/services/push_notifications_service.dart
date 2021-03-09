import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final BuildContext context;

  PushNotificationService(this._fcm,this.context);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    _fcm.subscribeToTopic('mapane-alerts').then((value){
      print("successfully subscribe");
    }).catchError((onError) => print("failed subscription"));
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        String userId = "";
        context.read<UserProvider>().getUserId().then((value) => userId = value);
        context.read<AlertProvider>().pushNotification(Alert.fromJson(json.decode(message['data']['body'])['alerte1']),userId);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Alert alert = Alert.fromJson(json.decode(message['data']['body'])['alerte1']);
          var cPosition = alert.lat+","+alert.lon;
          context.read<UserProvider>().updatePosition(cPosition);
        });
      },
    );
  }
}