class AuthValidator {
  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$");
    return regex.hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email address is required.";
    }

    if (!isValidEmail(value)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  static String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required.";
    }
    return null;
  }

  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^(?:\+?\d{1,3})?\d{10,15}$');
    return regex.hasMatch(phone);
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required.";
    }

    if (!isValidPhone(value)) {
      return "Please enter a valid phone number.";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters long.";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must include at least one uppercase letter.";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must include at least one lowercase letter.";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must include at least one number.";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must include at least one special character.";
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? value,
      String password,
      ) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password.";
    }

    if (value.trim() != password.trim()) {
      return "Passwords do not match.";
    }

    return null;
  }
}