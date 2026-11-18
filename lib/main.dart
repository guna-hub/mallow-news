import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mallow_news/core/di/injection_container.dart';
import 'package:mallow_news/core/theme/app_theme.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/screens/news_list_screen.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env is missing or fails to load, fallback to default ApiConstants.baseUrl
  }

  // Initialize dependencies via GetIt + Injectable
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NewsRepository>.value(value: sl<NewsRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            create: (context) => sl<NewsBloc>(),
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
