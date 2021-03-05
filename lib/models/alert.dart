import 'package:flutter/material.dart';
import 'package:mapane/models/category.dart';
import 'package:mapane/models/postedBy.dart';
import 'package:quiver/core.dart';

class Alert{
   String id;
   String lat;
   String lon;
   String desc;
   PostedBy userId;
   Category category;
   bool active;
   String createdAt;
   String address;

  Alert({
    this.id,
    this.lat,
    this.lon,
    this.desc,
    this.userId,
    this.category,
    this.active,
    this.createdAt,
    this.address
});
  @override
  bool operator ==(Object other) => other is Alert && double.parse(other.lat).toStringAsFixed(5) == double.parse(lat).toStringAsFixed(5) && double.parse(other.lon).toStringAsFixed(5) == double.parse(lon).toStringAsFixed(5);

   factory Alert.fromJson(Map<String, dynamic> json) {
     return Alert(
         id: json['_id'],
         lat: json['lat'],
         lon: json['long'],
         desc: json['desc'],
         address: json['address'],
         userId: json['postedBy'] == null ? PostedBy(id:'0',phone:'1234') : PostedBy(id:json['postedBy']['_id'],phone:json['postedBy']['phone']),
         category: Category(id: json['category']['_id'],name: json['category']['name'],perimeter: json['category']['perimeter']),
         active: json['active'],
         createdAt: json['createdAt'],
     );
   }

  @override
  int get hashCode => hash2(lat.hashCode,lon.hashCode);

   static List<Map<String, dynamic>> items = [
     {
       'value': 'embouteillage3',
       'label': 'Embouteillage',
       'icon': SizedBox(
         height: 40,
         width: 40,
         child:Image.asset(
           'assets/images/new-icon-alerts/test/embouteillage.png'
       )),
     },
     {
       'value': 'route-barree2',
       'label': 'Route barrée',
       'icon': SizedBox(
         height: 40,
         width: 40,
         child:Image.asset(
           'assets/images/new-icon-alerts/test/routebarree-copie.png'
       )),
     },
     {
       'value': 'Route-en-chantier-2',
       'label': 'Route en chantier',
       'icon': SizedBox(
         height: 40,
         width: 40,
         child:Image.asset(
           'assets/images/new-icon-alerts/test/chantier-copie.png'
       )),
     },
     {
       'value': 'zone-dangereuse-1',
       'label': 'Zone dangereuse',
       'icon': SizedBox(
         height: 40,
         width: 40,
         child:Image.asset(
           'assets/images/new-icon-alerts/test/zone-dangereuse.png'
       )),
     },
     {
       'value': 'Accident-de-circulation-1',
       'label': 'Accident de circulation',
       'icon': SizedBox(
         height: 40,
         width: 40,
         child:Image.asset(
           'assets/images/new-icon-alerts/test/accident.png'
       )),
     },
   ];

}