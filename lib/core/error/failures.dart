import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ApiConfigurationFailure extends Failure {
  const ApiConfigurationFailure([
    super.message = "OMDb API key isn't configured. Pass --dart-define=OMDB_API_KEY=YOUR_KEY.",
  ]);
}

final class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure([
    super.message = 'The configured OMDb API key is invalid.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection and try again.',
  ]);
}

final class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'Received an unexpected response from OMDb.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to read local favorites.']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
