import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/usecase/usecase.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';

class UserSignOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  UserSignOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
