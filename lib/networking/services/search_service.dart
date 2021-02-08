import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Mapane/di.dart';
import 'package:Mapane/models/place.dart';
import 'package:Mapane/service_locator.dart';
import 'package:Mapane/utils/n_exception.dart';

class SearchService {
  Future<List<Place>> searchPlaces(String terms) async {
    try {
      final String uri =
          Uri.encodeFull("https://photon.komoot.io/api/?q=" + terms);
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      print(response.data["features"]);
      return List<Place>.from(((response.data["features"]) as List).map((json) {
        return Place.fromJson(json);
      }));
    } on DioError catch (e) {
      throw new NException(e);
    }
  }

  Future<Place> geocoding(LatLng coord) async {
    try {
      final String uri = "https://photon.komoot.io/reverse?lon=" +
          coord.longitude.toString() +
          "&lat=" +
          coord.latitude.toString();
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      List<Place> places = List<Place>.from(((response.data["features"]) as List).map((json) {
        return Place.fromJson(json);
      }));
      return places.first;
    } on DioError catch (e) {
      throw new NException(e);
    }
  }
}

final SearchService searchService = SearchService();
