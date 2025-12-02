
import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/usecase/usecase.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';


class UserSignUp implements UseCase<Userprofiles, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, Userprofiles>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,

    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final String role;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}