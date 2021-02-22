import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/models/category.dart';
import 'package:mapane/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';

class AlertService {
  Future<List<Alert>> getAlerts() async {
    try {
      final String uri = locator<Di>().apiUrl + "/alerts";
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      final items = response.data["alerts"].cast<Map<String, dynamic>>();
      List<Alert> schools = items.map<Alert>((json) {
        return Alert.fromJson(json);
      }).toList();
      return schools;
    } on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<List<Alert>> getAlertByUser(id) async {
    try {
      final String uri = locator<Di>().apiUrl + "/alerts/"+id;
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      final items = response.data["alerts"].cast<Map<String, dynamic>>();
      List<Alert> schools = items.map<Alert>((json) {
        return Alert.fromJson(json);
      }).toList();
      return schools;
    } on DioError catch (e) {
      throw new NException(e);
    }
  }

  Future<List<Alert>> getAlertByUserCat(id, cat) async {
    try {
      final String uri = locator<Di>().apiUrl + "/alerts/" + id;
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      print(response.data["alerts"]);
      final items = response.data["alerts"].cast<Map<String, dynamic>>();
      List<Alert> schools = items.map<Alert>((json) {
        // if(Alert.fromJson(json).category.name == cat){
        return Alert.fromJson(json);
        // }
      }).toList();
      return schools.where((i) => i.category.name == cat).toList();
    } on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<Category> getCategoriesId(String name) async {
    try{
      final String uri = locator<Di>().apiUrl + "/categories";
      Response response = await locator<Di>().dio.get(
        uri,
        options: Options(headers: {"content-type": "application/json"})
      );
      final items = response.data["categories"].cast<Map<String,dynamic>>();
      List<Category> categories = items.map<Category>((json){
        return Category.fromJson(json);
      }).toList();
      return categories.where((c) => c.name.contains(name)).first;
    } on DioError catch (e) {
      throw new NException(e);
    }
  }
  Future<dynamic> createAlert(LatLng coord,String description,String userId,String slug,String address) async{
    try{
      final String uri = locator<Di>().apiUrl + "/create-alert";
      Response response = await locator<Di>().dio.post(
          uri,
          data: {
            "lat": coord.latitude,
            "long": coord.longitude,
            "desc": description,
            "postedBy": userId,
            "category": slug,
            "address": address == '' ? ' ' : address
          },
          options: Options(headers:{"content-type": "application/json"})
      );
      // final alertProvider = AlertProvider();
      // alertProvider.getAlertByUser("5ff34b88af0f1982ab03f3f9");
      // alertProvider.getAlertByUserCat("All", 1);
      return response.data["message"];
    } on DioError catch (e) {
      print(e);
      throw new NException(e);
    }
  }
}

final AlertService alertService = AlertService();
