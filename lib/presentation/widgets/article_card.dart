import 'package:material_ui/material_ui.dart';
import 'package:mallow_news/core/utils/date_formatter.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/presentation/widgets/network_image_placeholder.dart';

class ArticleCard extends StatelessWidget {
  final ResultsResponse article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authorName = (article.authors != null && article.authors!.isNotEmpty && article.authors!.first?.name != null)
        ? article.authors!.first!.name!
        : (article.newsSite ?? 'News');

    final formattedDate = DateFormatter.formatDate(article.publishedAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Hero(
              tag: 'article-image-${article.id}',
              child: CustomNetworkImage(
                imageUrl: article.imageUrl,
                width: 100,
                height: 100,
                borderRadius: 16,
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // News site / category tag
                    Text(
                      article.newsSite ?? 'Space News',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Title
                    Text(
                      article.title ?? 'No title available',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Author & Date row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 9,
                          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 11,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            authorName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '•',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
