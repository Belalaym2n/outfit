class UserModel {
  final String email;
  final String fullName;
  final String token;

  UserModel({
    required this.email,
    required this.fullName,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

// P@ssw0rd123  belalAy@example.com