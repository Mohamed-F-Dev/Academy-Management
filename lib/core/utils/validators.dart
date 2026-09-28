class Validators {
  Validators._();

  // ===============================
  // Required
  // ===============================
  static String? required(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    return null;
  }

  // ===============================
  // Email
  // ===============================
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }

    return null;
  }

  // ===============================
  // Name
  // ===============================
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم';
    }

    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }

    return null;
  }

  // ===============================
  // Password
  // ===============================
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < minLength) {
      return 'كلمة المرور يجب أن تكون $minLength أحرف على الأقل';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'يجب أن تحتوي كلمة المرور على حرف صغير';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'يجب أن تحتوي كلمة المرور على رقم';
    }

    return null;
  }

  // ===============================
  // Confirm Password
  // ===============================
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }

    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  // ===============================
  // Phone
  // ===============================
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    final phone = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^(01)[0-9]{9}$').hasMatch(phone)) {
      return 'يرجى إدخال رقم هاتف مصري صحيح';
    }

    return null;
  }

  // ===============================
  // Combine Validators
  // ===============================
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);

        if (result != null) {
          return result;
        }
      }

      return null;
    };
  }
}
