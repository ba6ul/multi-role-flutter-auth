import 'package:flutter/material.dart';

/// user_role.dart
///
/// This file defines the `UserRole` enum, representing the various user types
/// in the app (e.g., Driver, admin, Fleet Manager).
///
/// It also provides helpful extensions:
/// - `displayName`: A user-friendly label for UI
/// - `dbValue`: Maps enum to Supabase-friendly string values
/// - `icon`: Assigns an icon to each role for UI components
/// - `fromDbValue`: Converts Supabase string back to enum
/// - `prefix`: A short custom string used for things like ID tags or role codes
///
/// Used in:
/// - Role selection screens
/// - Profile creation and updates
/// - Dashboard routing (via role check)

enum UserRole { guest, member, lead, admin, superadmin }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.guest:
        return 'guest';
      case UserRole.member:
        return 'member';
      case UserRole.lead:
        return 'lead';
      case UserRole.admin:
        return 'admin';
      case UserRole.superadmin:
        return 'super_admin';
    }
  }

  String get dbValue {
    switch (this) {
      case UserRole.guest:
        return 'guest';
      case UserRole.member:
        return 'member';
      case UserRole.lead:
        return 'lead';
      case UserRole.admin:
        return 'admin';
      case UserRole.superadmin:
        return 'fleet_manager';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.guest:
        return Icons.person;
      case UserRole.member:
        return Icons.groups;
      case UserRole.lead:
        return Icons.local_shipping;
      case UserRole.admin:
        return Icons.shopping_cart;
      case UserRole.superadmin:
        return Icons.manage_accounts;
    }
  }

  // Helper for parsing from string value (db value)
  static UserRole? fromDbValue(String? value) {
    switch (value) {
      case 'driver_individual':
        return UserRole.guest;
      case 'member':
        return UserRole.member;
      case 'lead':
        return UserRole.lead;
      case 'admin':
        return UserRole.admin;
      case 'fleet_manager':
        return UserRole.superadmin;
      default:
        return null;
    }
  }

  /// This will be used for Custom id genration
  String get prefix {
    switch (this) {
      case UserRole.guest:
        return 'G';
      case UserRole.member:
        return 'M';
      case UserRole.lead:
        return 'L';
      case UserRole.admin:
        return 'A';
      case UserRole.superadmin:
        return 'SA';
    }
  }
}
