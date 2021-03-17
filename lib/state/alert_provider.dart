import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/networking/services/alert_service.dart';
import 'package:mapane/utils/n_exception.dart';
import 'base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertProvider extends BaseProvider{

  Either<NException,List<Alert>> alertList = Right([]);
  Either<NException,List<Alert>> alertListCat = Right([]);
  Either<NException,List<Alert>> alertListHisto = Right([]);
  List<Alert> notifications = List<Alert>();
  List<Alert> countryAlerts = List<Alert>();
  Map<Alert,bool> readedAlerts = new Map<Alert,bool>();
  String addresseStored = "";


  updateAdresse(test){
    addresseStored = test;
    notifyListeners();
    // storeLang(test);
  }
  
  getAlertList(loader,String country){
    loader ?? this.toggleLoadingState();
    alertService.getAlerts().then((alerts){
      alertList = Right(alerts);
      loader ?? this.toggleLoadingState();
      filterAlertsByCountry(country);
    }).catchError((error){
      alertList = Left(error);
      loader ?? this.toggleLoadingState();
    });
  }
  deactivateAudioNotif(int index){
    //readedAlerts
  }

  filterAlertsByCountry(String country){
    countryAlerts.clear();
    var comparator = country.split(",");
    print(comparator[comparator.length-1]);
    this.alertList.fold((l) => null,(r){
      r.forEach((element) {
        var data = element.address.split(",");
        if(data[data.length-1].contains(comparator[comparator.length-1])){
          countryAlerts.add(element);
        }
      });
    });
    notifyListeners();
  }
  getAlertByUser(id) async {
    SharedPreferences  _preferences = await SharedPreferences.getInstance();
    String userId = await  _preferences.get('user_info');
    this.toggleLoadingState();
    alertService.getAlertByUser(userId).then((alerts){
      print('adresse stocké');
      print(addresseStored);
      alertListHisto = Right(alerts);
      this.toggleLoadingState();
    }).catchError((error){
      alertListHisto = Left(error);
      this.toggleLoadingState();
    });
  }

  getAlertByUserCat(id,type,addr) async {
    SharedPreferences  _preferences = await SharedPreferences.getInstance();
    String userId = await  _preferences.get('user_info');
    if(type == 1){
      alertService.getAlertByUserCat(userId,id,addr).then((alerts){
        alertListCat = Right(alerts);
      }).catchError((error){
        alertListCat = Left(error);
      });
    }else{
      this.toggleLoadingState();
      alertService.getAlertByUserCat(userId,id,addr).then((alerts){
        alertListCat = Right(alerts);
        this.toggleLoadingState();
      }).catchError((error){
        alertListCat = Left(error);
        this.toggleLoadingState();
      });
    }
  }
  
  pushNotification(Alert alert,String userId){
    print(alert);
    if(alert.userId.id != userId){
      this.notifications.insert(0,alert);
      notifyListeners();
    }
  }

  popNotification(int index) {
    this.notifications.removeAt(index);
    notifyListeners();
  }
  popAllNotifications(){
    this.notifications.clear();
    notifyListeners();
  }

  makeAlert(String slug,String address,LatLng coord,String userId) async{

    print(userId);
    // alertService.createAlert(coord, "test", userId, slug, address).then((value) {
    //   print(value);
    // });
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