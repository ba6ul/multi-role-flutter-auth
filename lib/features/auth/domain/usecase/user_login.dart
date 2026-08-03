import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_profile.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/usecase/usecase.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<UserProfile, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, UserProfile>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}