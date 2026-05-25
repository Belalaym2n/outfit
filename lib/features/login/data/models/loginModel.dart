class LoginModel {
  String email;
  String password;
  String? name;

  LoginModel({
    required this.password,
    required this.email,  this. name,
  });

   factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['fullName'] ?? '',
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
