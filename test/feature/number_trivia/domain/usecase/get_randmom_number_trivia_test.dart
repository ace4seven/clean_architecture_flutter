import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late GetRandomNumberTrivia usecase;
  late NumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from random number from the repository', () async {
    // arrange
    when(repository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase();
    // assert
    expect(result, Right(tNumberTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
