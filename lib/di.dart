import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Di{

  final String apiUrl = "https://mapane.smartcodegroup.com";

  Dio dio = new Dio();

  final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey globalBottomNavigationKey = new GlobalKey(debugLabel: 'btm_app_bar');
}