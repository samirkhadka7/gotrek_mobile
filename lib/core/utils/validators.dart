import '../constants/app_constants.dart';

/// Validation utilities for form fields
class Validators {
  Validators._();

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }

    return null;
  }

  /// Validate phone number (Nepal format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces or dashes
    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');

    // Nepal phone number formats: 98XXXXXXXX or 97XXXXXXXX (10 digits)
    // Or with country code: +977-98XXXXXXXX
    final phoneRegex = RegExp(
      r'^(\+977[-\s]?)?[9][78]\d{8}$',
    );

    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid Nepal phone number';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate bio length
  static String? validateBio(String? value) {
    if (value != null && value.length > AppConstants.maxBioLength) {
      return 'Bio must not exceed ${AppConstants.maxBioLength} characters';
    }
    return null;
  }

  /// Validate message length
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Message cannot be empty';
    }

    if (value.length > AppConstants.maxMessageLength) {
      return 'Message must not exceed ${AppConstants.maxMessageLength} characters';
    }

    return null;
  }

  /// Validate group size
  static String? validateGroupSize(String? value) {
    if (value == null || value.isEmpty) {
      return 'Group size is required';
    }

    final size = int.tryParse(value);
    if (size == null) {
      return 'Please enter a valid number';
    }

    if (size < AppConstants.minGroupSize) {
      return 'Group must have at least ${AppConstants.minGroupSize} members';
    }

    if (size > AppConstants.maxGroupSize) {
      return 'Group cannot exceed ${AppConstants.maxGroupSize} members';
    }

    return null;
  }

  /// Validate date is in future
  static String? validateFutureDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    if (date.isBefore(DateTime.now())) {
      return 'Please select a future date';
    }

    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }
}
