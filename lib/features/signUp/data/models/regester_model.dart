
class RegisterModel {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isAgree;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isAgree,
  });

  Map<String, dynamic> toJson() => {
    'fullName':        fullName,
    'email':           email,
    'password':        password,
    'confirmPassword': confirmPassword,
    'isAgree':         isAgree,
  };
}