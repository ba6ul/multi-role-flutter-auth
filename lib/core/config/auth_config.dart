import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

class AuthConfig {
  // Role Selection Config
  static const bool useRoleSelection = false;
  static const UserRole defaultRole = UserRole.member;

  static const bool showRoleBadgeOnSignup = false;

  // Profile Completion Config
  static const bool useProfileCompletion = true; 

  // Need workspace setup after profile completion
  static const bool allowSkipProfile = true; // Shows/hides the Skip button
}