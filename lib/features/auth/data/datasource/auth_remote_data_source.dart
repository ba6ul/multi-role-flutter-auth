//lib/feature/auth/data/datasource/auth_remote_source.dart

import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name, 'UserRole': role},
      );
if (response.user == null)
{
throw const SupabaseAuthException('Signup failed: Could not create user session.');
}
      return response.user!.id;
    } catch (e) {

      throw SupabaseAuthException(e.toString());
    }
    
  }
}
