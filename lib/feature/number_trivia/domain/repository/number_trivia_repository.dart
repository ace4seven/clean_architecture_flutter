import 'package:clean_architecture_tutorial/core/error/failure.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
