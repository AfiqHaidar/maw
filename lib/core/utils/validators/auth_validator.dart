class AuthValidator {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }

    final nameRegex = RegExp(r"^[a-zA-Z\s'-]{2,50}$");

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, apostrophes, and dashes.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$",
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }

    final emailParts = value.split('@');
    final localPart = emailParts[0];
    final domainPart = emailParts[1];

    if (localPart.length > 64 || domainPart.length > 255) {
      return 'Please enter a valid email address.';
    }

    if (!domainPart.contains('.') ||
        domainPart.startsWith('-') ||
        domainPart.endsWith('-')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  static String? validateConfirmedPassword(
      String? value, String? enteredPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != enteredPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
