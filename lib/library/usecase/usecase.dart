import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class SuspendUseCase<I, O> {
  Future<Either<Failure, O>> call(I input);
}

abstract class SuspendUnitUseCase<O> {
  Future<Either<Failure, O>> call();
}