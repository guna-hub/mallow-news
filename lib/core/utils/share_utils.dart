import 'package:share_plus/share_plus.dart';

class ShareUtils {
  ShareUtils._();

  /// Opens the native system share app chooser sheet.
  static Future<void> shareArticle({
    required String? title,
    required String? url,
  }) async {
    final buffer = StringBuffer();
    if (title != null && title.trim().isNotEmpty) {
      buffer.writeln(title.trim());
      buffer.writeln();
    }
    if (url != null && url.trim().isNotEmpty) {
      buffer.write(url.trim());
    }

    final shareText = buffer.toString().trim();
    if (shareText.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          title: title,
          subject: title,
        ),
      );
    }
  }
}
