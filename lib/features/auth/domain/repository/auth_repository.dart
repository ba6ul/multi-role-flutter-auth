import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_profile.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserProfile>> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Either<Failure, UserProfile>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserProfile>> currentUser();
}
