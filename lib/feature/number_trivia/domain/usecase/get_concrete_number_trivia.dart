import 'package:clean_architecture_tutorial/core/core/usecase.dart';
import 'package:clean_architecture_tutorial/core/error/failure.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia implements SuspendUseCase<int, NumberTrivia> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(input) async {
    return await repository.getConcreteNumberTrivia(input);
  }
}
