import '../../domain/entities/user_profile.dart';
import '../../config/supabase_schema.dart';
import '../../domain/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserProfile {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.username,
    required super.role,
  });

  /// Builds from a Supabase Auth [User] — used right after signup/login,
  /// before a `user_profiles` row necessarily exists. Role/username come
  /// from auth metadata (set once at signup, not kept in sync afterward).
  factory UserModel.fromAuthUser(User authUser) {
    final metadata = authUser.userMetadata ?? {};
    final username = metadata['username'] as String? ?? '';
    return UserModel(
      id: authUser.id,
      email: authUser.email ?? '',
      name: username,
      username: username,
      role:
          UserRoleExtension.fromDbValue(
            metadata[SupabaseSchema.roleColumn] as String?,
          ) ??
          UserRole.guest,
    );
  }

  /// Builds from a `user_profiles` table row — the authoritative source of
  /// profile/role data once ProfileSetupPage has run.
  factory UserModel.fromProfileRow(Map<String, dynamic> map) {
    return UserModel(
      id: map[SupabaseSchema.userIdColumn] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? map['username'] ?? '',
      username: map['username'] ?? '',
      role:
          UserRoleExtension.fromDbValue(
            map[SupabaseSchema.roleColumn] as String?,
          ) ??
          UserRole.guest,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }
}
