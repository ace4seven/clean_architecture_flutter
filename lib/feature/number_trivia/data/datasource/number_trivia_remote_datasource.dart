import '../../domain/entity/number_trivia.dart';

abstract class NumberTriviaRemoteDatasource {

  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}
