import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mallow_news/core/network/api_client.dart';
import 'package:mallow_news/core/network/dio_factory.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioFactory.createDio();

  @lazySingleton
  ApiClient get apiClient => ApiClient(dio);
}
