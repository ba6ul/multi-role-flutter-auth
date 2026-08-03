import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multi_role_flutter_auth/core/config/supabase_schema.dart';
import '../domain/user_role.dart';

/// supabase_services.dart
///
/// Raw data-access helpers for the `user_profiles` table plus a couple of
/// Supabase Auth convenience getters. Sign-in/sign-up themselves go through
/// AuthBloc -> AuthRepository -> AuthRemoteDataSource, not this file.

/// Service to interact with Supabase Auth and the user_profiles table
class SupabaseService {
  /// Instance of Supabase client
  static final SupabaseClient _client = Supabase.instance.client;

  /// Getter to expose the Supabase client if needed externally
  static SupabaseClient get client => _client;

  /// Save or update a user profile in the user_profiles table.
  /// This is typically called after registration or during profile setup.
  static Future<bool> saveUserProfile({
    required String customUserId,
    required String userId,
    required UserRole role,
    required String name,
    String? email,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _client.from(SupabaseSchema.userProfilesTable).upsert({
        SupabaseSchema.userIdColumn: userId,
        SupabaseSchema.customUserIdColumn: customUserId,
        SupabaseSchema.roleColumn: role.dbValue,
        'name': name,
        'email': email,
        SupabaseSchema.profileCompletedColumn: true,
        'updated_at': DateTime.now().toIso8601String(),
        if (additionalData != null) ...additionalData,
      });
      return true;
    } catch (e) {
      debugPrint('Error saving user profile: $e');
      return false;
    }
  }

  /// Fetch the user's role from the user_profiles table.
  /// Returns a [UserRole] enum, or defaults to `guest` if unmatched.
  static Future<UserRole?> getUserRole(String userId) async {
    try {
      final response = await _client
          .from(SupabaseSchema.userProfilesTable)
          .select(SupabaseSchema.roleColumn)
          .eq(SupabaseSchema.userIdColumn, userId)
          .single();

      final roleString = response[SupabaseSchema.roleColumn] as String?;
      if (roleString == null) return null;

      return UserRoleExtension.fromDbValue(roleString);
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }

  /// Retrieve the full user profile as a map from the user_profiles table.
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from(SupabaseSchema.userProfilesTable)
          .select()
          .eq(SupabaseSchema.userIdColumn, userId)
          .single();
      return response;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Check if the user has completed their profile setup.
  static Future<bool> isProfileCompleted(String userId) async {
    try {
      final response = await _client
          .from(SupabaseSchema.userProfilesTable)
          .select(SupabaseSchema.profileCompletedColumn)
          .eq(SupabaseSchema.userIdColumn, userId)
          .single();
      return response[SupabaseSchema.profileCompletedColumn] ?? false;
    } catch (e) {
      debugPrint('Error checking profile completion: $e');
      return false;
    }
  }

  /// Get the currently authenticated Supabase user.
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Sign out the current user.
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get the currently authenticated user's email, if any.
  static String? getUserEmail() {
    return _client.auth.currentSession?.user.email;
  }
}
