import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Recent';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (_) {
      return 'Recent';
    }
  }

  static String timeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Recently';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return 'Recently';
    }
  }
}
