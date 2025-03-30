import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(
      {String baseUrl = 'http://localhost:3001'}) // Ensure correct Mockoon port
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    // Add interceptors
    _dio.interceptors.addAll([
      // Logging interceptor for debugging
      LogInterceptor(
        request: true, // Logs request details
        requestBody: true, // Logs request body
        responseBody: true, // Logs response body
        responseHeader: false, // Skips logging response headers
        error: true, // Logs errors
      ),
      // Custom interceptor for adding headers and handling errors
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add dynamic headers (e.g., Authorization token if available)
          final token =
              _getAuthToken(); // Replace with actual token retrieval logic
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options); // Continue the request
        },
        onResponse: (response, handler) {
          // Handle successful responses
          return handler.next(response); // Continue the response
        },
        onError: (DioException error, handler) {
          // Improved error handling
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
              print('Connection timeout. Please try again later.');
              break;
            case DioExceptionType.sendTimeout:
              print('Send timeout. Please try again.');
              break;
            case DioExceptionType.receiveTimeout:
              print('Receive timeout. Please check your network.');
              break;
            case DioExceptionType.badResponse:
              _handleBadResponse(error);
              break;
            default:
              print('An unexpected error occurred: ${error.message}');
          }
          return handler.next(error); // Continue the error
        },
      ),
    ]);
  }

  Dio get dio => _dio;

  /// Simulated method to retrieve auth token dynamically
  String _getAuthToken() {
    // Replace this with actual token retrieval (e.g., SharedPreferences, Secure Storage)
    return ''; // Return token if available, otherwise return empty string
  }

  /// Handles specific HTTP error codes
  void _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    switch (statusCode) {
      case 400:
        print('Bad request. Please check your input.');
        break;
      case 401:
        print('Unauthorized! Please check your token.');
        break;
      case 403:
        print('Forbidden! You don’t have permission to access this.');
        break;
      case 404:
        print('Not found. The requested resource does not exist.');
        break;
      case 500:
        print('Internal server error. Please try again later.');
        break;
      default:
        print('Unexpected error: ${error.response?.statusMessage}');
    }
  }
}
