import 'package:equatable/equatable.dart';

/// Base Failure class for all failures in the app
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

// =============================================================================
// NETWORK FAILURES
// =============================================================================

/// Server returned an error response
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// No internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.originalError,
  });
}

/// Connection timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Connection timed out. Please try again.',
    super.originalError,
  });
}

/// SSL/Certificate error
class CertificateFailure extends Failure {
  const CertificateFailure({
    super.message = 'Certificate verification failed.',
    super.originalError,
  });
}

// =============================================================================
// AUTH FAILURES
// =============================================================================

/// Authentication failed (wrong credentials, etc.)
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// User not authenticated (token expired, not logged in)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
    super.originalError,
  });
}

/// User doesn't have permission
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'You don\'t have permission to perform this action.',
    super.statusCode = 403,
    super.originalError,
  });
}

// =============================================================================
// LOCAL STORAGE FAILURES
// =============================================================================

/// Local database operation failed
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.originalError,
  });
}

/// Secure storage operation failed
class SecureStorageFailure extends Failure {
  const SecureStorageFailure({
    super.message = 'Failed to access secure storage.',
    super.originalError,
  });
}

// =============================================================================
// VALIDATION FAILURES
// =============================================================================

/// Input validation failed
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.originalError,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

// =============================================================================
// BUSINESS LOGIC FAILURES
// =============================================================================

/// Resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
    super.originalError,
  });
}

/// Duplicate resource
class DuplicateFailure extends Failure {
  const DuplicateFailure({
    required super.message,
    super.statusCode = 409,
    super.originalError,
  });
}

/// Generic business logic failure
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

// =============================================================================
// FILE FAILURES
// =============================================================================

/// File operation failed
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
    super.originalError,
  });
}

/// File too large
class FileTooLargeFailure extends Failure {
  const FileTooLargeFailure({
    super.message = 'File size exceeds the maximum allowed limit.',
    super.originalError,
  });
}

/// Invalid file type
class InvalidFileTypeFailure extends Failure {
  const InvalidFileTypeFailure({
    super.message = 'Invalid file type. Please select a valid file.',
    super.originalError,
  });
}

// =============================================================================
// UNKNOWN/UNEXPECTED FAILURES
// =============================================================================

/// Unknown error occurred
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.originalError,
  });
}

/// Parsing error
class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to parse the response.',
    super.originalError,
  });
}
