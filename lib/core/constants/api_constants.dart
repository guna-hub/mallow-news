class ApiConstants {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';
  static const int connectTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000; // 15 seconds
  static const int sendTimeout = 15000;    // 15 seconds
  static const int defaultPageSize = 20;

  // Predefined popular news sites for category filtering
  static const List<String> categories = [
    'All',
    'SpaceNews',
    'NASA Spaceflight',
    'Ars Technica',
    'SpacePolicyOnline.com',
    'Teslarati',
  ];
}
