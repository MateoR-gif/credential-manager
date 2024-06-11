class MyUser {
  String id;
  String name;
  String email;
  String password;

  // Constructor
  MyUser({required this.id, required this.name, required this.email, required this.password});

  // Constructor fromJson
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
