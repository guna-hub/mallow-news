// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories/news_repository_impl.dart' as _i213;
import '../../domain/repositories/news_repository.dart' as _i88;
import '../../domain/usecases/get_article_by_id_usecase.dart' as _i236;
import '../../domain/usecases/get_articles_usecase.dart' as _i165;
import '../network/api_client.dart' as _i557;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i557.ApiClient>(() => registerModule.apiClient);
    gh.lazySingleton<_i88.NewsRepository>(
      () => _i213.NewsRepositoryImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i236.GetArticleByIdUseCase>(
      () => _i236.GetArticleByIdUseCase(gh<_i88.NewsRepository>()),
    );
    gh.lazySingleton<_i165.GetArticlesUseCase>(
      () => _i165.GetArticlesUseCase(gh<_i88.NewsRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
