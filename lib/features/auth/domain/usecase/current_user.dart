import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';
import 'package:multi_role_flutter_auth/core/usecase/usecase.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<Userprofiles, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, Userprofiles>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}