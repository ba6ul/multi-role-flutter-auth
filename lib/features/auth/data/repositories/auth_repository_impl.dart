//lib/feature/auth/data/datasource/auth_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/constants/constants.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/error/network_exceptions.dart';
import 'package:multi_role_flutter_auth/core/network/connection_checker.dart';
import 'package:multi_role_flutter_auth/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:multi_role_flutter_auth/features/auth/data/model/user_model.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/entities/userprofiles.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';
//import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, Userprofiles>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
            username: '',
            role: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Userprofiles>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, Userprofiles>> signUpWithEmailPassword({
    //this String name,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final UserProfiles = await remoteDataSource.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      return right(UserProfiles);
    } on NetworkException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Userprofiles>> _getUser(
    Future<Userprofiles> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
