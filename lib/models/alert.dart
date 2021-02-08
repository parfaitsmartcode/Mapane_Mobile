import 'package:Mapane/models/category.dart';
import 'package:Mapane/models/postedBy.dart';

class Alert{
   String id;
   String lat;
   String lon;
   String desc;
   PostedBy userId;
   Category category;
   String active;
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

   factory Alert.fromJson(Map<String, dynamic> json) {
     return Alert(
         id: json['_id'],
         lat: json['lat'],
         lon: json['long'],
         desc: json['desc'],
         address: json['address'],
         userId: json['postedBy'] == null ? PostedBy(id:'0',phone:'1234') : PostedBy(id:json['postedBy']['_id'],phone:json['postedBy']['phone']),
         category: Category(id: json['category']['_id'],name: json['category']['name']),
         active: json['active'],
         createdAt: json['createdAt'],
     );
   }
}