class User {
  String name;
  String email;
  String password;

  // Constructor
  User({required this.name, required this.email, required this.password});

  // Constructor fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
