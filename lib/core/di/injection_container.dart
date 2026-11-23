import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/bloc/news_bloc.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> init() async {
  // Auto-register annotated dependencies
  getIt.init();
  if (!getIt.isRegistered<NewsBloc>()) {
    getIt.registerFactory<NewsBloc>(() => NewsBloc());
  }
}
