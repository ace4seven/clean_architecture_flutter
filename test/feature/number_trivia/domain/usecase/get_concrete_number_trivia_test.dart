import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/repository/number_trivia_repository.dart';

void main() {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository);
  });

  const tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia number from the repository', () async {
    // arrange
    when(repository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase(tNumber);
    // assert
    expect(result, Right(tNumberTrivia));
    verify(repository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(repository);
  });
}
