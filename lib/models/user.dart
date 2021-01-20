class User {
  String id;
  String phone;
  String name;

  User({
    this.id,
    this.phone,
    this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      phone: json['phone'],
      name: json['name']
    );
  }
}