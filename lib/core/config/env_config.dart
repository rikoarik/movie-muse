abstract final class EnvConfig {
  static const String appName = 'Movie Muse';
  static const String omdbBaseUrl = 'https://www.omdbapi.com/';
  static const String omdbApiKey = String.fromEnvironment('OMDB_API_KEY');
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration receiveTimeout = Duration(seconds: 12);

  static const String defaultDiscoverQuery = 'Batman';
  static const List<String> discoverQuickQueries = [
    'Batman',
    'Star Wars',
    'Love',
    'Comedy',
  ];
  static const List<String> searchQuickSuggestions = [
    'Interstellar',
    'Batman',
    'Dune',
  ];

  static const Duration searchDebounce = Duration(milliseconds: 450);
  static const int minSearchLength = 2;

  static const String favoritesStorageKey = 'favorite_movies_v1';
}
