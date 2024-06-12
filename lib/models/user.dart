class User{
  int? id;
  String? username;
  String? name;
  String? email;
  String? image;
  String? token;

  User({
    this.id,
    this.username,
    this.name,
    this.email,
    this.image,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      token: json['token']
    );
  }
}