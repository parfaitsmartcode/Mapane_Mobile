
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/models/category.dart';
import 'package:mapane/networking/services/alert_service.dart';
import 'package:mapane/utils/n_exception.dart';
import 'base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';

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

  makeAlert() async{
    alertService.createAlert(LatLng(19,12), "test", "601287248f3e902d60579854", Category(name:"embouitellage",id:"601287248f3e902d60579854"), "test").then((value) {
      print(value);
    });
  }

}