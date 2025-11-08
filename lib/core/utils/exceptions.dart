import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Custom exception classes for better error handling

class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, {this.prefix});

  @override
  String toString() {
    return prefix != null ? '$prefix: $message' : message;
  }
}

class NetworkException extends AppException {
  NetworkException([String? message])
      : super(message ?? 'No internet connection', prefix: 'Network Error');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message ?? 'Invalid request', prefix: 'Bad Request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message ?? 'Unauthorized access', prefix: 'Unauthorized');
}

class NotFoundException extends AppException {
  NotFoundException([String? message])
      : super(message ?? 'Resource not found', prefix: 'Not Found');
}

class ServerException extends AppException {
  ServerException([String? message])
      : super(message ?? 'Server error occurred', prefix: 'Server Error');
}

class TimeoutException extends AppException {
  TimeoutException([String? message])
      : super(message ?? 'Request timeout', prefix: 'Timeout');
}

class UnknownException extends AppException {
  UnknownException([String? message])
      : super(message ?? 'Unknown error occurred', prefix: 'Unknown Error');
}

/// Exception handler utility
class ExceptionHandler {
  static final _logger = Logger();

  static AppException handleError(dynamic error) {
    _logger.e('Error occurred', error: error);

    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return error;
    } else {
      return UnknownException(error.toString());
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return AppException('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badCertificate:
        return AppException('Bad certificate');

      case DioExceptionType.unknown:
        return NetworkException();
    }
  }

  static AppException _handleResponseError(Response? response) {
    if (response == null) {
      return ServerException();
    }

    final statusCode = response.statusCode ?? 0;
    final message = _extractErrorMessage(response);

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
      case 403:
        return UnauthorizedException(message);
      case 404:
        return NotFoundException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(message);
      default:
        return AppException('Error occurred: $message');
    }
  }

  static String _extractErrorMessage(Response response) {
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 
               data['error'] as String? ?? 
               'Unknown error';
      }
      return response.statusMessage ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
