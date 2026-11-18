import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallow_news/core/utils/date_formatter.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/bloc/news_event.dart';
import 'package:mallow_news/presentation/bloc/news_state.dart';
import 'package:mallow_news/presentation/widgets/network_image_placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final int initialIndex;

  const NewsDetailScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open article link.')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open browser.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final articles = state.articles;

        if (articles.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('No article data available.')),
          );
        }

        return Scaffold(
          body: PageView.builder(
            controller: _pageController,
            itemCount: articles.length,
            onPageChanged: (index) {
              // When user swipes near the end of loaded articles, fetch the next page!
              if (index >= articles.length - 2 && !state.hasReachedMax && !state.isLoadingMore) {
                context.read<NewsBloc>().add(const LoadMoreNews());
              }
            },
            itemBuilder: (context, index) {
              final article = articles[index];
              return _buildArticleDetail(context, article);
            },
          ),
        );
      },
    );
  }

  Widget _buildArticleDetail(BuildContext context, ResultsResponse article) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final newsSite = article.newsSite ?? 'Space News';
    final formattedTime = DateFormatter.timeAgo(article.publishedAt);

    return CustomScrollView(
      slivers: [
        // Hero Image Header with overlapping actions
        SliverAppBar(
          expandedHeight: size.height * 0.42,
          pinned: true,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article bookmarked')),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                onPressed: () => _launchUrl(article.url),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'article-image-${article.id}',
                  child: CustomNetworkImage(
                    imageUrl: article.imageUrl,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay for text legibility
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Floating category chip, title and trending text over image
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          newsSite,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title ?? 'No title',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Trending',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            ' • ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content body
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // News site row with verified badge
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFEFF6FF),
                      child: Text(
                        newsSite.isNotEmpty ? newsSite[0].toUpperCase() : 'N',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  newsSite,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.verified,
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ],
                          ),
                          Text(
                            DateFormatter.formatDate(article.publishedAt),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                // Full Summary text
                Text(
                  article.summary ?? 'No summary available for this article.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.65,
                    color: isDark ? Colors.grey[300] : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 36),
                // "Read full article" button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _launchUrl(article.url),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Read full article',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.open_in_new, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
