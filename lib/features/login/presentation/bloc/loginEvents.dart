import 'package:equatable/equatable.dart';

 import '../../data/models/loginModel.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final LoginModel model;

  LoginButtonPressed({required this.model,});

  @override
  List<Object?> get props => [model];
}



class ForgetPasswordPressed extends LoginEvent {
  final String email;

  ForgetPasswordPressed(this.email);

  @override
  List<Object?> get props => [email];
}


