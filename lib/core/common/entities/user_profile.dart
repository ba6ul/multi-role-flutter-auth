import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String username;
  final UserRole role;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.role,
  });
}
