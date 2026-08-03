import 'package:multi_role_flutter_auth/core/config/supabase_schema.dart';
import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/features/auth/data/model/user_model.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
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
