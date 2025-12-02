//lib/feature/auth/data/datasource/auth_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/features/auth/data/datasource/auth_remote_data_source.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/entities/userprofiles.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, Userprofiles>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Userprofiles>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final UserProfiles = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      return right(UserProfiles);
    } on NetworkException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Userprofiles>> currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }
}
