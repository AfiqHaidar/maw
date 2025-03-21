class AuthValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tolong masukkan alamat email';
    }

    final emailRegex = RegExp(
        r"^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$");

    if (!emailRegex.hasMatch(value)) {
      return 'Tolong masukkan alamat email yang valid';
    }

    final emailParts = value.split('@');
    final localPart = emailParts[0];
    final domainPart = emailParts[1];

    if (localPart.length > 64 || domainPart.length > 255) {
      return 'Tolong masukkan alamat email yang valid';
    }

    if (!domainPart.contains('.') ||
        domainPart.startsWith('-') ||
        domainPart.endsWith('-')) {
      return 'Tolong masukkan alamat email yang valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().length < 6) {
      return 'Password harus terdiri dari minimal 6 karakter';
    }
    return null;
  }
}
