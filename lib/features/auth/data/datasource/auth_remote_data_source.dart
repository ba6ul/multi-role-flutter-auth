//lib/feature/auth/data/datasource/auth_remote_source.dart

//import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/features/auth/data/model/user_model.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/usecase/current_user.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/entities/userprofiles.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String role,
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
        throw const ServerException(
          'User is null!',
        );
      }
      return UserModel.fromJson(response.user!.toJson());
    }  on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name, 'role': role},
      );
      if (response.user == null) {
        throw const SupabaseAuthException(
          'Signup failed: Could not create user session.',
        );
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw SupabaseAuthException(e.toString());
    }
  }
  
@override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('user_profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}
