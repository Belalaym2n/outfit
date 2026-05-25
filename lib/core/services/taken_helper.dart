import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokenHelper {
  /// Decode JWT safely
  static JWT? decode(String token) {
    try {
      return JWT.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Check if token expired
  static bool isExpired(String token) {
    final jwt = decode(token);

    if (jwt == null) return true;

    final exp = jwt.payload['exp'];

    if (exp == null) return true;

    final expiryDate =
    DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    return DateTime.now().isAfter(expiryDate);
  }

  /// Optional: get expiry date
  static DateTime? getExpiryDate(String token) {
    final jwt = decode(token);

    if (jwt == null) return null;

    final exp = jwt.payload['exp'];

    if (exp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
}
