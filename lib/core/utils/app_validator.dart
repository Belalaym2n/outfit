import 'package:easy_localization/easy_localization.dart';
import 'package:graduation_proj/generated/locale_keys.g.dart';

class Validators {
  /// التحقق إن النص مش فاضي
  static String? requiredField(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? LocaleKeys.Validations_Auth_field_required.tr();
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.Validations_Validations_description_min_length.tr();
    }

    if (value.trim().length < 5) {
      return LocaleKeys.Validations_Validations_description_min_length.tr();
    }

    return null;
  }
}
