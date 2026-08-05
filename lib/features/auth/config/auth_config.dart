import 'package:flutter_auth_kit/flutter_auth_kit.dart';

class AuthConfig {
  // Role Selection Config
  static const bool useRoleSelection = false;
  static const UserRole defaultRole = UserRole.member;

  static const bool showRoleBadgeOnSignup = false;

  // Profile Completion Config
  static const bool useProfileCompletion = false;

  // Need workspace setup after profile completion
  static const bool allowSkipProfile = true; // Shows/hides the Skip button

  // Social login is not wired up to real providers yet (see GitHub issues
  // #21-#24) - keep hidden until it actually works.
  static const bool showSocialLogin = false;
}
