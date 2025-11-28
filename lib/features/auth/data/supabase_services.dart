import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/user_role.dart';

/// supabase_services.dart
/// 
/// This service handles all interactions with Supabase Auth and the user_profiles table.
/// Responsibilities include:
/// 
/// - Signing users in and out via email/password
/// - Registering new users
/// - Saving and updating user profiles
/// - Fetching user roles and profile data
/// - Checking whether a user has completed their profile setup
/// - Providing access to the current signed-in user
/// 
/// This file is used throughout the onboarding and login flow,
/// and works together with `auth_service.dart` for role logic,
/// and `user_role.dart` for role mapping.

/// Service to interact with Supabase Auth and user_profiles table
class SupabaseService {
  /// Instance of Supabase client
  static final SupabaseClient _client = Supabase.instance.client;

  /// Getter to expose the Supabase client if needed externally
  static SupabaseClient get client => _client;

  /// Save or update a user profile in the 'user_profiles' table.
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
      await _client
          .from('user_profiles')
          .upsert({
            'user_id': userId,
            'custom_user_id': customUserId,
            'role': role.dbValue,
            'name': name,
            'email': email,
            'profile_completed': true,
            'updated_at': DateTime.now().toIso8601String(),
            if (additionalData != null) ...additionalData,
          });
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  /// Fetch the user's role from the 'user_profiles' table.
  /// Returns a [UserRole] enum, or defaults to `guest` if unmatched.
  static Future<UserRole?> getUserRole(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select('role')
          .eq('user_id', userId)
          .single();
      
      final roleString = response['role'] as String?;
      if (roleString == null) return null;

      return UserRole.values.firstWhere(
        (role) => role.dbValue == roleString,
        orElse: () => UserRole.guest, // default fallback
      );
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  /// Retrieve the full user profile as a map from the 'user_profiles' table.
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();
      return response;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Check if the user has completed their profile setup.
  /// Returns true if 'profile_completed' is true.
  static Future<bool> isProfileCompleted(String userId) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select('profile_completed')
          .eq('user_id', userId)
          .single();
      return response['profile_completed'] ?? false;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }

  /// Get the currently authenticated Supabase user.
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Sign in the user using email and password.
  /// Returns the authenticated [User] on success or null on failure.
  static Future<User?> cEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  /// Sign up a new user using email and password.
  /// Returns the newly created [User] on success or null on failure.
  static Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  /// Sign out the current user.
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get user email.
  String? getUserEmail() {
    final Session = _client.auth.currentSession;
    final User = Session?.user;
    return User?.email;
  }
}
