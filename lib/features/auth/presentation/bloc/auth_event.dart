part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String role;

  AuthSignup({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  
}
final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}
final class AuthIsUserLoggedIn extends AuthEvent {}