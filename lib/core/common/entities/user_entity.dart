import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';


class UserEntity {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}