import 'package:dio/dio.dart';
import 'package:mallow_news/core/constants/api_constants.dart';

class DioFactory {
  static Dio createDio() {
    String baseUrl = ApiConstants.baseUrl;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(minutes: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(minutes: ApiConstants.receiveTimeout),
        sendTimeout: const Duration(minutes: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
      ),
    );

    return dio;
  }
}
