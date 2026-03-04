import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'network_info.dart';

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? pagination;
  final int statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic)? fromJsonT,
    int statusCode,
  ) {
    return ApiResponse(
      success: json['success'] ?? (statusCode >= 200 && statusCode < 300),
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      pagination: json['pagination'] as Map<String, dynamic>?,
      statusCode: statusCode,
    );
  }
}

/// Dio API Client with interceptors
class ApiClient {
  late final Dio _dio;
  final NetworkInfo? networkInfo;
  String? _authToken;

  ApiClient({this.networkInfo}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 - Token expired
          if (error.response?.statusCode == 401) {
            // Could implement token refresh here
            // For now, just pass the error
          }
          handler.next(error);
        },
      ),
    );

    // Retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Retry on timeout or network errors (max 3 times)
          if (_shouldRetry(error) && (error.requestOptions.extra['retryCount'] ?? 0) < 3) {
            error.requestOptions.extra['retryCount'] =
                (error.requestOptions.extra['retryCount'] ?? 0) + 1;

            await Future.delayed(
              Duration(seconds: error.requestOptions.extra['retryCount']),
            );

            try {
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              handler.next(error);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );

    // Logger interceptor (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  /// Set the authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Clear the authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// Check network connectivity before making request
  Future<void> _checkConnectivity() async {
    if (networkInfo != null && !await networkInfo!.isConnected) {
      throw const NetworkException();
    }
  }

  /// Handle Dio errors and convert to app exceptions
  Never _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(originalException: error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Server error';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        }

        switch (statusCode) {
          case 400:
            throw ValidationException(message: message, originalException: error);
          case 401:
            throw UnauthorizedException(message: message, originalException: error);
          case 403:
            throw ForbiddenException(message: message, originalException: error);
          case 404:
            throw NotFoundException(message: message, originalException: error);
          case 409:
            throw DuplicateException(message: message, originalException: error);
          default:
            throw ServerException(
              message: message,
              statusCode: statusCode,
              originalException: error,
            );
        }

      case DioExceptionType.cancel:
        throw const ServerException(message: 'Request was cancelled');

      case DioExceptionType.connectionError:
        throw NetworkException(originalException: error);

      case DioExceptionType.badCertificate:
        throw const ServerException(message: 'Certificate verification failed');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw NetworkException(originalException: error);
        }
        throw ServerException(
          message: error.message ?? 'Unknown error occurred',
          originalException: error,
        );
    }
  }

  // ===========================================================================
  // HTTP METHODS
  // ===========================================================================

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// Upload file with multipart/form-data
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalFields,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalFields,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// Upload multiple files
  Future<Response<T>> uploadFiles<T>(
    String path, {
    required List<String> filePaths,
    required String fieldName,
    Map<String, dynamic>? additionalFields,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      final files = await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      );

      final formData = FormData.fromMap({
        fieldName: files,
        ...?additionalFields,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }
}
