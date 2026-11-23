import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallow_news/core/di/injection_container.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/screens/news_detail_screen.dart';
import 'package:mallow_news/presentation/widgets/article_card.dart';
import 'package:mallow_news/presentation/widgets/category_filter_chips.dart';
import 'package:mallow_news/presentation/widgets/empty_state_widget.dart';
import 'package:mallow_news/presentation/widgets/error_retry_widget.dart';
import 'package:mallow_news/presentation/widgets/search_bar_widget.dart';
import 'package:mallow_news/presentation/widgets/shimmer_loader.dart';
import 'package:material_ui/material_ui.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewsBloc>()..add(const FetchInitialNews()),
      child: const NewsListView(),
    );
  }
}

class NewsListView extends StatelessWidget {
  const NewsListView({super.key});

  void _navigateToDetail(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<NewsBloc>(), child: NewsDetailScreen(initialIndex: index),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {},
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Header
                Text(
                  'Discover',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'News from all around the world',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 16),
                // Search Bar
                SearchBarWidget(
                  onSearchChanged: (query) {
                    context.read<NewsBloc>().add(SearchQueryChanged(query));
                  },
                ),
                const SizedBox(height: 14),
                // Categories Filter Chips
                BlocBuilder<NewsBloc, NewsState>(
                  buildWhen: (prev, curr) => prev.selectedCategory != curr.selectedCategory,
                  builder: (context, state) {
                    return CategoryFilterChips(
                      selectedCategory: state.selectedCategory,
                      onSelected: (cat) {
                        context.read<NewsBloc>().add(CategorySelected(cat));
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Articles List / Grid
                Expanded(
                  child: BlocBuilder<NewsBloc, NewsState>(
                    builder: (context, state) {
                      if (state.status == NewsStatus.loading) {
                        return const ShimmerArticleLoader();
                      }

                      if (state.status == NewsStatus.failure && state.articles.isEmpty) {
                        return ErrorRetryWidget(
                          errorMessage: state.errorMessage ?? 'Failed to load news.',
                          onRetry: () {
                            context.read<NewsBloc>().add(const FetchInitialNews());
                          },
                        );
                      }

                      if (state.status == NewsStatus.success && state.articles.isEmpty) {
                        return EmptyStateWidget(
                          title: state.searchQuery.isNotEmpty
                              ? 'No results for "${state.searchQuery}"'
                              : 'No News Available',
                          message: 'Check your search terms or try another category.',
                          onRetry: () {
                            context.read<NewsBloc>().add(const RefreshNews());
                          },
                        );
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >= (scrollInfo.metrics.maxScrollExtent - 200)) {
                            context.read<NewsBloc>().add(const LoadMoreNews());
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<NewsBloc>().add(const RefreshNews());
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isTablet = constraints.maxWidth >= 600;

                              if (isTablet) {
                                return _buildTabletGrid(context, state);
                              } else {
                                return _buildMobileList(context, state);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, NewsState state) {
    final itemCount = state.articles.length + (state.hasReachedMax ? 0 : 1);

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 4, endIndent: 4),
      itemBuilder: (context, index) {
        if (index >= state.articles.length) {
          return _buildPaginationFooter(context, state);
        }

        final article = state.articles[index];
        return ArticleCard(
          article: article,
          onTap: () => _navigateToDetail(context, index),
        );
      },
    );
  }

  Widget _buildTabletGrid(BuildContext context, NewsState state) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final article = state.articles[index];
              return ArticleCard(
                article: article,
                onTap: () => _navigateToDetail(context, index),
              );
            },
            childCount: state.articles.length,
          ),
        ),
        if (!state.hasReachedMax)
          SliverToBoxAdapter(
            child: _buildPaginationFooter(context, state),
          ),
      ],
    );
  }

  Widget _buildPaginationFooter(BuildContext context, NewsState state) {
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Text(
              state.loadMoreError!,
              style: const TextStyle(fontSize: 13, color: Colors.redAccent),
            ),
            TextButton.icon(
              onPressed: () {
                context.read<NewsBloc>().add(const LoadMoreNews());
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Tap to retry'),
            ),
          ],
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }
}
