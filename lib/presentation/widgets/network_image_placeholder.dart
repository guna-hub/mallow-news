import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl != null && imageUrl!.trim().isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => Container(
                width: width,
                height: height,
                color: placeholderColor,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => _buildFallback(placeholderColor),
            )
          : _buildFallback(placeholderColor),
    );
  }

  Widget _buildFallback(Color color) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
