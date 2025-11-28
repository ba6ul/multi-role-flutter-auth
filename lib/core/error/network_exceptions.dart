// core/error/network_exceptions.dart
// ----------------------------------
// Defines all typed exceptions related to network and backend communication.
//
// Purpose:
// - Provide meaningful, strongly-typed exceptions for API and Supabase errors.
// - Enable consistent error handling across all data sources.
// - Decouple error messages from UI and services.
//
// This file is intentionally backend-agnostic — it supports:
// - REST APIs (e.g., TMDB)
// - Supabase Auth, Database, Storage
// - Any future network provider



// Base Network Exception
abstract class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

// Generic Network Exceptions
class NoConnectionException extends NetworkException {
  const NoConnectionException()
      : super('No Internet connection available.');
}

class RequestTimeoutException extends NetworkException {
  const RequestTimeoutException()
      : super('Request timed out. Please try again.');
}

class ServerException extends NetworkException {
  const ServerException([super.message = 'Server responded with an error.']);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(
    [super.message = 'An unknown network error occurred.']
  );
}

//SUPABASE-SPECIFIC EXCEPTIONS

/// Thrown when a Supabase authentication operation fails.
class SupabaseAuthException extends NetworkException {
  const SupabaseAuthException([
    super.message = 'Supabase authentication failed.',
  ]);
}

/// Thrown when a Supabase database (PostgREST) call fails.
class SupabaseDatabaseException extends NetworkException {
  const SupabaseDatabaseException([
    super.message = 'Supabase database operation failed.',
  ]);
}

/// Thrown when a Supabase Storage operation fails.
class SupabaseStorageException extends NetworkException {
  const SupabaseStorageException([
    super.message = 'Supabase storage operation failed.',
  ]);
}

/// Thrown when any Supabase error does not fit known categories.
class SupabaseUnknownException extends NetworkException {
  const SupabaseUnknownException([
    super.message = 'An unknown Supabase error occurred.',
  ]);
}
