//lib/feature/auth/data/datasource/auth_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/network_exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasource/auth_remote_data_source.dart';
import '../model/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, UserProfile>> currentUser() async {
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
            role: UserRole.guest,
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
  Future<Either<Failure, UserProfile>> loginWithEmailPassword({
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
  Future<Either<Failure, UserProfile>> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final userProfile = await remoteDataSource.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      return right(userProfile);
    } on NetworkException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null);
    } on NetworkException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserProfile>> _getUser(
    Future<UserProfile> Function() fn,
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
