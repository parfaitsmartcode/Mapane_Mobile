class Category{
   String id;
   String name;
   String name_en;
   String slug;
   num perimeter;

  Category({
    this.id,
    this.name,
    this.name_en,
    this.slug,
    this.perimeter
});

   factory Category.fromJson(Map<String, dynamic> json) {
     return Category(
         id: json['_id'],
         name: json['name'],
         name_en: json['name_en'],
         perimeter: json['perimeter'],
         slug: json['slug']
     );
   }
}