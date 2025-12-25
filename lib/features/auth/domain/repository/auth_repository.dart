import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Userprofiles>> signUpWithEmailPassword({  
    required String username,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, Userprofiles>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Userprofiles>> currentUser();
}
