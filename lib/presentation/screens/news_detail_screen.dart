import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallow_news/core/utils/date_formatter.dart';
import 'package:mallow_news/core/utils/share_utils.dart';
import 'package:mallow_news/core/utils/url_utils.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/widgets/network_image_placeholder.dart';
import 'package:material_ui/material_ui.dart';

class NewsDetailScreen extends StatelessWidget {
  final int initialIndex;
  final PageController pageController;

  NewsDetailScreen({
    super.key,
    required this.initialIndex,
    PageController? pageController,
  }) : pageController = pageController ?? PageController(initialPage: initialIndex);

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
            controller: pageController,
            itemCount: articles.length,
            onPageChanged: (index) {
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
    final sheetBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final newsSite = article.newsSite ?? 'Space News';
    final formattedTime = DateFormatter.timeAgo(article.publishedAt);

    return Stack(
      children: [
        // 1. Scrollable body with Image + Curved Sheet
        Positioned.fill(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Image Header with overlay text and top curve
                Stack(
                  children: [
                    // Full Hero Image
                    SizedBox(
                      height: size.height * 0.52,
                      width: double.infinity,
                      child: Hero(
                        tag: 'article-image-${article.id}',
                        child: CustomNetworkImage(
                          imageUrl: article.imageUrl,
                          borderRadius: 0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // High-contrast gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                              Colors.black.withValues(alpha: 0.95),
                            ],
                            stops: const [0.0, 0.25, 0.6, 0.95],
                          ),
                        ),
                      ),
                    ),
                    // Category badge, headline, and "Trending • 6 hours ago"
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 46,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              newsSite,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            article.title ?? 'No title available',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Trending',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                ' • ',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Prominently curved top of the content sheet (Image shows behind the rounded corners!)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: sheetBgColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Remaining body of the content sheet
                Container(
                  color: sheetBgColor,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Publisher row with verified badge
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFCC0000),
                            child: Text(
                              newsSite.isNotEmpty ? newsSite[0].toUpperCase() : 'N',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              newsSite,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF1D9BF0),
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Paragraphs of body content
                      ..._buildParagraphs(article.summary, isDark),
                      const SizedBox(height: 28),
                      // "Read full article" action button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => UrlUtils.launchURL(context, article.url),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // 2. Top floating action buttons (Back on left, Share on right)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.chevron_left,
                    iconSize: 26,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _buildCircleButton(
                    icon: Icons.share_outlined,
                    iconSize: 20,
                    onPressed: () => ShareUtils.shareArticle(
                      title: article.title,
                      url: article.url,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    double iconSize = 20,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: iconSize),
        onPressed: onPressed,
      ),
    );
  }

  List<Widget> _buildParagraphs(String? summary, bool isDark) {
    if (summary == null || summary.trim().isEmpty) {
      return [
        Text(
          'No article summary available.',
          style: TextStyle(
            fontSize: 15.5,
            height: 1.68,
            color: isDark ? Colors.grey[400] : const Color(0xFF4A4A4A),
          ),
        ),
      ];
    }

    final paragraphs = summary.split('\n\n').where((p) => p.trim().isNotEmpty).toList();

    return paragraphs.map((para) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          para.trim(),
          style: TextStyle(
            fontSize: 15.5,
            height: 1.68,
            letterSpacing: 0.1,
            color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF2D3748),
          ),
        ),
      );
    }).toList();
  }
}
