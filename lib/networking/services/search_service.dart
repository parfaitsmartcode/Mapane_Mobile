import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/di.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/service_locator.dart';
import 'package:mapane/utils/n_exception.dart';

class SearchService {
  Future<List<Place>> searchPlaces(String terms) async {
    try {
      final String uri =
          Uri.encodeFull("https://photon.komoot.io/api/?q=" + terms);
      print(uri);
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {"content-type": "application/json"}),
          );
      print(response.data["features"].length);
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
