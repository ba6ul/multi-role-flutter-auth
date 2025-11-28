//lib/feature/auth/domain/repository/auth_repositry.dart

import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({  
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
