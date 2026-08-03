import 'package:fpdart/fpdart.dart';
import '../entities/user_profile.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';
import '../user_role.dart';

class UserSignUp implements UseCase<UserProfile, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, UserProfile>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      username: params.username,
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String username;
  final UserRole role;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.username,
    required this.role,
  });
}
