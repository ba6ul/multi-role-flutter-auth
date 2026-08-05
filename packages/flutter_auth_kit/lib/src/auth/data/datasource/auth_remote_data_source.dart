import '../../config/supabase_schema.dart';
import '../../../core/error/network_exceptions.dart';
import '../model/user_model.dart';
import '../../domain/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
  Future<void> signOut();
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      return _fetchProfile(response.user!);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'username': username, SupabaseSchema.roleColumn: role.dbValue},
      );
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      if (response.session == null) {
        // Email confirmation is required and pending - the account exists
        // but there's no session yet, so this is not actually a successful
        // login. Surface this distinctly instead of faking success.
        throw const ServerException(
          'Account created! Check your email to confirm your account before logging in.',
        );
      }
      // No user_profiles row exists yet at signup time (that's created by
      // ProfileSetupPage) — the role picked just now lives in auth metadata.
      return UserModel.fromAuthUser(response.user!);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final session = currentUserSession;
      if (session == null) {
        return null;
      }
      return await _fetchProfile(session.user);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final userId = currentUserSession?.user.id;
      if (userId == null) {
        throw const ServerException('User is null!');
      }
      // Deleting the auth.users row needs the service role, which the
      // client never has - the Edge Function does that server-side.
      final response = await supabaseClient.functions.invoke(
        SupabaseSchema.deleteAccountFunction,
      );
      if (response.status != 200) {
        throw ServerException(
          'Failed to delete account (${response.status}).',
        );
      }
      // Best-effort: schema.sql's user_profiles.user_id has ON DELETE
      // CASCADE, so this is normally already gone. Only matters for a
      // host project whose schema doesn't cascade - swallow errors since
      // the account itself is already deleted at this point either way.
      try {
        await supabaseClient
            .from(SupabaseSchema.userProfilesTable)
            .delete()
            .eq(SupabaseSchema.userIdColumn, userId);
      } catch (_) {}
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// The authoritative role/profile data lives in [SupabaseSchema.userProfilesTable],
  /// updated by ProfileSetupPage — not in auth metadata, which is only set
  /// once at signup and never updated afterward. Falls back to auth metadata
  /// if no profile row exists yet (e.g. user signed up but skipped/hasn't
  /// reached profile setup).
  Future<UserModel> _fetchProfile(User authUser) async {
    final rows = await supabaseClient
        .from(SupabaseSchema.userProfilesTable)
        .select()
        .eq(SupabaseSchema.userIdColumn, authUser.id);

    if (rows.isEmpty) {
      return UserModel.fromAuthUser(authUser);
    }
    return UserModel.fromProfileRow(rows.first).copyWith(email: authUser.email);
  }
}
