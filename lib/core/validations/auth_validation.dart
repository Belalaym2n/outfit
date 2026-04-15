import 'package:easy_localization/easy_localization.dart';
import 'package:graduation_proj/generated/locale_keys.g.dart';

class AuthValidator {
  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.com$");
    return regex.hasMatch(email);
  }

  static String? validateEmail(String? value) {
    bool isValidGmail = isValidEmail(value ?? "");

    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.Validations_Auth_field_required.tr();
    }
    if (isValidGmail == false) {
      return LocaleKeys.Validations_Auth_email_invalid.tr();
    }
    return null;
  }



  static String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.Validations_Auth_field_required.tr();
    }
    return null;
  }

  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^(?:\+?\d{1,3})?\d{10,15}$');
    return regex.hasMatch(phone);
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Validations_Auth_field_required.tr();
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters.";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter.";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one digit.";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must contain at least one special character.";
    }

    return null;
  }
  static String? validateConfirmPassword(
      String? value,
      String password,
      ) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Validations_Auth_field_required.tr();
    }

    // if (value.trim() != password.trim()) {
    //   return "Passwords do not match.";
    // }

    return null;
  }}
