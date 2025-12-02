import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';


class UserProfiles {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  UserProfiles({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}