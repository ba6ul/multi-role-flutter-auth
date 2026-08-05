// core/error/network_exceptions.dart
// ----------------------------------
// Generic, backend-agnostic network/server exceptions. Nothing here should
// name a specific provider (Supabase, REST, etc.) - provider-specific error
// handling belongs in that feature's own data layer.

// Base Network Exception
abstract class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

// Generic Network Exceptions
class NoConnectionException extends NetworkException {
  const NoConnectionException() : super('No Internet connection available.');
}

class RequestTimeoutException extends NetworkException {
  const RequestTimeoutException()
    : super('Request timed out. Please try again.');
}

class ServerException extends NetworkException {
  const ServerException([super.message = 'Server responded with an error.']);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException([
    super.message = 'An unknown network error occurred.',
  ]);
}
