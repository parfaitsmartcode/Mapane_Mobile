class Category{
   String id;
   String name;
   num perimeter;

  Category({
    this.id,
    this.name,
    this.perimeter
});

   factory Category.fromJson(Map<String, dynamic> json) {
     return Category(
         id: json['_id'],
         name: json['name'],
         perimeter: json['perimeter']
     );
   }
}