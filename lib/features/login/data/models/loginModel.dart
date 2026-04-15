class LoginModel {
  String email;
  String password;
  String? name;

  LoginModel({
    required this.password,
    required this.email,
  });

   factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'remember': true,
    };
  }
}
