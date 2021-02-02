import 'package:dio/dio.dart';
import 'package:mapane/di.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/service_locator.dart';
import 'package:mapane/utils/n_exception.dart';

class SearchService{

  Future<List<Place>> searchPlaces(String terms) async{
    try{
      final String uri = Uri.encodeFull("https://photon.komoot.io/api/?q=" + terms);
      Response response = await locator<Di>().dio.get(uri,
        options: Options(
            headers: {
              "content-type":"application/json"
            }
        ),);
      print(response.data["features"]);
      return List<Place>.from(((response.data["features"]) as List).map((json){
        return Place.fromJson(json);
      }));
    } on DioError catch(e){
      throw new NException(e);
    }
  }
}
final SearchService searchService = SearchService();