import 'package:dio/dio.dart';
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
      //print(response.data["alerts"]);
      final items = response.data["alerts"].cast<Map<String, dynamic>>();
      List<Alert> schools = items.map<Alert>((json) {
        return Alert.fromJson(json);
      }).toList();
      return schools.where((i) => i.category.slug != "S.O.S").toList();
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
      print(response.data);
      List<Alert> schools = items.map<Alert>((json) {
        return Alert.fromJson(json);
      }).toList();
      return schools.where((i) => i.category.slug != "S.O.S").toList();
    } on DioError catch (e) {
      throw new NException(e);
    }
  }

  Future<List<Alert>> getAlertByUserCat(id, cat, addr) async {
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
      return schools.where((i) => i.category.slug == cat && i.address.split(",")[2] == " "+addr).toList();
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
  Future<dynamic> createAlert(double lat, double lon, String description,String userId,String slug,String address) async{
    print("Envoie api");
    print(lat);
    try{
      final String uri = locator<Di>().apiUrl + "/create-alert";
      Response response = await locator<Di>().dio.post(
          uri,
          data: {
            "lat": lat,
            "long": lon,
            "desc": description,
            "postedBy": userId,
            "category": slug,
            "address": address
          },
          options: Options(headers:{"Content-Type": "application/json"})
      );
      print("resultat api");
      print(response.data);
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e);
      throw new NException(e);
    }
  }
}

final AlertService alertService = AlertService();
