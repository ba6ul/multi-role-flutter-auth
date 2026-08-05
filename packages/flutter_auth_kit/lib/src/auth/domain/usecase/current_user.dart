import 'package:fpdart/fpdart.dart';
import '../entities/user_profile.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class CurrentUser implements UseCase<UserProfile, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
