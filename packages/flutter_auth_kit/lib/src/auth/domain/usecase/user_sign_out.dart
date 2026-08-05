import 'package:fpdart/fpdart.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class UserSignOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  UserSignOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
