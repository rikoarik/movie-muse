sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ApiConfigurationException extends AppException {
  const ApiConfigurationException([
    super.message = "OMDb API key isn't configured. Pass --dart-define=OMDB_API_KEY=YOUR_KEY.",
  ]);
}

final class InvalidApiKeyException extends AppException {
  const InvalidApiKeyException([
    super.message = 'The configured OMDb API key is invalid.',
  ]);
}

final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Please check your internet connection and try again.',
  ]);
}

final class ParseException extends AppException {
  const ParseException([
    super.message = 'Received an unexpected response from OMDb.',
  ]);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Failed to access local storage.']);
}
