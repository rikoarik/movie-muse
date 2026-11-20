import 'package:dio/dio.dart';
import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/exceptions.dart';

class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: EnvConfig.omdbBaseUrl,
              connectTimeout: EnvConfig.connectTimeout,
              receiveTimeout: EnvConfig.receiveTimeout,
              headers: const {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _guard(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw const InvalidApiKeyException();
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          (statusCode != null && statusCode >= 500)) {
        throw const NetworkException();
      }
      // Do not echo error.message directly if it contains URL/apikey query params.
      throw ServerException('OMDb request failed.', statusCode: statusCode);
    }
  }
}
