class User {
  int id;
  final String name;
  final String email;
  final String password;

  User({ this.name, this.email, this.password});
  factory User.fromJson(Map<String, dynamic> json) => new User(
      name: json["name"],
      email: json["email"],
      password: json["password"]
    );

    Map<String, dynamic> toJson() => {
      "name": name,
      "email": email,
      "password": password
    };
}