import 'package:geodesy/geodesy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:mapane/models/alert.dart';

List<Alert> nearbyPoints(List<Alert> points, gmap.LatLng position) {
  List<Alert> nearbyPoints = new List<Alert>();

  Geodesy geodesy = Geodesy();

  points.forEach((element) {
    num distance = geodesy.distanceBetweenTwoGeoPoints(
        LatLng(position.latitude, position.longitude),
        LatLng(double.parse(element.lat), double.parse(element.lon)));

    if (distance >= element.category.perimeter/1000) {
      nearbyPoints.add(element);
    }
  });
  return nearbyPoints;
}
