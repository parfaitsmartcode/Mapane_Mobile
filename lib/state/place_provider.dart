import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/networking/services/search_service.dart';
import 'package:mapane/state/base_provider.dart';
import 'package:mapane/utils/n_exception.dart';

class PlaceProvider extends BaseProvider {

  Either<NException,Place> userPlace = Right(new Place());

  getPlace(LatLng coord){
    this.toggleLoadingState();
    searchService.geocoding(coord).then((place) {
      userPlace = Right(place);
      this.toggleLoadingState();
    }).catchError((error){
      userPlace = Left(error);
      this.toggleLoadingState();
    });
  }
}