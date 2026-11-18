
import 'package:dio/dio.dart';

enum ApiErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  noInternet,
  badResponse,
  cancelled,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorType type;

  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
  });

  factory ApiException.fromDioException(
      DioException error,
      ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          message: 'Connection timed out.',
          type: ApiErrorType.connectionTimeout,
        );

      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Request sending timed out.',
          type: ApiErrorType.sendTimeout,
        );

      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Server response timed out.',
          type: ApiErrorType.receiveTimeout,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Please check your internet connection.',
          type: ApiErrorType.noInternet,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        return ApiException(
          message: 'Server error occurred. Please try again.',
          statusCode: statusCode,
          type: ApiErrorType.badResponse,
        );

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          type: ApiErrorType.cancelled,
        );

      default:
        return const ApiException(
          message: 'Something went wrong.',
          type: ApiErrorType.unknown,
        );
    }
  }

  @override
  String toString() => message;
}
