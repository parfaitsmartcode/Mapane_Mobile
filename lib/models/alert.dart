class Alert{
   String id;
   String lat;
   String lon;
   String desc;
   final userId;
   final category;
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
         userId: json['postedBy'],
         category: json['category'],
         active: json['active'],
         createdAt: json['createdAt'],
     );
   }
}