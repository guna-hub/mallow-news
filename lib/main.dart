import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mallow_news/core/network/api_client.dart';
import 'package:mallow_news/core/network/dio_factory.dart';
import 'package:mallow_news/core/theme/app_theme.dart';
import 'package:mallow_news/data/repositories/news_repository_impl.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/screens/news_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env is missing or fails to load, fallback to default ApiConstants.baseUrl
  }

  final dio = DioFactory.createDio();
  final apiClient = ApiClient(dio);
  final newsRepository = NewsRepositoryImpl(apiClient);

  runApp(MyApp(newsRepository: newsRepository));
}

class MyApp extends StatelessWidget {
  final NewsRepository newsRepository;

  const MyApp({super.key, required this.newsRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NewsRepository>.value(value: newsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            create: (context) => NewsBloc(newsRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Mallow News',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const NewsListScreen(),
        ),
      ),
    );
  }
}
