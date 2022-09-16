import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tutorial/library/error/failure.dart';
import 'package:clean_architecture_tutorial/library/util/input_converter.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, InputConverter])
@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
void main() {
  late MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  late MockGetRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: getConcreteNumberTrivia,
      getRandomNumberTrivia: getRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () async {
    // assert
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcrete Number', () {
    const tNumberString = "1";
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(const Right(tNumberParsed));

    test('should call the InputConverter to validate and convert the string to and unsigned integer', () async* {
      // arange
      setUpMockInputConverterSuccess();
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invlaid', () async* {
      // arange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      expectLater(bloc.state, emitsInOrder([expected]));
    });

    test('should get data from the concrete use case', () async {
      // arange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
      .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(getConcreteNumberTrivia(any));
      // assert
      verify(getConcreteNumberTrivia(tNumberParsed));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
    
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully Alternative using blocTest',
      build: () {
        setUpMockInputConverterSuccess();
        when(getConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        isA<Loading>(),
        isA<Loaded>(),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when data is fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(getConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>(),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(getConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arange
      when(getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia());
      // assert
      verify(getRandomNumberTrivia());
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arange
      when(getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully Alternative using blocTest',
      build: () {
        when(getRandomNumberTrivia())
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        isA<Loading>(),
        isA<Loaded>(),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when data is fails',
      build: () {
        when(getRandomNumberTrivia())
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        isA<Loading>(),
        isA<Error>(),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message when getting data fails',
      build: () {
        when(getRandomNumberTrivia())
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (newBloc) {
        newBloc.add(GetTriviaForRandomNumber());
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ],
    );
  });
}
