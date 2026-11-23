class ApiConstants {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';
  static const int connectTimeout = 1;
  static const int receiveTimeout = 1;
  static const int sendTimeout = 1;
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
