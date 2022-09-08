import 'dart:convert';

import 'package:clean_architecture_tutorial/feature/number_trivia/data/dataSource/NumberTriviaLocalDataSource.dart';
import 'package:clean_architecture_tutorial/feature/number_trivia/data/model/number_trivia_model.dart';
import 'package:clean_architecture_tutorial/library/error/exception.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      // arange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw CacheException when there is not a cached value', () async {
      // arange
      when(mockSharedPreferences.getString(any))
          .thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(call, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Trivia');

    test('should call SharedPreferences to cache the data', () async {
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}