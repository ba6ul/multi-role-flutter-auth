part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final UserRole role;

  AuthSignup({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  
}
