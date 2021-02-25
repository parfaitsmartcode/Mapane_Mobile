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
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;



class UserProvider extends BaseProvider{
  Either<NException,List<User>> userData = Right([]);

  bool audioVal;
  bool connectVal;
  bool popupVal;
  bool getval;
  bool first_time;
  bool loadering;
  String userPhone;
  String userDomicile;
  String userId;
  bool tabcheck;
  bool checkifmodal;
  String cPositionGo;
  final TextEditingController domicilecontroller = TextEditingController();

  UserProvider(){
      this.getAudioNotification().then((value) {
        print("valeur des preferences " + value.toString());
      } );
      // this.getAudioNotification().then((value) => this.audioVal = value );
      this.getConnectMode().then((value) => this.connectVal = value );
      print("valeur du booléean " + this.audioVal.toString());
      this.userPhone = "+237";
      this.userDomicile = " ";
      this.audioVal = true;
      this.connectVal = false;
      this.loadering = false;
      this.tabcheck = false;
      this.checkifmodal = false;
      this.popupVal = true;
      this.cPositionGo = null;
      // this.first_time = true;
  }

  modifyAudioParam(test){
    audioVal = test;
    notifyListeners();
    storeAudioNotification(audioVal);
  }

  modifyPopupParam(test){
    popupVal = test;
    notifyListeners();
    storePopupNotification(test);
  }

  modifyConnectParam(test){
    connectVal = test;
    notifyListeners();
    storeConnectMode(connectVal);
  }

  modifyLoader(test){
    loadering = test;
    notifyListeners();
  }

  updatePosition(test){
    cPositionGo = test;
    notifyListeners();
    storePositionMode(test);
  }

  checkTab(test){
    tabcheck = test;
    notifyListeners();
  }
  
  checkModal(test){
    checkifmodal = test;
    notifyListeners();
  }
  
  updateUserPhone(test){
    userPhone = test;
    notifyListeners();
  }

  getUserPhone() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userPhone = await _preferences.get('user_phone');
    return userPhone;
  }

  getPopupVal() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    popupVal = await _preferences.get('popup_param');
    if(popupVal == null){
      storePopupNotification(true);
      popupVal = true;
    }
    return popupVal;
  }

  getAudioVal() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    audioVal = await _preferences.get('audioParam');
    if(audioVal == null){
      storeAudioNotification(true);
      audioVal = true;
    }
    return audioVal;
  }

  getPositionVal() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    cPositionGo = await _preferences.get('positionMode');
    return cPositionGo;
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
    print("testify");
    print(userPhone);
    print(first_time);
    if (first_time != null && !first_time) {// Not first time
      if (userPhone != null && userPhone != "+237" && userPhone != "" && userPhone.length > 5) {
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

  checkreturngetnumberpage(context) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userPhone = await _preferences.get('user_phone');
    if (userPhone != null && userPhone != "+237" && userPhone != "" && userPhone.length > 5) {
      SystemNavigator.pop();
    }
  }

  setFirstTime() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('first_time', false);
    first_time = false;
    return first_time;
  }

  testSocket() async {
    // SocketHelper.emit("hey");
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

  storePopupNotification(test){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("popup_param", test, "bool");
  }

  storeConnectMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("connectMode", connectMode,"bool");
  }

  storePositionMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("positionMode", connectMode,"string");
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