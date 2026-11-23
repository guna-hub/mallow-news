import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  UrlUtils._();

  /// Opens an external URL safely with fallback modes and user feedback if launch fails.
  static Future<void> launchURL(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final uri = Uri.parse(urlString.trim());

    try {
      // 1. Try launching in external application (e.g. Chrome / default browser)
      bool launched = false;
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        launched = false;
      }

      // 2. If external launch returned false or failed, fallback to platform default / in-app browser
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open article link.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open browser.')),
        );
      }
    }
  }
}
