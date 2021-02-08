
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Mapane/constants/socket.dart';
import 'package:Mapane/models/alert.dart';
import 'package:Mapane/models/place.dart';
import 'package:Mapane/networking/services/alert_service.dart';
import 'package:Mapane/state/place_provider.dart';
import 'package:Mapane/utils/n_exception.dart';
import '../di.dart';
import '../service_locator.dart';
import 'base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertProvider extends BaseProvider{

  Either<NException,List<Alert>> alertList = Right([]);
  Either<NException,List<Alert>> alertListCat = Right([]);

  getAlertList(){
    this.toggleLoadingState();
    alertService.getAlerts().then((alerts){
      alertList = Right(alerts);
      this.toggleLoadingState();
    }).catchError((error){
      alertList = Left(error);
      this.toggleLoadingState();
    });
  }

  getAlertByUser(id) async {
    SharedPreferences  _preferences = await SharedPreferences.getInstance();
    String userId = await  _preferences.get('user_info');
    this.toggleLoadingState();
    alertService.getAlertByUser(userId).then((alerts){
      alertList = Right(alerts);
      this.toggleLoadingState();
    }).catchError((error){
      alertList = Left(error);
      this.toggleLoadingState();
    });
  }

  getAlertByUserCat(id,type) async {
    SharedPreferences  _preferences = await SharedPreferences.getInstance();
    String userId = await  _preferences.get('user_info');
    if(type == 1){
      alertService.getAlertByUserCat(userId,id).then((alerts){
        alertListCat = Right(alerts);
      }).catchError((error){
        alertListCat = Left(error);
      });
    }else{
      this.toggleLoadingState();
      alertService.getAlertByUserCat(userId,id).then((alerts){
        alertListCat = Right(alerts);
        this.toggleLoadingState();
      }).catchError((error){
        alertListCat = Left(error);
        this.toggleLoadingState();
      });
    }
  }

  makeAlert(String slug,String address,LatLng coord,String userId) async{

    print(userId);
    alertService.createAlert(coord, "test", userId, slug, address).then((value) {
      print(value);
    });
    // SocketHelper.emit("createAlert",arguments: {
    //   "lat": 15,//coord.latitude,
    //   "long": 17,//coord.longitude,
    //   "desc": "test",
    //   "postedBy": "userId",
    //   "category": 'slug',
    //   "address": "address"
    // });
    // SocketHelper.subscribe("createAlertOk", (value){
    //   print(value);
    // });
  }

}