import 'package:dartz/dartz.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/networking/services/search_service.dart';
import 'package:mapane/state/base_provider.dart';
import 'package:mapane/utils/n_exception.dart';

class SearchProvider extends BaseProvider{

  bool isSearchEnable = false;

  Either<NException,List<Place>> placesResult = Right([]);

  toggleSearchState(){
    isSearchEnable ? isSearchEnable = false : isSearchEnable = true;
    notifyListeners();
  }
  getSearchResults(String terms){
    this.toggleLoadingState();
    searchService.searchPlaces(terms).then((places){
      placesResult = Right(places);
    }).catchError((onError){
      placesResult = Left(onError);
      this.toggleLoadingState();
    });
  }
}