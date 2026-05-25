import 'package:mocktail/mocktail.dart';

 import '../mocks/login_mock.dart';


void registerTestFallbacks() {
  registerFallbackValue(
    FakeLoginModel(),
  );
}