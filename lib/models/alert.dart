class Alert{
   String title;
   String imgUrl;

  Alert({
    this.title,
    this.imgUrl
});

   factory Alert.fromJson(Map<String, dynamic> json) {
     return Alert(
         title: json['title'],
         imgUrl: json['email'],
     );
   }
}