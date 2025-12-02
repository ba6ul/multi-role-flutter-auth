//import 'package:multi_role_flutter_auth/features/auth/domain/entities/userprofiles.dart';

class Userprofiles {
  final String id;
  final String email;
  final String name;
  final String role;

  Userprofiles({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}
/*
enum UserRole { guest, member, lead, admin, superadmin }

extension UserRoleDomainExtension on UserRole {
  // Good: This is business logic (What to show users, how to save to DB)
  String get displayName {
    switch (this) {
      case UserRole.guest: return 'Guest';
      case UserRole.member: return 'Member';
      case UserRole.lead: return 'Team Lead';
      case UserRole.admin: return 'Admin';
      case UserRole.superadmin: return 'Super Admin';
    }
  }

  // Good: This is data logic
  String get dbValue {
    switch (this) {
      case UserRole.guest: return 'guest';
      case UserRole.member: return 'member';
      case UserRole.lead: return 'lead';
      case UserRole.admin: return 'admin';
      case UserRole.superadmin: return 'superadmin';
    }
  }

  // Good: Helper for ID generation
  String get prefix {
    switch (this) {
      case UserRole.guest: return 'G';
      case UserRole.member: return 'M';
      case UserRole.lead: return 'L';
      case UserRole.admin: return 'A';
      case UserRole.superadmin: return 'SA';
    }
  }

  static UserRole fromDbValue(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.dbValue == value,
      orElse: () => UserRole.guest, 
    );
  }
}
*/
