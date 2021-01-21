class Category{
   String id;
   String name;

  Category({
    this.id,
    this.name
});

   factory Category.fromJson(Map<String, dynamic> json) {
     return Category(
         id: json['_id'],
         name: json['name']
     );
   }
}