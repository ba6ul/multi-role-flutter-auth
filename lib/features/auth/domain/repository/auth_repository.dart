import 'package:fpdart/fpdart.dart';
import '../entities/user_profile.dart';
import '../../../../core/error/failure.dart';
import '../user_role.dart';

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

  Future<Either<Failure, void>> signOut();
}
