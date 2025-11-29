
import 'package:fpdart/fpdart.dart';
import 'package:multi_role_flutter_auth/core/error/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}