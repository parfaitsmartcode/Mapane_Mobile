class PostedBy{
   String id;
   String phone;

  PostedBy({
    this.id,
    this.phone
});

   factory PostedBy.fromJson(Map<String, dynamic> json) {
     return PostedBy(
         id: json['_id'],
         phone: json['phone']
     );
   }
}