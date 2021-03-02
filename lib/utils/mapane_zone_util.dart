import 'dart:math';

import 'package:geodesy/geodesy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:mapane/models/alert.dart';
import 'package:vector_math/vector_math.dart';

List<Alert> nearbyPoints(List<Alert> points, gmap.LatLng position) {
  List<Alert> nearbyPoints = new List<Alert>();

  Geodesy geodesy = Geodesy();

  points.forEach((element) {
    num distance = distanceBetweenTwoGeoPoints(
        position,
        gmap.LatLng(double.parse(element.lat), double.parse(element.lon)));
    print("alerte à " + distance.toString());
    if ( distance/1000 <= element.category.perimeter) {
      nearbyPoints.add(element);
    }
  });
  return nearbyPoints;
}
num distanceBetweenTwoGeoPoints(gmap.LatLng p1,gmap.LatLng p2){

  double lon1 = radians(p1.longitude);
  double lon2 = radians(p2.longitude);
  double lat1 = radians(p1.latitude);
  double lat2 = radians(p2.latitude);
  double dlon = lon2 -lon1;
  double dlat = lat2 - lat1;
  double a = pow(sin(dlat/2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2),2);
  double c = 2 * asin(sqrt(a));
  num r = 3956;
   return c * r * 1000;
}
