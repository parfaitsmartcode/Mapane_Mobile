import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/models/user.dart';
import 'package:mapane/networking/services/search_service.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';
import 'base_provider.dart';
import 'package:flutter/material.dart';
import 'package:mapane/constants/socket.dart';
import 'dart:io' show Platform;



class UserProvider extends BaseProvider{
  Either<NException,List<User>> userData = Right([]);

  bool audioVal;
  bool connectVal;
  bool getval;
  bool first_time;
  String userPhone;
  String userDomicile;
  String userId;
  final TextEditingController domicilecontroller = TextEditingController();

  UserProvider(){
      this.getAudioNotification().then((value) {
        print("valeur des preferences " + value.toString());
      } );
      this.getAudioNotification().then((value) => this.audioVal = value );
      this.getConnectMode().then((value) => this.connectVal = value );
      print("valeur du booléean " + this.audioVal.toString());
      this.userPhone = "+237";
      this.userDomicile = " ";
      this.audioVal = false;
      this.connectVal = false;
      // this.first_time = true;
  }

  modifyAudioParam(test){
    audioVal = test;
    notifyListeners();
    storeAudioNotification(audioVal);
  }

  modifyConnectParam(test){
    connectVal = test;
    notifyListeners();
    storeConnectMode(connectVal);
  }

  getUserPhone() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userPhone = await _preferences.get('user_phone');
    return userPhone;
  }

  Future<String> getUserId() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userId= await _preferences.get('user_info');
    print("userId" + userId);
    return userId;
  }

  checkifpuceau(context) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    first_time = _preferences.getBool("first_time");
    userPhone = await _preferences.get('user_phone');
    if (first_time != null && !first_time) {// Not first time
      if (userPhone != null || userPhone != "+237") {
        Navigator.of(context).pushReplacementNamed('/map');
      } else {
        if (Platform.isAndroid) {
          Navigator.of(context).pushReplacementNamed('/numero-get');
        } else {
          Navigator.of(context).pushReplacementNamed('/numero-get-ios');
        }
      }
    } else {// First time
      setFirstTime();
      Navigator.of(context).pushReplacementNamed('/walk');
    }
    return first_time;
  }

  setFirstTime() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('first_time', false);
    first_time = false;
    return first_time;
  }

  testSocket() async {
    Sockete.emit("hey");
  }

  getUserDomicile() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userDomicile = await _preferences.get('user_domicile');
    userDomicile = userDomicile == null ? '' : userDomicile;
    notifyListeners();
    domicilecontroller.text = userDomicile == null ? '' : userDomicile;
  }

  setAudioNotification(){
    this.getAudioNotification().then((value) => this.audioVal = value );
    notifyListeners();
  }

  setConnectMode(){
    this.getConnectMode().then((value) => this.connectVal = value );
    notifyListeners();
  }

  //stockage du domicile
  storeDomicile(domicile){
    this.toggleLoadingState();
    userService.updateHouse(0, 0, domicile).then((data){
      userData = Right(data);
      this.toggleLoadingState();
    }).catchError((error){
      userData = Left(error);
      this.toggleLoadingState();
    });
  }

  //stockage du domicile
  updatePhone(phone, phonewrite, domicile){
    this.toggleLoadingState();
    userService.updateHouse(phone, phonewrite, domicile).then((data){
      userData = Right(data);
      this.toggleLoadingState();
    }).catchError((error){
      userData = Left(error);
      this.toggleLoadingState();
    });
  }

  //Modification des paramètres dans le SharedPreferences

  storeAudioNotification(audioParam){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("audioParam", audioParam, "bool");
  }

  storeConnectMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("connectMode", connectMode,"bool");
  }

  Future<bool>getAudioNotification() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    var value = await SharedPreferenceHelper(instance).getData("audioParam","bool");
    print("type de value " + value.runtimeType.toString());
    if(value == null){
      return false;
    }else{
      print(value);
      return value;
    }
  }

  Future<bool>getConnectMode() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    var value = await SharedPreferenceHelper(instance).getData("connectMode","bool");
    if(value == null){
      return false;
    }else{
      print(value);
      return value;
    }
  }


}

final UserProvider userProvider = UserProvider();