//lib/feature/auth/data/datasource/auth_remote_source.dart

//import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/features/auth/data/model/user_model.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/entities/userprofiles.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
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
}
