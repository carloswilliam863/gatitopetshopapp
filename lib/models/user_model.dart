class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  // Factory para criar um UserModel a partir de um JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Método para converter o modelo para JSON (se necessário)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
