/// Base exception class for all exceptions in the app
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

// =============================================================================
// SERVER EXCEPTIONS
// =============================================================================

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalException,
  });
}

/// Exception thrown when there's no internet connection
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.originalException,
  });
}

/// Exception thrown when connection times out
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Connection timed out',
    super.originalException,
  });
}

// =============================================================================
// AUTH EXCEPTIONS
// =============================================================================

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.originalException,
  });
}

/// Exception thrown when user is not authenticated
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.originalException,
  });
}

/// Exception thrown when user doesn't have permission
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden',
    super.statusCode = 403,
    super.originalException,
  });
}

// =============================================================================
// CACHE EXCEPTIONS
// =============================================================================

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.originalException,
  });
}

/// Exception thrown when data is not found in cache
class CacheNotFoundException extends AppException {
  const CacheNotFoundException({
    super.message = 'Data not found in cache',
    super.originalException,
  });
}

/// Exception thrown when secure storage operation fails
class SecureStorageException extends AppException {
  const SecureStorageException({
    super.message = 'Secure storage operation failed',
    super.originalException,
  });
}

// =============================================================================
// VALIDATION EXCEPTIONS
// =============================================================================

/// Exception thrown when validation fails
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.originalException,
  });
}

// =============================================================================
// BUSINESS LOGIC EXCEPTIONS
// =============================================================================

/// Exception thrown when resource is not found
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.originalException,
  });
}

/// Exception thrown when resource already exists
class DuplicateException extends AppException {
  const DuplicateException({
    required super.message,
    super.statusCode = 409,
    super.originalException,
  });
}

/// Exception thrown for business logic errors
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.statusCode,
    super.originalException,
  });
}

// =============================================================================
// FILE EXCEPTIONS
// =============================================================================

/// Exception thrown when file operation fails
class FileException extends AppException {
  const FileException({
    required super.message,
    super.originalException,
  });
}

/// Exception thrown when file is too large
class FileTooLargeException extends AppException {
  const FileTooLargeException({
    super.message = 'File size exceeds maximum limit',
    super.originalException,
  });
}

/// Exception thrown when file type is invalid
class InvalidFileTypeException extends AppException {
  const InvalidFileTypeException({
    super.message = 'Invalid file type',
    super.originalException,
  });
}

// =============================================================================
// PARSE EXCEPTIONS
// =============================================================================

/// Exception thrown when parsing fails
class ParseException extends AppException {
  const ParseException({
    super.message = 'Failed to parse data',
    super.originalException,
  });
}
