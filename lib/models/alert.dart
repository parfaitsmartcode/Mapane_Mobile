import 'package:mapane/models/category.dart';
import 'package:mapane/models/postedBy.dart';

class Alert{
   String id;
   String lat;
   String lon;
   String desc;
   PostedBy userId;
   Category category;
   String active;
   String createdAt;

  Alert({
    this.id,
    this.lat,
    this.lon,
    this.desc,
    this.userId,
    this.category,
    this.active,
    this.createdAt
});

   factory Alert.fromJson(Map<String, dynamic> json) {
     return Alert(
         id: json['_id'],
         lat: json['lat'],
         lon: json['long'],
         desc: json['desc'],
         userId: json['postedBy'] == null ? PostedBy(id:'0',phone:'1234') : PostedBy(id:json['postedBy']['_id'],phone:json['postedBy']['phone']),
         category: Category(id: json['category']['_id'],name: json['category']['name']),
         active: json['active'],
         createdAt: json['createdAt'],
     );
   }
}