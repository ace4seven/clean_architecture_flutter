import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture_tutorial/library/error/exception.dart';
import 'package:clean_architecture_tutorial/library/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/domain/datasource/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tutorial/library/platform/network_info.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDatasource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl? repository;
  MockNumberTriviaRemoteDatasource? mockRemoteDataSource;
  MockNumberTriviaLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDatasource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });
      body;
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      body;
    });
  }

  group("Get Concrete Number Trivia", () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
        "should check if the device is online", () async {
      // arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository!.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successfull', () async {
        // arange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache the data localy when the call to remote data source is successfull', () async {
        // arange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached value when cached data is presented', () async {
        // arange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should return cache exception when there is not cached data presented', () async {
        // arange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group("Get Random Number Trivia", () {
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
        "should check if the device is online", () async {
      // arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource!.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository!.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successfull', () async {
        // arange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache the data localy when the call to remote data source is successfull', () async {
        // arange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository!.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached value when cached data is presented', () async {
        // arange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should return cache exception when there is not cached data presented', () async {
        // arange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
