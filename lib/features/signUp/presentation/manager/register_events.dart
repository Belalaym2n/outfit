import '../../data/models/regester_model.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final RegisterModel model;

  const RegisterButtonPressed(this.model);
}