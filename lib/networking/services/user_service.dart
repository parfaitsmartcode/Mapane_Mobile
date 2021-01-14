import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mapane/models/user.dart';
import '../../di.dart';
import '../../service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';


Future<dynamic> getSchools() async{
  try{

    Response response = await locator<Di>().dio.get(locator<Di>().apiUrl+"/school/all",
      options: Options(
          headers: {
            "content-type":"application/json"
          }
      ),
    );

    if(response.statusCode == 200){
      final items = response.data["users"].cast<Map<String,dynamic>>();
      List<User> schools = items.map<User>((json) {
        return User.fromJson(json);
      }).toList();
      return schools;
    }else{
     throw Exception("Une erreur est survenue réessayez plus tard");
    }
  } on SocketException{
    throw Exception("Verifiez votre connexion Internet");
  }
}

Future<dynamic> registerUser(phone,phonewrite) async{
  var data = {
        "phone": phone==''?phonewrite:phone,
        "type": "user", 
        "password": "12345678", 
  };
  try{

    Response response = await locator<Di>().dio.post(
      locator<Di>().apiUrl+"/signup", 
      options: Options(
        headers: {
          'Content-Type': "application/json",
        }
      ),
      data: data
    );

    if(response.statusCode == 200){
      Future<SharedPreferences> instance = SharedPreferences.getInstance();
      SharedPreferenceHelper(instance).storeData("user_info",phone==''?phonewrite:phone);
      return response.data["message"];
    }else{
      return response;
    }
  } on SocketException{
    return null;
  }
}
