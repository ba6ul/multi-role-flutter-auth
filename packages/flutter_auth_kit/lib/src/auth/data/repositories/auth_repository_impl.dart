//lib/feature/auth/data/datasource/auth_repository_impl.dart

import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_profile.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/network_exceptions.dart';
import '../datasource/auth_remote_data_source.dart';
import '../model/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      // The real request failed (network error, timeout, etc.) - fall back
      // to the cached local session if one exists, rather than assuming
      // logged out. Only reached when a real request actually failed, not
      // based on a separate connectivity probe that can false-positive
      // (report "no internet" when the backend is actually reachable, or
      // vice versa).
      final session = remoteDataSource.currentUserSession;
      if (session != null) {
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

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return right(null);
    } on NetworkException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserProfile>> _getUser(
    Future<UserProfile> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
