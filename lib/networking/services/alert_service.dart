import 'package:dio/dio.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/utils/n_exception.dart';

import '../../di.dart';
import '../../service_locator.dart';

class AlertService{

  Future<List<Alert>> getAlerts() async{

    try{
      final String uri = locator<Di>().apiUrl + "/test";
      Response response = await locator<Di>().dio.get(uri,
        options: Options(
            headers: {
              "content-type":"application/json"
            }
        ),
      );
      return List<Alert>.from(((response.data) as List).map((json){
        return Alert.fromJson(json);
      }));
    } on DioError catch (e){
      throw new NException(e);
    }
}
}
final AlertService alertService = AlertService();