class User {
  String id;
  String email;
  String name;

  User({
    this.id,
    this.email,
    this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      name: json['name']
    );
  }
}